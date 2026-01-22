import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_popup.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/core/constants/formatters/date.dart';
import 'package:hibeauty/features/onboarding/data/business/model.dart';
import 'package:hibeauty/features/schedules/data/model.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/add_schedule_screen.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_item.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_schedule_utils.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/date_picker.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/payment_resume.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/time_resume.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddScheduleBookingScreen extends StatelessWidget {
  final DateTime? initialDate;
  final AddScheduleArgs? args;

  const AddScheduleBookingScreen({super.key, this.initialDate, this.args});

  @override
  Widget build(BuildContext context) {
    final effectiveDate = args?.initialDate ?? initialDate;

    return BlocProvider(
      create: (_) => AddScheduleBloc(context)
        ..add(
          AddScheduleLoadRequested(effectiveDate, bookingId: args?.bookingId),
        ),
      child: AddScheduleBookingView(args: args),
    );
  }
}

class AddScheduleBookingView extends StatefulWidget {
  final AddScheduleArgs? args;

  const AddScheduleBookingView({super.key, this.args});

  @override
  State<AddScheduleBookingView> createState() => _AddScheduleBookingViewState();
}

class _AddScheduleBookingViewState extends State<AddScheduleBookingView> {
  final ScrollController _scrollController = ScrollController();
  bool editOn = false;

  bool get isEditing => widget.args?.bookingId != null;

