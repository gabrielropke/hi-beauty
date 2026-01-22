import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_message.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/core/data/secure_storage.dart';
import 'package:hibeauty/core/data/subscription.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/onboarding/data/setup/model.dart';
import 'package:hibeauty/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:hibeauty/features/onboarding/presentation/sections/main_objective_business_data.dart';
import 'package:hibeauty/features/onboarding/presentation/sections/personal_business_data.dart';
import 'package:hibeauty/features/onboarding/presentation/sections/sub_segments_business_data.dart';
import 'package:hibeauty/features/onboarding/presentation/sections/team_size_business_data.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(context)..add(OnboardingLoadRequested()),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final TextEditingController nameBusinessController = TextEditingController();
  final TextEditingController slugBusinessController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String segmentsValue = '';
  List<String> subSegmentsValue = [];
  String mainObjective = '';
  String teamSize = '';

  bool isButtonEnabled = false;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _addListeners();
  }

  void _addListeners() {
    final controllers = [
      nameBusinessController,
      slugBusinessController,
      whatsappController,
    ];
    for (final controller in controllers) {
      controller.addListener(_validateInputs);
    }
  }

  bool _isValidPhoneFormat(String v) {
    final pattern = RegExp(r'^\(\d{2}\) \d{5}-\d{4}$');
    return pattern.hasMatch(v.trim());
  }

  void _validateInputs() {
    final name = nameBusinessController.text.trim();
    final slug = slugBusinessController.text.trim();
    final whatsapp = whatsappController.text.trim();

    final personalValid =
        name.isNotEmpty && slug.isNotEmpty && _isValidPhoneFormat(whatsapp);

    if (personalValid != isButtonEnabled) {
      setState(() => isButtonEnabled = personalValid);
    }
  }

  int _stepToIndex(Steps s) => Steps.values.indexOf(s);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: switch (state) {
              OnboardingLoading _ => const AppLoader(),
              OnboardingLoaded s => _loaded(s, context, l10n),
              _ => const AppLoader(),
            },
          ),
          bottomNavigationBar: state is OnboardingLoaded
              ? SafeArea(
                  top: false,
                  child: Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 1,
                        color: Colors.black.withValues(alpha: 0.1),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Column(
                          children: [
                            Builder(
                              builder: (_) {
                                final loaded = state;
                                final canProceed = _canProceed(loaded);
                                final isLast =
                                    loaded.step == Steps.mainObjective;
                                return AppButton(
                                  loading: state.loading,
                                  label: l10n.continueLabel,
                                  fillColor: AppColors.primary.withValues(
                                    alpha: canProceed
                                        ? 1.0
                                        : (state.step == Steps.nameAndSlug
                                              ? 1
                                              : 0.2),
                                  ),
                                  function: () async {
                                    FocusScope.of(context).unfocus();
                                    context.read<OnboardingBloc>().add(
                                      CloseMessage(),
                                    );
                                    if (!canProceed) {
                                      // context.read<OnboardingBloc>().add(
                                      //   SetMessage({'error': 'Preencha todos os campos'}),
                                      // );

                                      final brand = await BrandLoader.load();
                                      final mainSegment = brand['mainSegment'];
                                      context.read<OnboardingBloc>().add(
                                        SetMessage({'error': '$mainSegment'}),
                                      );
                                      return;
                                    }
                                    if (!isLast) {
                                      context.read<OnboardingBloc>().add(
                                        const AdvanceStep(),
                                      );
                                    } else {
                                      final brand = await BrandLoader.load();
                                      final mainSegment = brand['mainSegment'];

                                      context.read<OnboardingBloc>().add(
                                        CreateSetupBasic(
                                          SetupBasicModel(
                                            name: nameBusinessController.text
                                                .trim(),
                                            slug: slugBusinessController.text
                                                .trim(),
                                            whatsapp: whatsappController.text
                                                .trim(),
                                            instagram: instagramController.text
                                                .trim(),
                                            description: descriptionController
                                                .text
                                                .trim(),
                                            segment: mainSegment,
                                            subSegments:
                                                loaded.selectedSubSegmentKey!,
                                            teamSize:
                                                loaded.selectedTeamSizeKey!,
                                            mainObjective: loaded
                                                .selectedMainObjectiveKey!,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                            if (state.step == Steps.nameAndSlug)
                              AppButton(
                                loading: state.loading,
                                label: 'Sair da conta',
                                labelColor: Colors.black,
                                labelStyle: TextStyle(),
                                fillColor: Colors.transparent,
                                function: () async {
                                  await SecureStorage.clearAll();
                                  UserService().clearUser();
                                  BusinessService().clearBusiness();
                                  SubscriptionService().clearSubscription();
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.clear();

                                  context.go(AppRoutes.login);

                                  developer.log(
                                    'User logged out successfully',
                                    name: 'Auth',
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _loaded(
    OnboardingLoaded state,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final targetIndex = _stepToIndex(state.step);
    if (_pageController.hasClients &&
        _pageController.page != targetIndex.toDouble()) {
      _pageController.jumpToPage(targetIndex);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 24,
              bottom: state.message.values.first.isNotEmpty ? 16 : 0,
            ),
            child: AppMessage(
              key: const ValueKey('msg'),
              label: state.message.entries.first.value,
              type: MessageType.failure,
              function: () =>
                  context.read<OnboardingBloc>().add(CloseMessage()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _StepsIndicator(active: state.step),
          ),
          if (state.step != Steps.nameAndSlug) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back_outlined, size: 20),
                onPressed: () =>
                    context.read<OnboardingBloc>().add(const BackStep()),
              ),
            ),
          ],

          const SizedBox(height: 16),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PersonalBusinessData(
                  state: state,
                  nameBusinessController: nameBusinessController,
                  slugBusinessController: slugBusinessController,
                  whatsappController: whatsappController,
                  instagramController: instagramController,
                  descriptionController: descriptionController,
                ),
                SubSegmentsBusinessData(state: state),
                TeamSizeBusinessData(state: state),
                MainObjectiveBusinessData(state: state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed(OnboardingLoaded state) {
    switch (state.step) {
      case Steps.nameAndSlug:
        return nameBusinessController.text.trim().isNotEmpty &&
            slugBusinessController.text.trim().isNotEmpty &&
            _isValidPhoneFormat(whatsappController.text);
      case Steps.subsegments:
        return (state.selectedSubSegmentKey != null &&
            state.selectedSubSegmentKey!.isNotEmpty);
      case Steps.teamSize:
        return state.selectedTeamSizeKey != null;
      case Steps.mainObjective:
        return state.selectedMainObjectiveKey != null;
    }
  }
}

class _StepsIndicator extends StatelessWidget {
  final Steps active;
  const _StepsIndicator({required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: Steps.values.map((s) {
        final isActive = s == active;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            height: 3,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.secondary
                  : Colors.black.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }).toList(),
    );
  }
}
