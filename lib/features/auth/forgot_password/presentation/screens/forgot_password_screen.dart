import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_back_button.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_message.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/features/auth/forgot_password/data/model.dart';
import 'package:hibeauty/features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ForgotPasswordBloc(context)..add(ForgotPasswordLoadRequested()),
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    _emailFocus.dispose();
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
                    AppBackButton(),
                    const SizedBox(height: 12),
                    Text(
                      l10n.forgotPasswordTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      l10n.forgotPasswordDescription,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 24),
                    AppMessage(
                      key: const ValueKey('msg'),
                      label: state.message.entries.first.value,
                      type: MessageType.failure,
                      function: () => context.read<ForgotPasswordBloc>().add(
                        CloseMessage(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _EmailPasswordForm(state: state, l10n: l10n, emailController: emailController),
                    const SizedBox(height: 20),
                    AppButton(
                      loading: state.loading,
                      label: l10n.entry,
                      function: () => context.read<ForgotPasswordBloc>().add(
                        SendCodeRequested(ForgotPasswordModel(email: emailController.text.trim(), password: '', emailCode: '')),
                      ),
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

class _EmailPasswordForm extends StatelessWidget {
  final ForgotPasswordLoaded state;
  final AppLocalizations l10n;
  final TextEditingController emailController;
  const _EmailPasswordForm({
    required this.state,
    required this.l10n,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextformfield(
          error: state.message.entries.first.value.isNotEmpty ? '' : null,
          controller: context
              .findAncestorStateOfType<_ForgotPasswordViewState>()!
              .emailController,
          title: l10n.email,
          hintText: l10n.emailHint,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => context.read<ForgotPasswordBloc>().add(
            SendCodeRequested(ForgotPasswordModel(email: emailController.text.trim(), password: '', emailCode: '')),
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 12, right: 4),
            child: Icon(
              Icons.alternate_email_sharp,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
