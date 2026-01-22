import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/core/constants/formatters/money.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/core/data/secure_storage.dart';
import 'package:hibeauty/core/data/subscription.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/signature/bloc/signature_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateSignatureScreen extends StatelessWidget {
  const CreateSignatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignatureBloc(context)..add(SignatureLoadRequested()),
      child: const CreateSignatureView(),
    );
  }
}

class CreateSignatureView extends StatefulWidget {
  const CreateSignatureView({super.key});

  @override
  State<CreateSignatureView> createState() => _CreateSignatureViewState();
}

class _CreateSignatureViewState extends State<CreateSignatureView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<SignatureBloc, SignatureState>(
        builder: (context, state) => switch (state) {
          SignatureLoading _ => const AppLoader(),
          SignatureLoaded s => _buildLoadedView(s, l10n, context),
          SignatureState() => const AppLoader(),
        },
      ),
    );
  }

  Widget _buildLoadedView(
    SignatureLoaded state,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          CustomAppBar(
            title: 'Assinatura Pro',
            controller: _scrollController,
            backgroundColor: Colors.white,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  _buildTitle(),
                  _buildHeaderSection(),
                  _enableDiscountView(),
                  const SizedBox(),
                  _buildFeaturesTitle(),
                  ..._buildFeaturesList(),
                  const SizedBox(height: 8),
                  _iaDescription(),
                  const SizedBox(),
                  _indicationProgram(),
                  const SizedBox(),
                  _teamDescription(),

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
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();

                      context.go(AppRoutes.login);

                      developer.log(
                        'User logged out successfully',
                        name: 'Auth',
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildBottomButton(context, state),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, SignatureLoaded state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 50,
          top: 16,
          left: 32,
          right: 32,
        ),
        child: Column(
          spacing: 12,
          children: [
            if (SubscriptionData.billingCreditsAvailable > 0)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'De: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SORA',
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    TextSpan(
                      text: 'R\$49,90',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SORA',
                        fontWeight: FontWeight.w400,
                        color: Colors.black45,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: SubscriptionData.billingCreditsAvailable > 0
                        ? 'Por:  '
                        : '',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'SORA',
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  TextSpan(
                    text: SubscriptionData.billingCreditsAvailable > 0
                        ? 'R\$ 0,00 '
                        : 'R\$49,90 ',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'SORA',
                      fontWeight: FontWeight.w600,
                      color: SubscriptionData.billingCreditsAvailable > 0
                          ? Color(0xFF00A63E)
                          : Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '/mês*',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'SORA',
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (state.team.total - 1 > 0) _teamValues(context, state),
            AppButton(
              loading: state.loading,
              padding: EdgeInsets.symmetric(horizontal: 25),
              spacing: 12,
              preffixIcon: Icon(
                LucideIcons.crown,
                color: Colors.white,
                size: 20,
              ),
              label: 'Assinar agora',
              borderRadius: 16,
              function: () =>
                  context.read<SignatureBloc>().add(CreateCheckout()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.sparkles, size: 16, color: Colors.amber),
                const SizedBox(width: 6),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Mais de ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: '5.000',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' profissionais',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Assinatura Pro',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      spacing: 10,
      children: [_buildPremiumIcon(), _buildHeaderTexts()],
    );
  }

  Widget _buildPremiumIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(LucideIcons.crown, color: Colors.white),
    );
  }

  Widget _buildHeaderTexts() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plano de assinatura',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          'Tudo que você precisa para crescer',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesTitle() {
    return const Text(
      'Recursos inclusos',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  List<Widget> _buildFeaturesList() {
    final features = [
      'IA no WhatsApp',
      'Agendamentos ilimitados',
      'Gestão de clientes',
      'Link próprio para agendamentos',
      'Controle financeiro',
      'Relatórios avançados',
    ];

    return features.map((feature) => _buildFeatureItem(feature)).toList();
  }

  Widget _buildFeatureItem(String featureText) {
    return Row(
      spacing: 8,
      children: [
        const Icon(LucideIcons.check, size: 20),
        Text(
          featureText,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

Widget _iaDescription() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.deepPurple.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFF6366F1).withValues(alpha: 0.2),
        width: 1.5,
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(LucideIcons.bot, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'IA no WhatsApp',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'NOVO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Agendamentos automáticos, up-sells, suporte 24h e gestão completa de horários direto no WhatsApp!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _enableDiscountView() {
  return Visibility(
    visible: SubscriptionData.billingCreditsAvailable > 0,
    child: Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFFEFFDF4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(0xFF036630).withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.gift,
                    color: Color(0xFF036630),
                    size: 24,
                  ),
                  Text(
                    'Desconto por indicação',
                    style: TextStyle(
                      color: Color(0xFF036630),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 179, 255, 187),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.tag500,
                      color: Color(0xFF036630),
                      size: 14,
                    ),
                    Text(
                      '100% OFF',
                      style: TextStyle(
                        color: Color(0xFF036630),
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.calendar300,
                    color: Color(0xFF036630),
                    size: 14,
                  ),
                  Text(
                    '${SubscriptionData.billingCreditsAvailable} mês${SubscriptionData.billingCreditsAvailable > 1 ? 'es' : ''} de desconto disponível',
                    style: TextStyle(
                      color: Color(0xFF036630),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _teamValues(BuildContext context, SignatureLoaded state) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.blue.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.blue.withValues(alpha: 0.2), width: 1.5),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(LucideIcons.usersRound400, color: Colors.blueAccent, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Plano base:',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    'R\$ 49,90',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF193CB9),
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              if (state.team.total - 1 > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.team.total - 1 > 0
                          ? 'Colaboradores (${state.team.total - 1}x):'
                          : 'Colaboradores:',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                    Text(
                      'R\$ 19,90',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF193CB9),
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              if (SubscriptionData.billingCreditsAvailable > 0) ...[
                Divider(color: Colors.blueAccent, height: 12, thickness: 0.3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal:',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                            height: 1.4,
                          ),
                        ),
                        Text(
                          moneyFormat(
                            context,
                            ((state.team.total - 1) * 19.90 + 49.90)
                                .toStringAsFixed(2),
                          ),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            height: 1.4,
                            decorationColor: Colors.grey.shade700,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Desconto 1º mês:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 7, 133, 53),
                            height: 1.4,
                          ),
                        ),
                        Text(
                          '-${moneyFormat(context, ((state.team.total - 1) * 19.90 + 49.90).toStringAsFixed(2))}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 7, 133, 53),
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              Divider(color: Colors.blueAccent, height: 12, thickness: 0.3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    SubscriptionData.billingCreditsAvailable > 0
                        ? 'Total 1º mês:'
                        : 'Total:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    SubscriptionData.billingCreditsAvailable > 0
                        ? moneyFormat(context, '0')
                        : '${moneyFormat(context, ((state.team.total - 1) * 19.90 + 49.90).toStringAsFixed(2))} /mês',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF193CB9),
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _teamDescription() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.blue.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.blue.withValues(alpha: 0.2), width: 1.5),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF193CB9), Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(LucideIcons.users, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '+ R\$19,90',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                TextSpan(
                  text: '/mês por colaborador adicional',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _indicationProgram() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Color(0xFFFEFCE8),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Color(0xFFFFF39A), width: 1.5),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(LucideIcons.gift, color: Color(0xFF894B00), size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Ganhe 1 mês grátis ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF894B00),
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                TextSpan(
                  text: 'a cada 2 indicações',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF894B00),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
