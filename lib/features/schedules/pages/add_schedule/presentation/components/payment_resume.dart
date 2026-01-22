import 'package:flutter/material.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/constants/formatters/money.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/mark_as_paid.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PaymentResume extends StatelessWidget {
  final AddScheduleLoaded state;
  final bool isEditing;
  const PaymentResume({
    super.key,
    required this.state,
    required this.isEditing,
  });

  String _getPaymentStatusText(String? status) {
    if (status == null) return '';

    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pendente';
      case 'COMPLETED':
        return 'Concluído';
      case 'PAID':
        return 'Pago';
      case 'CANCELLED':
        return 'Cancelado';
      case 'OVERDUE':
        return 'Em Atraso';
      case 'REFUNDED':
        return 'Reembolsado';
      default:
        return status;
    }
  }

  String _getPaymentMethodText(String? method) {
    if (method == null) return '';

    switch (method.toUpperCase()) {
      case 'CASH':
        return 'Dinheiro';
      case 'CARD':
        return 'Cartão';
      case 'PIX':
        return 'PIX';
      case 'TRANSFER':
        return 'Transferência';
      case 'OTHER':
        return 'Não informado';
      default:
        return 'Não informado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
            child: Column(
              spacing: 22,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Icon(LucideIcons.dollarSign, size: 20),
                        Text('Pagamento'),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: state.booking?.payment.isPaid == true
                                  ? Color(0xFF00A73D)
                                  : Color(0xFF6465F0),
                              width: 0.6,
                            ),
                            color: state.booking?.payment.isPaid == true
                                ? Color(0xFF00A73D).withValues(alpha: 0.1)
                                : Color(0xFF6465F0).withValues(alpha: 0.1),
                          ),
                          child: Row(
                            spacing: 8,
                            children: [
                              if (state.booking?.payment.isPaid == true)
                                Icon(
                                  LucideIcons.circleCheck,
                                  size: 16,
                                  color: Color(0xFF00A73D),
                                ),
                              Text(
                                state.booking?.payment.isPaid == false
                                    ? 'Pendente'
                                    : _getPaymentStatusText(
                                        state.booking?.payment.status,
                                      ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: state.booking?.payment.isPaid == true
                                      ? Color(0xFF00A73D)
                                      : Color(0xFF6465F0),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Método', style: TextStyle(color: Colors.black87)),
                    Text(
                     state.booking!.payment.isPaid == true
                          ? _getPaymentMethodText(
                              state.booking?.payment.paymentMethod,
                            )
                          : '—',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: TextStyle(color: Colors.black87)),
                    Text(
                      moneyFormat(context, '${state.booking?.payment.amount}'),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Desconto', style: TextStyle(color: Colors.black87)),
                    Text(
                      moneyFormat(context, '0'),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      moneyFormat(
                        context,
                        state.booking?.payment.amount != null
                            ? '${state.booking!.payment.amount}'
                            : '0',
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (state.booking!.payment.isPaid != true)
          AppButton(
            mainAxisSize: MainAxisSize.max,
            borderRadius: 10,
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 20),
            preffixIcon: Icon(
              LucideIcons.circleCheck,
              color: Colors.white,
              size: 15,
            ),
            loading: state.loading,
            label: 'Marcar como pago',
            fillColor: Color(0xFF12B981),
            borderColor: Color(0xFF00A73D),
            borderWidth: 1,
            labelStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            spacing: 8,
            function: () => showMarkasPaidMemberSheet(context: context, state: state),
          ),
      ],
    );
  }
}
