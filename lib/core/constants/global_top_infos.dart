import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/data/subscription.dart';
import 'package:hibeauty/core/services/configuration_state_manager.dart';
import 'package:hibeauty/core/services/subscription/data/model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

bool shouldShowSignature() {
  // Verifica se está em trial e calcula os dias restantes
  final isTrialing = SubscriptionData.trialIsTrialing;
  final trialStartedAt = SubscriptionData.trialStartedAt;
  // DESCOMENTE AQUI SE QUISER TESTAR A EXIBIÇÃO MANUALMENTE E COMENTE A LINHA ACIMA
  // final trialStartedAt = DateTime.parse('2025-12-22T19:37:41.616Z');
  final trialTotalDays = SubscriptionData.trialTotalDays;

  int daysRemaining = 0;
  if (isTrialing && trialStartedAt != null && trialTotalDays > 0) {
    // Calcula a data de fim do trial: createdAt + totalDays
    final trialEndDate = trialStartedAt.add(Duration(days: trialTotalDays));
    final now = DateTime.now();
    final difference = trialEndDate.difference(now);
    daysRemaining = difference.inDays;
  }

  final shouldShowSignature = isTrialing && daysRemaining <= 2;

  // Se está em trial e faltam 2 dias ou menos, exibe activeSignature
  return shouldShowSignature;
}

bool shouldShowCompleteBusinessData() {
  return !ConfigurationStateManager().isConfigurationComplete;
}

bool signatueEnableView() {
  return shouldShowSignature();
}

Widget exibitionTopPopup(BuildContext context) {
  // Sempre exiba prioritariamente o signature se disponível
  if (shouldShowSignature()) {
    return activeSignature(context);
  }

  // Se não tiver signature, verifique se precisa mostrar completeBusinessData
  if (shouldShowCompleteBusinessData()) {
    return completeBusinessData(context);
  }

  // Se não precisa mostrar nenhum popup
  return const SizedBox.shrink();
}

Widget activeSignature(BuildContext context) {
  return Visibility(
    visible: SubscriptionData.statusEnum != SubscriptionStatus.ACTIVE,
    child: GestureDetector(
      onTap: () => context.push(AppRoutes.signature),
      child: Container(
        width: double.infinity,
        color: Color(0xFFFFC109),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Icon(LucideIcons.crown, size: 18, color: Colors.black),
                    Text(
                      'Ativar plano',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Icon(
                  LucideIcons.chevronRight400,
                  size: 18,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget completeBusinessData(BuildContext context) {
  return GestureDetector(
    onTap: () => context.push(AppRoutes.businessConfig),
    child: Container(
      width: double.infinity,
      color: Color(0xFF6850F2),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  Icon(
                    LucideIcons.rocket300,
                    size: 18,
                    color: Colors.white,
                  ),
                  Text(
                    'Continuar a configuração',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Icon(
                LucideIcons.chevronRight400,
                size: 18,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
