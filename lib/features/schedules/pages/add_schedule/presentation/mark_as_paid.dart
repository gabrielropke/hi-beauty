import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Future<void> showMarkasPaidMemberSheet({
  required BuildContext context,
  required AddScheduleLoaded state,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    useSafeArea: true,
    barrierColor: Colors.transparent,
    clipBehavior: Clip.hardEdge,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
    ),
    builder: (ctx) {
      return BlocProvider.value(
        value: context.read<AddScheduleBloc>(),
        child: Container(
          color: Colors.white,
          child: _MarkasPaidModal(state: state),
        ),
      );
    },
  );
}

class _MarkasPaidModal extends StatefulWidget {
  const _MarkasPaidModal({required this.state});

  final AddScheduleLoaded state;

  @override
  State<_MarkasPaidModal> createState() => _MarkasPaidModalState();
}

class _MarkasPaidModalState extends State<_MarkasPaidModal> {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;
  late final TextEditingController _descriptionCtrl;

  @override
  void initState() {
    super.initState();
    _descriptionCtrl = TextEditingController(text: '');

    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        opacity: _showHeaderTitle ? 1 : 0,
                        child: IgnorePointer(
                          ignoring: !_showHeaderTitle,
                          child: Text(
                            'Marcar como pago',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                opacity: _showHeaderTitle ? 1 : 0,
                child: Divider(
                  thickness: 1,
                  color: Colors.grey[300],
                  height: 5,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _controller,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Marcar como pago',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Registre o pagamento deste agendamento.',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Data/Hora do Pagamento
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Data/Hora do Pagamento'),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => context.read<AddScheduleBloc>().add(
                              SelectPaymentDateTime(),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.calendar,
                                    size: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                  SizedBox(width: 12),
                                  BlocBuilder<
                                    AddScheduleBloc,
                                    AddScheduleState
                                  >(
                                    builder: (context, state) {
                                      final paymentDateTime =
                                          state is AddScheduleLoaded
                                          ? state.paymentDateTime
                                          : null;
                                      return Text(
                                        paymentDateTime != null
                                            ? DateFormat(
                                                'dd/MM/yyyy, HH:mm',
                                              ).format(paymentDateTime)
                                            : 'Selecione a data e hora',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: paymentDateTime != null 
                                            ? Colors.black87
                                            : Colors.grey.shade600,
                                        ),
                                      );
                                    },
                                  ),
                                  Spacer(),
                                  Icon(
                                    LucideIcons.chevronDown,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Informe quando o pagamento foi efetuado.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Método de Pagamento
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Método'),
                          SizedBox(height: 8),
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: PaymentMethods.values.length,
                            itemBuilder: (context, index) {
                              final method = PaymentMethods.values[index];
                              return BlocBuilder<
                                AddScheduleBloc,
                                AddScheduleState
                              >(
                                builder: (context, state) {
                                  final selectedMethod =
                                      state is AddScheduleLoaded
                                      ? state.selectedPaymentMethod
                                      : null;
                                  final isSelected = selectedMethod != null && selectedMethod == method;
                                  return GestureDetector(
                                    onTap: () {
                                      context.read<AddScheduleBloc>().add(
                                        SelectPaymentMethod(method: method),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(32),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.blue
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            context
                                                .read<AddScheduleBloc>()
                                                .getPaymentMethodIcon(method),
                                            size: 16,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              context
                                                  .read<AddScheduleBloc>()
                                                  .getPaymentMethodName(method),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Escolha o método utilizado no pagamento.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 42),

                      // Observações
                      AppTextformfield(
                        title: 'Observações (opcional)',
                        hintText: 'Ex.: Pago via PIX às 14:30',
                        controller: _descriptionCtrl,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        isMultiline: true,
                        multilineInitialLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BlocBuilder<AddScheduleBloc, AddScheduleState>(
          builder: (context, state) {
            final loading = state is AddScheduleLoaded ? state.loading : false;
            final paymentDateTime = state is AddScheduleLoaded
                ? state.paymentDateTime
                : null;
            final selectedPaymentMethod = state is AddScheduleLoaded
                ? state.selectedPaymentMethod
                : null;
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: AppButton(
                label: 'Confirmar pagamento',
                loading: loading,
                enabled:
                    paymentDateTime != null &&
                    selectedPaymentMethod != null &&
                    !loading,
                function: paymentDateTime != null && selectedPaymentMethod != null
                  ? () {
                      final currentState = context.read<AddScheduleBloc>().state;
                      if (currentState is AddScheduleLoaded) {
                        context.read<AddScheduleBloc>().add(
                          MarkAsPaid(
                            bookingId: widget.state.booking?.id ?? '',
                            paymentDateTime: currentState.paymentDateTime!
                                .toUtc()
                                .toIso8601String(),
                            paymentMethod: getPaymentMethodLabelSupaBase(
                              currentState.selectedPaymentMethod!,
                            ),
                            notes: _descriptionCtrl.text,
                          ),
                        );
                      }
                    }
                  : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

String getPaymentMethodLabelSupaBase(PaymentMethods method) {
  switch (method) {
    case PaymentMethods.PIX:
      return 'PIX';
    case PaymentMethods.CARD:
      return 'CARD';
    case PaymentMethods.CASH:
      return 'CASH';
    case PaymentMethods.OTHER:
      return 'OTHER';
  }
}