  @override
  void initState() {
    super.initState();
    // Se estamos criando um novo agendamento, sempre inicia em modo de edição
    if (!isEditing) {
      editOn = true;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      builder: (blocContext, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: switch (state) {
            AddScheduleLoading _ => const AppLoader(),
            AddScheduleLoaded s => _loaded(s, context, l10n),
            AddScheduleState() => const AppLoader(),
          },
        );
      },
    );
  }

  Widget _loaded(
    AddScheduleLoaded state,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          CustomAppBar(
            title: isEditing
                ? DateFormatters.weekdayDayMonthShort(state.date, context)
                : DateFormatters.weekdayDayMonthShort(state.date, context),
            controller: _scrollController,
            backgroundColor: Colors.white,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 32,
                children: [
                  if (state.currentStep == 1) ..._buildStep1(context, state),
                  if (state.currentStep == 2) ..._buildStep2(context, state),
                  if (state.currentStep == 3) ..._buildStep3(context, state),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
          if (state.booking?.status != 'COMPLETED') ...[
            Container(height: 1, color: Colors.grey.withAlpha(100)),
            SizedBox(
              width: double.infinity,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 12,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: TextStyle(fontSize: 16)),
                          Text(
                            _calculateTotal(state),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      // Botões baseados no estado de edição
                      if (editOn)
                        _buildEditButtons(context, state)
                      else
                        _buildViewButtons(context, state),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildViewButtons(BuildContext context, AddScheduleLoaded state) {
    return Visibility(
      visible: !editOn,
      child: Row(
        spacing: 12,
        children: [
          if (widget.args?.bookingId != null)
            Expanded(
              child: AppButton(
                preffixIcon: Icon(LucideIcons.circleX, size: 15),
                spacing: 8,
                label: 'Desmarcar',
                labelStyle: TextStyle(),
                fillColor: Colors.transparent,
                borderColor: Colors.black12,
                labelColor: Colors.black87,
                borderRadius: 12,
                function: () {
                  if (!state.loading) {
                    AppPopup.show(
                      context: context,
                      type: AppPopupType.delete,
                      title: 'Desmarcar agendamento?',
                      actionLabel: 'Desmarcar',
                      description:
                          'Tem certeza que deseja desmarcar este agendamento? Esta ação é permanente.',
                      onConfirm: () {
                        Navigator.of(context).pop();
                        context.read<AddScheduleBloc>().add(
                          DeleteBooking(widget.args!.bookingId!),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          Expanded(
            child: AppButton(
              borderRadius: 12,
              preffixIcon: Icon(
                LucideIcons.pencil,
                color: Colors.white,
                size: 15,
              ),
              loading: state.loading,
              label: 'Editar',
              labelStyle: TextStyle(color: Colors.white),
              spacing: 8,
              function: () {
                setState(() {
                  editOn = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButtons(BuildContext context, AddScheduleLoaded state) {
    return Visibility(
      visible: editOn,
      child: Row(
        spacing: 12,
        children: [
          if ((state.currentStep != 1))
            Expanded(
              child: AppButton(
                label: 'Voltar',
                labelStyle: TextStyle(),
                fillColor: Colors.transparent,
                borderColor: Colors.black12,
                labelColor: Colors.black87,
                borderRadius: 12,
                function: () =>
                    context.read<AddScheduleBloc>().add(PreviousStep()),
              ),
            ),
          Expanded(
            flex: 2,
            child: AppButton(
              borderRadius: 12,
              spacing: 8,
              labelStyle: TextStyle(color: Colors.white),
              preffixIcon: isEditing && state.currentStep == 3
                  ? Icon(LucideIcons.save, color: Colors.white, size: 15)
                  : null,
              loading: state.loading,
              label: _getButtonLabel(state.currentStep),
              enabled: _isContinueButtonEnabled(state),
              function: _isContinueButtonEnabled(state)
                  ? () => _handleButtonPress(context, state)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateTotal(AddScheduleLoaded state) {
    double total = 0.0;

    // Soma dos serviços selecionados
    for (final service in state.selectedServices) {
      total += service.price;
    }

    // Soma dos produtos selecionados
    for (final product in state.selectedProducts) {
      total += product.price;
    }

    // Soma dos combos selecionados
    for (final combo in state.selectedCombos) {
      total += combo.price;
    }

    return 'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  bool _isContinueButtonEnabled(AddScheduleLoaded state) {
    switch (state.currentStep) {
      case 1:
        // Step 1: Precisa de pelo menos um serviço
        return state.selectedServices.isNotEmpty &&
            state.memberSelected != null;
      case 2:
        // Step 2: Precisa ter selecionado um horário válido (múltiplo de 15 min)
        return state.date.hour != 0 && state.date.minute % 15 == 0;
      case 3:
        // Step 3: Precisa ter data/hora, serviços, membro da equipe e cliente
        return state.selectedServices.isNotEmpty &&
            state.memberSelected != null &&
            state.customerSelected != null;
      default:
        return false;
    }
  }

  List<Widget> _buildStep1(BuildContext context, AddScheduleLoaded state) {
    return [
      _openDates(context, state),
      AddScheduleItem(type: AddScheduleTypeItem.member, state: state),
      AddScheduleItem(type: AddScheduleTypeItem.services, state: state),
    ];
  }

  List<Widget> _buildStep2(BuildContext context, AddScheduleLoaded state) {
    return [
      _openDates(context, state),
      _buildRecurrenceSelection(context, state),
      _buildTimeSelection(context, state),
    ];
  }

  List<Widget> _buildStep3(BuildContext context, AddScheduleLoaded state) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 32,
        children: [
          IgnorePointer(
            ignoring: state.booking?.status == 'COMPLETED',
            child: _openDates(context, state)),
          if (isEditing) PaymentResume(state: state, isEditing: isEditing),
          TimeResume(state: state, isEditing: isEditing),
          IgnorePointer(
            ignoring: state.booking?.status == 'COMPLETED',
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.memberSelected == null)
                  Row(
                    spacing: 8,
                    children: [
                      Icon(LucideIcons.badgeInfo, color: Colors.red, size: 18),
                      Text(
                        'Selecione um membro da equipe',
                        style: TextStyle(fontSize: 13, color: Colors.red),
                      ),
                    ],
                  ),
                AddScheduleItem(type: AddScheduleTypeItem.member, state: state),
              ],
            ),
          ),
          IgnorePointer(
            ignoring: state.booking?.status == 'COMPLETED',
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.customerSelected == null)
                  Row(
                    spacing: 8,
                    children: [
                      Icon(LucideIcons.badgeInfo, color: Colors.red, size: 18),
                      Text(
                        'Selecione um cliente',
                        style: TextStyle(fontSize: 13, color: Colors.red),
                      ),
                    ],
                  ),
                AddScheduleItem(type: AddScheduleTypeItem.customer, state: state),
              ],
            ),
          ),
          AddScheduleItem(type: AddScheduleTypeItem.services, state: state),
        ],
      ),
    ];
  }

  Widget _buildRecurrenceSelection(
    BuildContext context,
    AddScheduleLoaded state,
  ) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repetir agendamento',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: Recurrencetypes.values.length,
          itemBuilder: (context, index) {
            final type = Recurrencetypes.values[index];
            final isSelected = state.recurrenceType == type;
            return GestureDetector(
              onTap: () {
                context.read<AddScheduleBloc>().add(
                  RecurrenceTypeSelected(type: type),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.black12,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          recurrenceTypesToString(type),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.blue : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isSelected) ...[
                        SizedBox(width: 8),
                        Icon(
                          LucideIcons.check,
                          color: isSelected ? Colors.blue : Colors.white,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimeSelection(BuildContext context, AddScheduleLoaded state) {
    final now = DateTime.now();
    final selectedDate = DateTime(
      state.date.year,
      state.date.month,
      state.date.day,
    );
    final isToday =
        selectedDate.day == now.day &&
        selectedDate.month == now.month &&
        selectedDate.year == now.year;

    // Buscar horários de funcionamento para o dia selecionado
    final dayNames = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];
    final selectedDayName = dayNames[selectedDate.weekday - 1];

    // Considera as 24 horas do dia
    final openingHour = OpeningHour(
      day: selectedDayName,
      startAt: '00:00',
      endAt: '23:59',
      open: true,
    );

    // Se o dia não está aberto para funcionamento
    if (!openingHour.open) {
      return Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Escolha o horário',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Estabelecimento fechado neste dia',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ),
        ],
      );
    }

    // Parsear horários de abertura e fechamento
    final startTimeParts = openingHour.startAt.split(':');
    final endTimeParts = openingHour.endAt.split(':');

    final businessStartHour = int.parse(startTimeParts[0]);
    final businessStartMinute = int.parse(startTimeParts[1]);
    final businessEndHour = int.parse(endTimeParts[0]);
    final businessEndMinute = int.parse(endTimeParts[1]);

    // Determinar hora inicial - se for hoje e já passou do horário de abertura,
    // começar da próxima hora cheia. Senão, começar do horário de abertura.
    int startHour = businessStartHour;
    int startMinute = businessStartMinute;

    if (isToday) {
      final currentTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      );
      final businessStart = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        businessStartHour,
        businessStartMinute,
      );

      if (currentTime.isAfter(businessStart)) {
        startHour = now.hour + 1;
        startMinute = 0;

        // Se passou do horário de funcionamento
        if (startHour > businessEndHour ||
            (startHour == businessEndHour && startMinute > businessEndMinute)) {
          return Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Escolha o horário',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Horário de funcionamento encerrado para hoje',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
              ),
            ],
          );
        }
      }
    }

    List<DateTime> timeSlots = [];

    // Gerar slots de 15 em 15 minutos dentro do horário de funcionamento
    DateTime currentSlot = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startHour,
      startMinute,
    );

    // Arredondar para próximo múltiplo de 15 minutos
    int remainder = currentSlot.minute % 15;
    if (remainder != 0) {
      currentSlot = currentSlot.add(Duration(minutes: 15 - remainder));
    }

    final businessEnd = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      businessEndHour,
      businessEndMinute,
    );

    while (currentSlot.isBefore(businessEnd)) {
      timeSlots.add(currentSlot);
      currentSlot = currentSlot.add(Duration(minutes: 15));
    }

    if (timeSlots.isEmpty) {
      return Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Escolha o horário',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Nenhum horário disponível',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escolha o horário',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            final timeSlot = timeSlots[index];
            final timeString =
                '${timeSlot.hour.toString().padLeft(2, '0')}:${timeSlot.minute.toString().padLeft(2, '0')}';
            final stateDateTimeString =
                '${state.date.hour.toString().padLeft(2, '0')}:${state.date.minute.toString().padLeft(2, '0')}';
            final isSelected = timeString == stateDateTimeString;

            return GestureDetector(
              onTap: () {
                context.read<AddScheduleBloc>().add(
                  SelectTime(dateTime: timeSlot),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.black12,
                  ),
                ),
                child: Center(
                  child: Text(
                    timeString,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getButtonLabel(int currentStep) {
    if (isEditing && currentStep == 3) {
      return 'Salvar';
    }

    switch (currentStep) {
      case 1:
        return 'Próximo';
      case 2:
        return 'Próximo';
      case 3:
        return 'Finalizar';
      default:
        return 'Próximo';
    }
  }

  void _handleButtonPress(BuildContext context, AddScheduleLoaded state) {
    switch (state.currentStep) {
      case 1:
        context.read<AddScheduleBloc>().add(NextStep());
        break;
      case 2:
        context.read<AddScheduleBloc>().add(NextStep());
        break;
      case 3:
        // Gerar nome baseado nos serviços selecionados
        final name = state.selectedServices
            .map((service) => service.name)
            .join(' + ');

        // Converter recurrenceType para string
        final recurrenceTypeString = state.recurrenceType.name.toUpperCase();

        // Mapear serviços para ServiceItem
        final services = state.selectedServices
            .map((service) => ServiceItem(serviceId: service.id, quantity: 1))
            .toList();

        // Mapear combos para ComboItem
        final combos = state.selectedCombos
            .map((combo) => ComboItem(comboId: combo.id, quantity: 1))
            .toList();

        // Mapear produtos para ProductItem
        final products = state.selectedProducts
            .map((product) => ProductItem(productId: product.id, quantity: 1))
            .toList();

        if (isEditing) {
          context.read<AddScheduleBloc>().add(
            UpdateBooking(
              CreateBookingResponse(
                name: name,
                scheduledFor: state.date
                    .subtract(Duration(hours: 3))
                    .toUtc()
                    .toIso8601String(),
                customerId: state.customerSelected?.id ?? '',
                teamMemberId: state.memberSelected?.id ?? '',
                services: services,
                combos: combos,
                products: products,
                recurrenceType: recurrenceTypeString.toUpperCase(),
                discount: DiscountModel(type: 'PERCENTAGE', value: 0),
                recurrenceEndDate: state.date
                    .add(Duration(days: 180))
                    .toUtc()
                    .toIso8601String(),
              ),
              widget.args!.bookingId!,
            ),
          );
        } else {
          context.read<AddScheduleBloc>().add(
            SubmitSchedule(
              CreateBookingResponse(
                name: name,
                scheduledFor: state.date
                    .subtract(Duration(hours: 3))
                    .toUtc()
                    .toIso8601String(),
                customerId: state.customerSelected?.id ?? '',
                teamMemberId: state.memberSelected?.id ?? '',
                services: services,
                combos: combos,
                products: products,
                recurrenceType: recurrenceTypeString.toUpperCase(),
                discount: DiscountModel(type: 'PERCENTAGE', value: 0),
                recurrenceEndDate: state.date
                    .add(Duration(days: 180))
                    .toUtc()
                    .toIso8601String(),
              ),
            ),
          );
        }

        break;
    }
  }

  Widget _openDates(BuildContext context, AddScheduleLoaded state) {
    return GestureDetector(
      onTap: () => showAddScheduleTimeSheet(bcontext: context, state: state),
      child: Container(
        color: Colors.transparent,
        child: Row(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormatters.weekdayDayMonthShort(state.date, context),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Icon(LucideIcons.chevronDown, size: 20),
          ],
        ),
      ),
    );
  }
}
