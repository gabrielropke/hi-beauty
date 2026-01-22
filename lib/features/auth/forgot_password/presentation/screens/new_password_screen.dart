import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_message.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/features/auth/components/requirements_box.dart';
import 'package:hibeauty/features/auth/forgot_password/data/model.dart';
import 'package:hibeauty/features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class NewPasswordScreen extends StatelessWidget {
  final ForgotPasswordModel args;
  const NewPasswordScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ForgotPasswordBloc(context)..add(ForgotPasswordLoadRequested()),
      child: NewPasswordView(args: args),
    );
  }
}

class NewPasswordView extends StatefulWidget {
  final ForgotPasswordModel args;
  const NewPasswordView({super.key, required this.args});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          if (state is! ForgotPasswordLoaded) return const AppLoader();

          final l10n = AppLocalizations.of(context)!;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.resetPassword,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppMessage(
                      key: const ValueKey('msg'),
                      label: state.message.entries.first.value,
                      type: MessageType.failure,
                      function: () => context.read<ForgotPasswordBloc>().add(
                        CloseMessage(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _EmailPasswordForm(
                      state: state,
                      l10n: l10n,
                      passwordController: passwordController,
                    ),
                    const SizedBox(height: 12),
                    RequirementsBox(values: state.password.metRules),
                    const SizedBox(height: 20),
                    AppButton(
                      enabled: _validatePassword(passwordController.text),
                      loading: state.loading,
                      label: l10n.confirm,
                      function: () => context.read<ForgotPasswordBloc>().add(
                        ResetPasswordRequest(
                          ForgotPasswordModel(
                            email: widget.args.email,
                            password: passwordController.text.trim(),
                            emailCode: widget.args.emailCode,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      enabled: _validatePassword(passwordController.text),
                      loading: state.loading,
                      label: l10n.cancel,
                      fillColor: Colors.white,
                      labelColor: Colors.black54,
                      borderColor: Colors.black.withValues(alpha: 0.12),
                      function: () => context.go(AppRoutes.login),
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

  bool _validatePassword(String password) {
    if (password.length < 6) return false;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\[\]\\;/+=]').hasMatch(password)) {
      return false;
    }
    return true;
  }
}

class _EmailPasswordForm extends StatelessWidget {
  final ForgotPasswordLoaded state;
  final AppLocalizations l10n;
  final TextEditingController passwordController;
  const _EmailPasswordForm({
    required this.state,
    required this.l10n,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextformfield(
          error: state.message.entries.first.value.isNotEmpty ? '' : null,
          controller: context
              .findAncestorStateOfType<_NewPasswordViewState>()!
              .passwordController,
          title: l10n.password,
          hintText: l10n.passwordHint,
          keyboardType: TextInputType.visiblePassword,
          obscureText: state.obscureText,
          type: TextFormFieldType.password,
          function: () => context.read<ForgotPasswordBloc>().add(
            ToggleVisiblePassword(!state.obscureText),
          
          ),
          onChanged: (val) => context.read<ForgotPasswordBloc>().add(
            PasswordChanged(passwordController.text),
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 12, right: 4),
            child: Icon(Icons.lock_open_rounded, color: Colors.grey, size: 20),
          ),
        ),
      ],
    );
  }
}
