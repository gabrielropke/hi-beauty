import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/features/customers/presentation/customers_screen.dart';
import 'package:hibeauty/features/dashboard/presentation/dashboard_screen.dart';
import 'package:hibeauty/features/functions/presentation/functions_screen.dart';
import 'package:hibeauty/features/home/presentation/bloc/home_bloc.dart';
import 'package:hibeauty/features/home/presentation/components/navbar.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/schedules_screen.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/components/filter_type_calendar.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(context)..add(HomeLoadRequested()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _homeScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeLoading _ => const AppLoader(),
            HomeLoaded s => _loaded(s, context, l10n),
            HomeState() => const AppLoader(),
          };
        },
      ),
    );
  }

  Widget _loaded(
    HomeLoaded state,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    // Abre o drawer quando o estado mudar para showSchedulesDrawer = true
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.showSchedulesDrawer &&
          !(_homeScaffoldKey.currentState?.isDrawerOpen ?? false)) {
        _homeScaffoldKey.currentState?.openDrawer();
      }
    });

    return Scaffold(
      key: _homeScaffoldKey,
      body: IndexedStack(
        index: state.tab.index,
        children: [
          DashboardScreen(),
          SchedulesScreen(),
          CustomersScreen(buttonBottomEnabled: true),
          FunctionsScreen(),
        ],
      ),
      bottomNavigationBar: Navbar(currentTab: state.tab),
      drawer:
          state.showSchedulesDrawer &&
              state.schedulesState != null &&
              state.schedulesContext != null
          ? FilterTypeCalendar(
              bcontext: state.schedulesContext!,
              state: state.schedulesState,
            )
          : null,
      onDrawerChanged: (isOpened) {
        if (!isOpened && state.showSchedulesDrawer) {
          context.read<HomeBloc>().add(CloseSchedulesDrawer());
        }
      },
    );
  }
}
