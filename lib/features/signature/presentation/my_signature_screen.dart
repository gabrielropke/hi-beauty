import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/core/constants/formatters/money.dart';
import 'package:hibeauty/core/services/subscription/data/model.dart';
import 'package:hibeauty/features/signature/bloc/signature_bloc.dart';
import 'package:hibeauty/features/signature/presentation/components/delete_modal.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class MySignatureScreen extends StatelessWidget {
  const MySignatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignatureBloc(context)..add(SignatureLoadRequested()),
      child: const MySignatureView(),
    );
  }
}

class MySignatureView extends StatefulWidget {
  const MySignatureView({super.key});

  @override
  State<MySignatureView> createState() => _MySignatureViewState();
}

class _MySignatureViewState extends State<MySignatureView> {
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
            title: 'Minha assinatura Pro',
            controller: _scrollController,
            backgroundColor: Colors.white,
          ),

          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  if (state.subscription != null) ...[
                    _buildHeaderSection(),
                    _buildStatusCard(state.subscription!),
                    _buildPlanInfo(state.subscription!),
                    _buildCostBreakdown(state.subscription!),
                    _buildLastInvoice(state.subscription!),
                    _buildActions(context, state.subscription!, state),
                  ] else
                    _buildNoSubscriptionMessage(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
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
          'Minha assinatura Pro',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          'Gerenciar sua assinatura',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(MySubscriptionModel subscription) {
    final startDate = subscription.stripe.currentPeriodStart;
    final endDate = subscription.stripe.currentPeriodEndDate;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: subscription.subscription.status == 'ACTIVE'
                      ? Colors.green
                      : Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                subscription.subscription.status == 'ACTIVE'
                    ? 'Assinatura ativa'
                    : 'Inativa',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: subscription.subscription.status == 'ACTIVE'
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Período atual',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatDate(DateTime.parse(startDate))} - ${_formatDate(endDate)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Próxima cobrança',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(endDate),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (subscription.stripe.cancelAtPeriodEnd) ...[
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.02),
                border: Border.all(width: 0.5, color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Icon(
                        LucideIcons.triangleAlert300,
                        size: 18,
                        color: Colors.deepOrange,
                      ),
                      Flexible(
                        child: Text(
                          'Cancelamento agendado para ${_formatDate(subscription.stripe.currentPeriodEndDate)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlanInfo(MySubscriptionModel subscription) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.crown, color: Colors.orange, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plano Pro',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (subscription.pricing.additionalUsers.quantity > 0)
                Text(
                  subscription.pricing.additionalUsers.quantity > 1
                      ? '+ ${subscription.pricing.additionalUsers.quantity} usuários adicionais'
                      : '+ ${subscription.pricing.additionalUsers.quantity} usuário adicional',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            moneyFormatFromCents(subscription.summary.monthlyTotal),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostBreakdown(MySubscriptionModel subscription) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Custos',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildCostItem(
            'Plano básico',
            moneyFormatFromCents(subscription.pricing.basicPlan.totalPrice),
          ),
          if (subscription.pricing.additionalUsers.quantity > 0) ...[
            const SizedBox(height: 8),
            _buildCostItem(
              'Usuário adicional x${subscription.pricing.additionalUsers.quantity}',
              moneyFormatFromCents(
                subscription.pricing.additionalUsers.totalPrice,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                moneyFormatFromCents(subscription.summary.monthlyTotal),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCostItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildLastInvoice(MySubscriptionModel subscription) {
    final invoice = subscription.stripe.latestInvoice;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Última Fatura',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status:',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: invoice.isPaid
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      invoice.isPaid ? 'Pago' : 'Pendente',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: invoice.isPaid ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data:',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(invoice.createdDate),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Valor:',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    moneyFormatFromCents(invoice.total),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: Colors.transparent),
            child: GestureDetector(
              onTap: () {
                launchUrl(
                  Uri.parse(subscription.stripe.latestInvoice.hostedInvoiceUrl),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      LucideIcons.externalLink,
                      size: 16,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ver fatura online',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(color: Colors.transparent),
            child: GestureDetector(
              onTap: () {
                launchUrl(
                  Uri.parse(subscription.stripe.latestInvoice.invoicePdf),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(LucideIcons.download, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Baixar PDF',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    MySubscriptionModel subscription,
    SignatureLoaded state,
  ) {
    final isCanceled = subscription.stripe.cancelAtPeriodEnd;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AppButton(
        borderRadius: 12,
        loading: state.loading,
        label: isCanceled ? 'Reativar assinatura' : 'Cancelar',
        spacing: 8,
        preffixIcon: Icon(
          isCanceled ? LucideIcons.circleCheckBig400 : LucideIcons.circleX400,
          size: 18,
          color: isCanceled ? Colors.white : Colors.black87,
        ),
        fillColor: isCanceled ? Colors.black : Colors.transparent,
        labelColor: isCanceled ? Colors.white : Colors.black,
        borderColor: Colors.black45,
        borderWidth: 0.5,
        labelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: isCanceled ? Colors.white : Colors.black87,
        ),
        function: () {
          if (isCanceled) {
            context.read<SignatureBloc>().add(ReactivateSignature());
          } else {
            showCancelSubscriptionSheet(context: context);
          }
        },
      ),
    );
  }

  Widget _buildNoSubscriptionMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            LucideIcons.alignVerticalDistributeStart,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma assinatura encontrada',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'jan.',
      'fev.',
      'mar.',
      'abr.',
      'mai.',
      'jun.',
      'jul.',
      'ago.',
      'set.',
      'out.',
      'nov.',
      'dez.',
    ];
    return '${date.day} de ${months[date.month]}';
  }
}
