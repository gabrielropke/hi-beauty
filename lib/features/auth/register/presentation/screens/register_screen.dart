import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/core/components/app_label_terms.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/core/constants/app_images.dart';
import 'package:hibeauty/core/constants/formatters/phone.dart';
import 'package:hibeauty/features/auth/components/requirements_box.dart';
import 'package:hibeauty/features/auth/register/data/model.dart';
import 'package:hibeauty/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(context)..add(RegisterLoadRequested()),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final whatsappController = TextEditingController();
  final referrerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isButtonEnabled = false;
  bool indicatorSelected = false;
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    fullNameController.addListener(_validateInputs);
    emailController.addListener(_validateInputs);
    passwordController.addListener(_validateInputs);
    whatsappController.addListener(_validateInputs);
  }

  void _validateInputs() {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final phoneRaw = whatsappController.text;

    // Remove todos caracteres que não são números
    final phone = phoneRaw.replaceAll(RegExp(r'[^0-9]'), '');
    final selected = selectedValue;

    final emailValid = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email);

    final passwordValid = _validatePassword(password);

    final phoneValid = phone.length == 11;

    final enabled =
        fullName.isNotEmpty &&
        emailValid &&
        passwordValid &&
        phoneValid &&
        (selected != null && selected.isNotEmpty);

    if (enabled != isButtonEnabled) {
      setState(() => isButtonEnabled = enabled);
    }
  }

  bool _validatePassword(String password) {
    if (password.length < 6) return false;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\[\]\\;/+=]').hasMatch(password)) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    whatsappController.dispose();
    referrerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          if (state is! RegisterLoaded) return const AppLoader();

          final l10n = AppLocalizations.of(context)!;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                CustomAppBar(
                  title: l10n.registerToAccount,
                  controller: _scrollController,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            l10n.registerToAccount,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _EmailPasswordForm(
                          state: state,
                          l10n: l10n,
                          fullNameController: fullNameController,
                          emailController: emailController,
                          passwordController: passwordController,
                          whatsappController: whatsappController,
                          referrerController: referrerController,
                          selectedValue: selectedValue ?? '',
                          onDropdownChanged: (val) {
                            setState(() => selectedValue = val.toString());
                            _validateInputs();
                          },
                          indicatorSelected: indicatorSelected,
                          onIndicatorChanged: (value) {
                            setState(() => indicatorSelected = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AppButton(
                            enabled: isButtonEnabled,
                            loading: state.registerLoading,
                            label: l10n.createAccount,
                            function: () {
                              FocusScope.of(context).unfocus();

                              final cleanWhatsapp = whatsappController.text
                                  .replaceAll(RegExp(r'[^0-9]'), '');

                              // selectedValue continua sendo o code
                              context.read<RegisterBloc>().add(
                                SendCodeRequested(
                                  RegisterRequestModel(
                                    name: fullNameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text,
                                    whatsapp: cleanWhatsapp,
                                    howDidYouKnowUs:
                                        selectedValue!, // code enviado
                                    emailCode: '',
                                    referrerPhone:
                                        state.referrerInfo?.referrerPhone ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _DividerWithText(l10n: l10n),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _SocialRegisterButton(
                            l10n: l10n,
                            state: state,
                          ),
                        ),

                        SizedBox(height: 12),
                        const AppLabelTerms(),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------- WIDGETS ----------------------

class _SocialRegisterButton extends StatelessWidget {
  final RegisterLoaded state;
  final AppLocalizations l10n;
  const _SocialRegisterButton({required this.l10n, required this.state});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      fillColor: Colors.white,
      borderColor: Colors.grey[300],
      labelColor: Colors.grey[800],
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.center,
      label: l10n.continueWithGoogle,
      loading: state.googleLoading,
      preffixIcon: SvgPicture.asset(AppImages.google, width: 20),
      function: () => context.read<RegisterBloc>().add(GoogleSignIn()),
    );
  }
}

class _DividerWithText extends StatelessWidget {
  final AppLocalizations l10n;
  const _DividerWithText({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            l10n.or.toLowerCase(),
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
      ],
    );
  }
}

final itemsFoundUs = [
  {"code": "INSTAGRAM", "label": "Instagram"},
  {"code": "FACEBOOK", "label": "Facebook"},
  {"code": "GOOGLE", "label": "Google"},
  {"code": "WHATSAPP", "label": "Whatsapp"},
  {"code": "YOUTUBE", "label": "Youtube"},
  {"code": "TIKTOK", "label": "Tiktok"},
  {"code": "FRIEND", "label": "Friend"},
  {"code": "FAMILY", "label": "Family"},
  {"code": "INFLUENCER", "label": "Influencer"},
  {"code": "ADVERTISEMENT", "label": "Advertisement"},
  {"code": "BLOG", "label": "Blog"},
  {"code": "PODCAST", "label": "Podcast"},
  {"code": "EVENT", "label": "Event"},
  {"code": "OTHER", "label": "Outro"},
];

class _EmailPasswordForm extends StatefulWidget {
  final RegisterLoaded state;
  final AppLocalizations l10n;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController whatsappController;
  final TextEditingController referrerController;
  final ValueChanged<Object?>? onDropdownChanged;
  final String selectedValue;
  final bool indicatorSelected;
  final ValueChanged<bool>? onIndicatorChanged;

  const _EmailPasswordForm({
    required this.state,
    required this.l10n,
    required this.emailController,
    required this.passwordController,
    required this.fullNameController,
    required this.whatsappController,
    required this.referrerController,
    required this.onDropdownChanged,
    required this.selectedValue,
    required this.indicatorSelected,
    this.onIndicatorChanged,
  });

  @override
  State<_EmailPasswordForm> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  @override
  Widget build(BuildContext context) {
    final registerBloc = context.read<RegisterBloc>();

    Widget buildTextField({
      required TextEditingController controller,
      required String title,
      required String hint,
      required Icon icon,
      TextInputType? keyboardType,
      bool obscureText = false,
      TextInputAction? textInputAction,
      Function()? onTapSuffix,
      dynamic formatter,
      String? error,
      Function(String)? onChanged,
      Function()? onEditingComplete,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AppTextformfield(
          controller: controller,
          title: title,
          hintText: hint,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textInputFormatter: formatter,
          obscureText: obscureText,
          function: onTapSuffix,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          error: error,
        ),
      );
    }

    return Column(
      children: [
        buildTextField(
          controller: widget.fullNameController,
          title: widget.l10n.name,
          hint: widget.l10n.nameHint,
          icon: const Icon(
            Icons.person_outline_rounded,
            color: Colors.grey,
            size: 20,
          ),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          error: widget.state.message.isNotEmpty ? '' : null,
        ),
        const SizedBox(height: 24),
        buildTextField(
          controller: widget.emailController,
          title: widget.l10n.email,
          hint: widget.l10n.emailHint,
          icon: const Icon(
            Icons.alternate_email_sharp,
            color: Colors.grey,
            size: 20,
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          error: widget.state.message.isNotEmpty ? '' : null,
        ),
        _EmailDomainSuggestions(controller: widget.emailController),
        const SizedBox(height: 24),
        buildTextField(
          controller: widget.passwordController,
          title: widget.l10n.password,
          hint: widget.l10n.passwordHint,
          icon: const Icon(
            Icons.lock_open_rounded,
            color: Colors.grey,
            size: 20,
          ),
          obscureText: widget.state.obscureText,
          textInputAction: TextInputAction.next,
          onTapSuffix: () => registerBloc.add(
            ToggleVisiblePassword(!widget.state.obscureText),
          ),
          onChanged: (val) => registerBloc.add(PasswordChanged(val)),
          error: widget.state.message.isNotEmpty ? widget.state.message : null,
        ),
        if (widget.passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RequirementsBox(values: widget.state.password.metRules),
          ),
        ],
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              Expanded(
                child: buildTextField(
                  controller: widget.whatsappController,
                  title: widget.l10n.whatsapp,
                  hint: widget.l10n.whatsappHint,
                  icon: const Icon(
                    Icons.phone_android_rounded,
                    color: Colors.grey,
                    size: 20,
                  ),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  formatter: PhoneFormatter(mask: '(##) #####-####'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppDropdown(
                  title: widget.l10n.howGetHere,
                  items: itemsFoundUs,
                  labelKey: 'label',
                  valueKey: 'code',
                  placeholder: Text(
                    widget.selectedValue.isEmpty
                        ? widget.l10n.select
                        : (itemsFoundUs.firstWhere(
                                (e) => e['code'] == widget.selectedValue,
                              )['label']
                              as String),
                  ),
                  onChanged: widget.onDropdownChanged,
                  borderRadius: 12,
                  borderWidth: 1,
                  dropdownMaxHeight: 280,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<RegisterBloc>().add(
                        EnableIndicator(!widget.state.indicatorEnabled),
                      );
                      widget.referrerController.clear();
                    },
                    child: Icon(
                      widget.state.indicatorEnabled
                          ? Icons.check_box
                          : LucideIcons.square300,
                      size: 24,
                      color: widget.state.indicatorEnabled
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                  ),
                  Text('Fui indicado(a) por alguém'),
                ],
              ),
              Text(
                'Selecione caso algum amigo(a) tenha indicado o app para você.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),

        if (widget.state.indicatorEnabled) ...[
          if (widget.state.referrerInfo == null ||
              widget.state.referrerInfo!.referrerName.isEmpty) ...[
            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AppTextformfield(
                controller: widget.referrerController,
                title: 'Telefone de quem te indicou',
                hintText: widget.l10n.whatsappHint,
                error: widget.state.referrerMessage.isNotEmpty
                    ? widget.state.referrerMessage
                    : null,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 4.0),
                  child: Icon(
                    LucideIcons.usersRound300,
                    color: Colors.grey.shade700,
                    size: 20,
                  ),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                textInputFormatter: PhoneFormatter(mask: '(##) #####-####'),
                onChanged: (value) {
                  final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (cleanValue.length == 11) {
                    registerBloc.add(ValidateReferrerPhone(cleanValue));
                  }
                },
              ),
            ),
          ],

          _referrerViewUser(widget.state.referrerInfo),
        ],
      ],
    );
  }

  Widget _referrerViewUser(ReferrerData? referrer) {
    return Visibility(
      visible: referrer != null && referrer.referrerName.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFFEFFDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(0xFF036630).withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF036630).withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.usersRound300,
                    size: 20,
                    color: Color(0xFF036630),
                  ),
                ),
              ),
              Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Indicado(a) por',
                    style: TextStyle(
                      color: Color(0xFF036630),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    referrer?.referrerName ?? '',
                    style: TextStyle(
                      color: Color(0xFF036630),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailDomainSuggestions extends StatelessWidget {
  final TextEditingController controller;
  const _EmailDomainSuggestions({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (_, value, __) {
        final text = value.text.trim();

        final domains = [
          '@gmail.com',
          '@hotmail.com',
          '@yahoo.com',
          '@outlook.com',
          '@icloud.com',
        ];

        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 10,
                children: domains.map((provider) {
                  final suggestion = '$text$provider';
                  return IntrinsicWidth(
                    child: AppButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: 34,
                      label: provider,
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      fillColor: Colors.transparent,
                      borderColor: Colors.black12,
                      function: () {
                        controller.text = suggestion;
                        controller.selection = TextSelection.collapsed(
                          offset: controller.text.length,
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
