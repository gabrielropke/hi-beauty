import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_back_button.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/features/auth/components/code_field.dart';
import 'package:hibeauty/features/auth/components/timer.dart';
import 'package:hibeauty/features/auth/forgot_password/data/model.dart';
import 'package:hibeauty/features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class ForgotPasswordEnterCodeScreen extends StatelessWidget {
  final ForgotPasswordModel args;
  const ForgotPasswordEnterCodeScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ForgotPasswordBloc(context)..add(ForgotPasswordLoadRequested()),
      child: ForgotPasswordEnterCodeView(args: args),
    );
  }
}

class ForgotPasswordEnterCodeView extends StatefulWidget {
  final ForgotPasswordModel args;
  const ForgotPasswordEnterCodeView({super.key, required this.args});

  @override
  State<ForgotPasswordEnterCodeView> createState() =>
      _ForgotPasswordEnterCodeViewState();
}

class _ForgotPasswordEnterCodeViewState
    extends State<ForgotPasswordEnterCodeView> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final ValueNotifier<bool> canProceed = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    for (final c in controllers) {
      c.addListener(() {
        canProceed.value = controllers.map((c) => c.text).join().length == 6;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    canProceed.dispose();
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
            child: Container(
              color: Colors.transparent,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBackButton(),
                      const SizedBox(height: 12),
                      Text(
                        l10n.verifyEmail,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.verifyEmailDescription(widget.args.email),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 24),
                      Opacity(
                        opacity: state.loading ? 0.3 : 1.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return CodeField(
                              codeIsValid:
                                  state.message.entries.first.value.isEmpty,
                              enabled: !state.loading,
                              controllers: controllers,
                              focusNodes: focusNodes,
                              index: index,
                              onEditingComplete: () =>
                                  context.read<ForgotPasswordBloc>().add(
                                    VerifyCodeRequested(
                                      ForgotPasswordModel(
                                        email: widget.args.email,
                                        password: widget.args.password,
                                        emailCode: controllers
                                            .map((c) => c.text)
                                            .join(),
                                      ),
                                    ),
                                  ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 6),
                      if (state.message.isNotEmpty)
                        Opacity(
                          opacity: state.loading ? 0.3 : 1.0,
                          child: Text(
                            state.message.entries.first.value,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 24),
                      AppButton(
                        loading: state.loading,
                        label: l10n.confirm,
                        function: () => context.read<ForgotPasswordBloc>().add(
                          VerifyCodeRequested(
                            ForgotPasswordModel(
                              email: widget.args.email,
                              password: widget.args.password,
                              emailCode: controllers.map((c) => c.text).join(),
                            ),
                          ),
                        ),
                      ),

                      if (state.timerController != null)
                        TimerWidget(
                          controller: state.timerController!,
                          function: () => context
                              .read<ForgotPasswordBloc>()
                              .add(StartTimer()),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
