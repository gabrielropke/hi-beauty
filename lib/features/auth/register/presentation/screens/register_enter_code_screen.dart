import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/features/auth/components/code_field.dart';
import 'package:hibeauty/features/auth/components/timer.dart';
import 'package:hibeauty/features/auth/register/data/model.dart';
import 'package:hibeauty/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class RegisterEnterCodeScreen extends StatelessWidget {
  final RegisterRequestModel args;
  const RegisterEnterCodeScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(context)..add(RegisterLoadRequested()),
      child: RegisterEnterCodeView(args: args),
    );
  }
}

class RegisterEnterCodeView extends StatefulWidget {
  final RegisterRequestModel args;
  const RegisterEnterCodeView({super.key, required this.args});

  @override
  State<RegisterEnterCodeView> createState() => _RegisterEnterCodeViewState();
}

class _RegisterEnterCodeViewState extends State<RegisterEnterCodeView> {
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
      body: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          if (state is! RegisterLoaded) return const AppLoader();

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
                      const SizedBox(height: 24),
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
                        opacity: state.registerLoading ? 0.3 : 1.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return CodeField(
                              codeIsValid: state.message.isEmpty,
                              enabled: !state.registerLoading,
                              controllers: controllers,
                              focusNodes: focusNodes,
                              index: index,
                              onEditingComplete: () =>
                                  context.read<RegisterBloc>().add(
                                    VerifyCodeRequested(
                                      RegisterRequestModel(
                                        email: widget.args.email,
                                        whatsapp: widget.args.whatsapp,
                                        password: widget.args.password,
                                        emailCode: controllers
                                            .map((c) => c.text)
                                            .join(),
                                        name: widget.args.name,
                                        howDidYouKnowUs: widget
                                            .args
                                            .howDidYouKnowUs
                                            .toUpperCase(),
                                        referrerPhone:
                                            state.referrerInfo?.referrerPhone ??
                                            '',
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
                          opacity: state.registerLoading ? 0.3 : 1.0,
                          child: Text(
                            state.message,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 24),
                      AppButton(
                        loading: state.registerLoading,
                        label: l10n.confirm,
                        function: () => context.read<RegisterBloc>().add(
                          VerifyCodeRequested(
                            RegisterRequestModel(
                              email: widget.args.email,
                              whatsapp: widget.args.whatsapp,
                              password: widget.args.password,
                              emailCode: controllers.map((c) => c.text).join(),
                              name: widget.args.name,
                              howDidYouKnowUs: widget.args.howDidYouKnowUs
                                  .toUpperCase(),
                              referrerPhone:
                                  state.referrerInfo?.referrerPhone ?? '',
                            ),
                          ),
                        ),
                      ),

                      if (state.timerController != null)
                        TimerWidget(
                          controller: state.timerController!,
                          function: () =>
                              context.read<RegisterBloc>().add(StartTimer()),
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
