import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/constants/global_top_infos.dart';
import 'package:hibeauty/core/data/subscription.dart';
import 'package:hibeauty/core/services/subscription/data/model.dart';
import 'package:hibeauty/features/functions/presentation/bloc/functions_bloc.dart';
import 'package:hibeauty/features/functions/presentation/components/card.dart';
import 'package:hibeauty/features/functions/presentation/components/pre_page_functions.dart';
import 'package:hibeauty/features/home/presentation/bloc/home_bloc.dart';
import 'package:hibeauty/features/home/presentation/components/top.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FunctionsScreen extends StatelessWidget {
  const FunctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FunctionsBloc(context)..add(FunctionsLoadRequested()),
      child: const FunctionsView(),
    );
  }
}

class FunctionsView extends StatefulWidget {
  const FunctionsView({super.key});

  @override
  State<FunctionsView> createState() => _FunctionsViewState();
}

class _FunctionsViewState extends State<FunctionsView> {
  bool _isShowingPopup = false;
  Timer? _popupCheckTimer;

  @override
  void initState() {
    super.initState();
    _updatePopupState();
    _startPopupStateChecker();
  }

  @override
  void dispose() {
    _popupCheckTimer?.cancel();
    super.dispose();
  }

  void _updatePopupState() {
    final newState = shouldShowSignature() || shouldShowCompleteBusinessData();
    if (_isShowingPopup != newState) {
      setState(() {
        _isShowingPopup = newState;
      });
    }
  }

  void _startPopupStateChecker() {
    _popupCheckTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      if (mounted) {
        _updatePopupState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<FunctionsBloc, FunctionsState>(
      builder: (context, state) {
        return Scaffold(
          body: switch (state) {
            FunctionsLoading _ => const AppLoader(),
            FunctionsLoaded s => _loaded(s, context, l10n, _isShowingPopup),
            _ => const AppLoader(),
          },
        );
      },
    );
  }

  Widget _loaded(
    FunctionsLoaded state,
    BuildContext context,
    AppLocalizations l10n,
    bool isShowingPopup,
  ) {
    final catalogOptions = [
      FunctionsCardOption(
        icon: LucideIcons.package,
        label: 'Serviços',
        route: AppRoutes.services,
      ),
      FunctionsCardOption(
        icon: LucideIcons.shoppingCart,
        label: 'Produtos',
        route: AppRoutes.products,
      ),
      FunctionsCardOption(
        icon: LucideIcons.gift,
        label: 'Combos',
        route: AppRoutes.combos,
      ),
    ];

    final businessOptions = [
      FunctionsCardOption(
        icon: LucideIcons.databaseZap,
        label: 'Dados cadastrais',
        route: AppRoutes.businessConfig,
      ),
      FunctionsCardOption(
        icon: LucideIcons.userRoundCog400,
        label: 'Equipe',
        route: AppRoutes.team,
      ),
      FunctionsCardOption(
        icon: LucideIcons.calendarClock,
        label: 'Regras de agendamento',
        route: AppRoutes.businessRoles,
      ),
      FunctionsCardOption(
        icon: LucideIcons.timer,
        label: 'Horários e turnos',
        route: AppRoutes.businessHours,
      ),
      // FunctionsCardOption(
      //   icon: LucideIcons.creditCard,
      //   label: 'Pagamentos',
      //   disable: true,
      //   inDevelopment: true,
      // ),
    ];

    // Opções do card "Principal"
    final mainOptions = [
      FunctionsCardOption(
        icon: LucideIcons.house,
        label: 'Início',
        onTap: () =>
            context.read<HomeBloc>().add(ChangeTab(HomeTabs.dashboard)),
      ),
      FunctionsCardOption(
        icon: LucideIcons.calendarRange,
        label: 'Agendamentos',
        onTap: () =>
            context.read<HomeBloc>().add(ChangeTab(HomeTabs.schedules)),
      ),
      FunctionsCardOption(
        icon: LucideIcons.usersRound400,
        label: 'Clientes',
        onTap: () => context.push(AppRoutes.customers),
      ),
      FunctionsCardOption(
        icon: LucideIcons.package400,
        label: 'Catálogo',
        onTap: () => context.push(
          AppRoutes.prePageFunctions,
          extra: PrePageFunctionsArgs(
            title: 'Catálogo',
            options: catalogOptions,
            leadingIcon: LucideIcons.building2400,
            titlePage: l10n.catalogConfig,
            descriptionPage: l10n.catalogConfigDescription,
          ),
        ),
      ),

      // FunctionsCardOption(
      //   icon: LucideIcons.trendingUp,
      //   label: 'Marketing',
      //   disable: true,
      // ),

      // FunctionsCardOption(
      //   icon: LucideIcons.dollarSign,
      //   label: 'Vendas',
      //   disable: true,
      // ),
      FunctionsCardOption(
        icon: LucideIcons.building2400,
        label: 'Meu negócio',
        onTap: () => context.push(
          AppRoutes.prePageFunctions,
          extra: PrePageFunctionsArgs(
            title: 'Meu negócio',
            options: businessOptions,
            leadingIcon: LucideIcons.building2400,
            titlePage: l10n.businessConfig,
            descriptionPage: l10n.businessConfigDescription,
          ),
        ),
      ),
      // FunctionsCardOption(
      //   icon: LucideIcons.plug,
      //   label: 'Integrações',
      //   disable: true,
      // ),
      FunctionsCardOption(
        route: SubscriptionData.statusEnum == SubscriptionStatus.ACTIVE
            ? AppRoutes.mysignature
            : AppRoutes.signature,
        icon: SubscriptionData.statusEnum == SubscriptionStatus.TRIALING
            ? LucideIcons.crown
            : SubscriptionData.statusEnum == SubscriptionStatus.ACTIVE
            ? LucideIcons.badgeCheck400
            : LucideIcons.crown,
        label: 'Assinatura',
        visible:
            SubscriptionData.statusEnum == SubscriptionStatus.ACTIVE ||
            shouldShowSignature(),
        isPro: true,
        iconColor: SubscriptionData.statusEnum == SubscriptionStatus.ACTIVE
            ? Colors.green
            : Colors.orange,
      ),
    ];
    // Opções do card "Meu negócio"

    return SingleChildScrollView(
      child: SafeArea(
        top: !isShowingPopup,
        child: Column(
          children: [
            if (isShowingPopup) exibitionTopPopup(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  HomeTop(),
                  SizedBox(height: 24),
                  FunctionsCard(
                    icon: LucideIcons.layoutDashboard,
                    title: l10n.principal,
                    options: mainOptions,
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
