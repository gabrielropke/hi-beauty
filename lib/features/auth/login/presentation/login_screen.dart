import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_message.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/constants/app_images.dart';
import 'package:hibeauty/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/theme/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(context)..add(LoginLoadRequested()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  String brandApp = 'Hi Agenda e Gestão';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadBranding();
  }

  void _loadBranding() async {
    print('🚀 [_loadBranding] Iniciando carregamento do branding...');
    try {
      print('📦 [_loadBranding] Chamando BrandLoader.load()...');
      final Map<String, dynamic> brandMap = await BrandLoader.load();
      print('✅ [_loadBranding] BrandLoader.load() concluído com sucesso!');
      print('📋 [_loadBranding] brandMap: $brandMap');
      
      final displayName = brandMap['displayName'];
      print('🏷️ [_loadBranding] displayName extraído: $displayName');
      
      if (mounted) {
        print('🔄 [_loadBranding] Widget ainda montado, atualizando estado...');
        setState(() {
          brandApp = displayName ?? 'Hi Agenda e Gestão';
        });
        print('✨ [_loadBranding] Estado atualizado! brandApp: $brandApp');
      } else {
        print('⚠️ [_loadBranding] Widget não está montado, pulando setState');
      }
    } catch (e, stackTrace) {
      print('❌ [_loadBranding] Erro ao carregar branding: $e');
      print('📊 [_loadBranding] Stack trace: $stackTrace');
      // Se falhar o carregamento da marca, mantém o valor padrão
      if (mounted) {
        setState(() {
          brandApp = 'Hi Agenda e Gestão';
        });
      }
    }
    print('🏁 [_loadBranding] Método finalizado!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is! LoginLoaded) return const AppLoader();

          final l10n = AppLocalizations.of(context)!;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Image.asset(AppImages.logo, height: 40),
                    SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l10n.loginToAccount,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l10n.loginToAccountDescription,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 42),

                    _EmailPasswordForm(
                      state: state,
                      l10n: l10n,
                      emailController: emailController,
                      passwordController: passwordController,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppMessage(
                        key: const ValueKey('msg'),
                        label: state.message,
                        type: MessageType.failure,
                        function: () =>
                            context.read<LoginBloc>().add(CloseMessage()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppButton(
                        loading: state.loginLoading,
                        label: l10n.continueLabel,
                        function: () {
                          final errorMessage = validateLoginInputs(
                            emailController.text,
                            passwordController.text,
                            l10n,
                          );

                          if (errorMessage != null) {
                            context.read<LoginBloc>().add(
                              SetMessage(errorMessage),
                            );
                            return;
                          }

                          context.read<LoginBloc>().add(
                            LoginRequest(
                              emailController.text,
                              passwordController.text,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => context.push(AppRoutes.register),
                          child: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                  children: [
                                    TextSpan(text: '${l10n.dontHaveAccount} '),
                                    TextSpan(
                                      text: l10n.clickHere,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DividerWithText(l10n: l10n),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _SocialLoginButton(l10n: l10n, state: state),
                    ),
                    SizedBox(height: 32),
                    Text(
                      '© ${DateTime.now().year} $brandApp',
                      style: TextStyle(color: Colors.black45, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _forgotPassword(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Align(
      alignment: Alignment.topRight,
      child: AppButton(
        width: 180,
        height: 40,
        fillColor: Colors.transparent,
        mainAxisAlignment: MainAxisAlignment.end,
        label: AppLocalizations.of(context)!.forgotPassword,
        labelStyle: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
        function: () => context.push(AppRoutes.forgotPassword),
      ),
    ),
  );
}

class _SocialLoginButton extends StatelessWidget {
  final LoginLoaded state;
  final AppLocalizations l10n;
  const _SocialLoginButton({required this.l10n, required this.state});

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
      function: () => context.read<LoginBloc>().add(GoogleSignIn()),
    );
  }
}

class _DividerWithText extends StatelessWidget {
  final AppLocalizations l10n;
  const _DividerWithText({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
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
      ),
    );
  }
}

class _EmailPasswordForm extends StatelessWidget {
  final LoginLoaded state;
  final AppLocalizations l10n;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const _EmailPasswordForm({
    required this.state,
    required this.l10n,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppTextformfield(
            error: state.message.isNotEmpty ? '' : null,
            controller: context
                .findAncestorStateOfType<_LoginViewState>()!
                .emailController,
            title: l10n.email,
            hintText: l10n.emailHint,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
        ),
        _EmailDomainSuggestions(controller: emailController),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppTextformfield(
            error: state.message.isNotEmpty ? '' : null,
            controller: context
                .findAncestorStateOfType<_LoginViewState>()!
                .passwordController,
            title: l10n.password,
            hintText: l10n.passwordHint,
            keyboardType: TextInputType.visiblePassword,
            obscureText: state.obscureText,
            type: TextFormFieldType.password,
            function: () =>
                loginBloc.add(ToggleVisiblePassword(!state.obscureText)),
            onEditingComplete: () {
              final errorMessage = validateLoginInputs(
                emailController.text,
                passwordController.text,
                l10n,
              );

              if (errorMessage != null) {
                context.read<LoginBloc>().add(SetMessage(errorMessage));
                return;
              }

              context.read<LoginBloc>().add(
                LoginRequest(emailController.text, passwordController.text),
              );
            },
          ),
        ),
        _forgotPassword(context),
      ],
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
                      labelStyle: TextStyle(fontSize: 12, color: Colors.black),
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

String? validateLoginInputs(
  String email,
  String password,
  AppLocalizations l10n,
) {
  if (email.trim().isEmpty) return l10n.incorrectUser;

  final emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  if (!emailRegex.hasMatch(email.trim())) return l10n.incorrectUser;

  if (password.trim().isEmpty) return l10n.incorrectUser;

  return null;
}
