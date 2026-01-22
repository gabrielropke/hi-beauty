import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/components/app_back_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/core/services/configuration_state_manager.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/business_config_provider.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/components/step_data.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/components/steps_header_mobile.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/components/progress_bar.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BusinessConfigScreen extends StatelessWidget {
  const BusinessConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BusinessConfigProvider(child: const BusinessConfigView());
  }
}

class BusinessConfigView extends StatefulWidget {
  const BusinessConfigView({super.key});

  @override
  State<BusinessConfigView> createState() => _BusinessConfigViewState();
}

class _BusinessConfigViewState extends State<BusinessConfigView> {
  int _currentStep = 0;
  late final BusinessService _businessService;

  @override
  void initState() {
    super.initState();
    _businessService = BusinessService();
    _businessService.addListener(_onBusinessDataChanged);

    // Listen to configuration state changes
    ConfigurationStateManager().isConfigurationCompleteNotifier.addListener(
      _onBusinessDataChanged,
    );

    // Refresh state when screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusinessConfigBloc>().add(BusinessConfigLoadRequested());
      ConfigurationStateManager().updateConfigurationState();
    });
  }

  @override
  void dispose() {
    _businessService.removeListener(_onBusinessDataChanged);
    ConfigurationStateManager().isConfigurationCompleteNotifier.removeListener(
      _onBusinessDataChanged,
    );
    super.dispose();
  }

  void _onBusinessDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocBuilder<BusinessConfigBloc, BusinessConfigState>(
        builder: (context, state) {
          return switch (state) {
            BusinessConfigLoading _ => const AppLoader(),
            BusinessConfigLoaded s => _loaded(s, context, l10n),
            BusinessConfigState() => const AppLoader(),
          };
        },
      ),
    );
  }

  Widget _loaded(
    BusinessConfigLoaded state,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    List<StepData> computeSteps() {
      return [
        StepData(
          number: 1,
          icon: LucideIcons.building2400,
          title: l10n.businessData,
          subtitle: l10n.businessDataSubtitle,
          completed:
              (BusinessData.name.isNotEmpty &&
              (BusinessData.segment?.isNotEmpty ?? false) &&
              (BusinessData.description?.isNotEmpty ?? false)),
          route: AppRoutes.businessData,
        ),
        StepData(
          number: 2,
          icon: LucideIcons.messageSquare500,
          title: l10n.whatsapp,
          subtitle: l10n.whatsappSubtitle,
          completed: BusinessData.whatsappConnected,
          route: AppRoutes.businessWhatsapp,
        ),
        StepData(
          number: 3,
          icon: LucideIcons.palette,
          title: l10n.customize,
          subtitle: l10n.customizeSubtitle,
          completed:
              ((BusinessData.logoUrl?.isNotEmpty ?? false) &&
              (BusinessData.themeColor?.isNotEmpty ?? false)),
          route: AppRoutes.businessCustomization,
        ),
        StepData(
          number: 4,
          icon: LucideIcons.mapPin400,
          title: l10n.address,
          subtitle: l10n.addressSubtitle,
          completed:
              ((BusinessData.address?.isNotEmpty ?? false) &&
              (BusinessData.city?.isNotEmpty ?? false) &&
              (BusinessData.state?.isNotEmpty ?? false) &&
              (BusinessData.zipCode?.isNotEmpty ?? false)),
          route: AppRoutes.businessAddress,
        ),
      ];
    }

    final steps = computeSteps();
    final completedCount = steps.where((s) => s.completed).length;
    final progress = steps.isEmpty ? 0.0 : completedCount / steps.length;
    final progressPercent = (progress * 100).round();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView(
          children: [
            AppBackButton(),
            SizedBox(height: 12),
            Text(
              l10n.businessSectionConfig,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              l10n.businessSectionConfigDescription,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 24),
            ProgressBar(value: progress, percent: progressPercent),
            SizedBox(height: 32),
            StepsHeaderMobile(
              steps: steps,
              currentStep: _currentStep,
              onSelect: (i) => setState(() => _currentStep = i),
              activeColor: AppColors.secondary,
              vertical: true,
            ),
          ],
        ),
      ),
    );
  }
}
