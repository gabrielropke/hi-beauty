import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_popup.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/core/constants/formatters/date.dart';
import 'package:hibeauty/features/schedules/data/model.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_item.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_schedule_utils.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/date_picker.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddScheduleBlockArgs {
  final DateTime? initialDate;
  final String? blockId; // ID do bloqueio para edição
  final String? blockName;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? selectedTeamMemberId;
  final Recurrencetypes? recurrenceType;
  final String? notes;
  final bool isEditing;

  AddScheduleBlockArgs({
    this.initialDate,
    this.blockId,
    this.blockName,
    this.startTime,
    this.endTime,
    this.selectedTeamMemberId,
    this.recurrenceType,
    this.notes,
    this.isEditing = false,
  });
}

class AddScheduleBlockScreen extends StatelessWidget {
  final DateTime? initialDate;
  final AddScheduleBlockArgs? args;

  const AddScheduleBlockScreen({super.key, this.initialDate, this.args});

  @override
  Widget build(BuildContext context) {
    final effectiveDate = args?.initialDate ?? initialDate;

    return BlocProvider(
      create: (_) => AddScheduleBloc(context)
        ..add(AddScheduleLoadRequested(effectiveDate, blockId: args?.blockId)),
      child: AddScheduleBlockView(args: args),
    );
  }
}

class AddScheduleBlockView extends StatefulWidget {
  final AddScheduleBlockArgs? args;

  const AddScheduleBlockView({super.key, this.args});

  @override
  State<AddScheduleBlockView> createState() => _AddScheduleBlockViewState();
}

class _AddScheduleBlockViewState extends State<AddScheduleBlockView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;

  bool get isEditing => widget.args?.blockId != null;

  @override
  void initState() {
    super.initState();
    // Inicializar horários se initialDate foi passado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTimesFromWidget();
    });
  }

  void _populateFieldsFromState(AddScheduleLoaded state) {
    if (isEditing && state.blockName != null && _titleController.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleController.text = state.blockName!;
      });
    }

    if (isEditing &&
        state.blockNotes != null &&
        _descriptionController.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _descriptionController.text = state.blockNotes!;
      });
    }

    if (isEditing && state.blockDuration != null && _startTime == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          // Criar DateTime com a data do state.date mas preservando hora/minuto do scheduledFor original
          // O state.date já contém o scheduledFor convertido, então usar diretamente
          final scheduledFor = state.date; // Ajustar para UTC correto

          // Criar horário de início alinhado aos slots de 5 minutos
          final startHour = scheduledFor.hour;
          final startMinute = (scheduledFor.minute / 5).round() * 5;

          _startTime = DateTime(
            state.date.year,
            state.date.month,
            state.date.day,
            startHour,
            startMinute,
          );

          // Calcular término: início + duration
          _endTime = _startTime!.add(Duration(minutes: state.blockDuration!));
        });
      });
    }
  }

  void _initializeTimesFromWidget() {
    // Verificar se temos initialDate através do widget pai
    final parentWidget = context
        .findAncestorWidgetOfExactType<AddScheduleBlockScreen>();
    if (parentWidget?.initialDate != null && _startTime == null) {
      final initialDate = parentWidget!.initialDate!;

      setState(() {
        _startTime = DateTime(
          initialDate.year,
          initialDate.month,
          initialDate.day,
          initialDate.hour,
          initialDate.minute,
        );

        // Definir endTime como startTime + 15 minutos
        _endTime = _startTime!.add(Duration(minutes: 15));
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _calculateDuration() {
    if (_startTime == null || _endTime == null) {
      return 'Selecione os horários';
    }

    final duration = _endTime!.difference(_startTime!);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours == 0) {
      return '${minutes}min de duração';
    } else if (minutes == 0) {
      return '${hours}h de duração';
    } else {
      return '${hours}h ${minutes}min de duração';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<AddScheduleBloc, AddScheduleState>(
      listener: (context, state) {
        // Pré-preencher campos quando estado carregado
        if (state is AddScheduleLoaded) {
          _populateFieldsFromState(state);
        }
      },
      child: BlocBuilder<AddScheduleBloc, AddScheduleState>(
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
      ),
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
                  ..._buildBlockForm(context, state),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Container(height: 1, color: Colors.grey.withAlpha(100)),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        loading: state.loading,
                        label: isEditing ? 'Salvar alterações' : 'Salvar',
                        enabled: _isContinueButtonEnabled(state),
                        function: _isContinueButtonEnabled(state)
                            ? () => _handleButtonPress(context, state)
                            : null,
                      ),
                    ),
                  ),
                  if (widget.args?.blockId != null)
                    Opacity(
                      opacity: state.loading ? 0.5 : 1.0,
                      child: IconButton(
                        onPressed: () {
                          if (!state.loading) {
                            AppPopup.show(
                              context: context,
                              type: AppPopupType.delete,
                              title: 'Excluir bloqueio',
                              description:
                                  'Tem certeza que deseja excluir este bloqueio? Esta ação não pode ser desfeita.',
                              onConfirm: () {
                                Navigator.of(context).pop();
                                context.read<AddScheduleBloc>().add(
                                  DeleteBlock(widget.args!.blockId!),
                                );
                              },
                            );
                          }
                        },
                        icon: Icon(LucideIcons.trash2, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red,
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
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

  Widget _buildTimeDropdowns(AddScheduleLoaded state) {
    // Gerar horários de 5 em 5 minutos das 6h às 23h
    List<Map<String, Object?>> timeSlots = [];
    for (int hour = 6; hour <= 23; hour++) {
      for (int minute = 0; minute < 60; minute += 5) {
        final time = DateTime(
          state.date.year,
          state.date.month,
          state.date.day,
          hour,
          minute,
        );
        final timeString =
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        timeSlots.add({'label': timeString, 'value': time});
      }
    }

    // Filtrar horários de fim baseado no horário de início
    List<Map<String, Object?>> endTimeSlots = [];
    if (_startTime != null) {
      endTimeSlots = timeSlots.where((slot) {
        final time = slot['value'] as DateTime;
        return time.isAfter(_startTime!);
      }).toList();
    }

    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          spacing: 12,
          children: [
            // Dropdown de início
            Expanded(
              child: AppDropdown(
                isrequired: true,
                title: 'Horário de início',
                items: timeSlots,
                labelKey: 'label',
                valueKey: 'value',
                selectedValue: _startTime,
                placeholder: Text(
                  'Início',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                onChanged: (value) {
                  setState(() {
                    _startTime = value as DateTime?;
                    // Automaticamente definir endTime como startTime + 15 minutos
                    if (_startTime != null) {
                      _endTime = _startTime!.add(Duration(minutes: 15));
                    } else {
                      _endTime = null;
                    }
                  });
                },
              ),
            ),
            // Dropdown de fim
            Expanded(
              child: AppDropdown(
                isrequired: true,
                title: 'Horário de término',
                items: endTimeSlots,
                labelKey: 'label',
                valueKey: 'value',
                selectedValue: _endTime,
                enabled: _startTime != null,
                placeholder: Text(
                  _startTime != null ? 'Fim' : 'Fim',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                onChanged: (value) {
                  setState(() {
                    _endTime = value as DateTime?;
                  });
                },
              ),
            ),
          ],
        ),
        Text(
          _calculateDuration(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildRecurrenceSelectionForBlock(
    BuildContext context,
    AddScheduleLoaded state,
  ) {
    // Criar lista de itens para o dropdown
    final List<Map<String, Object?>> recurrenceItems = Recurrencetypes.values
        .map((type) => {'label': recurrenceTypesToString(type), 'value': type})
        .toList();

    return AppDropdown(
      isrequired: true,
      title: 'Frequência',
      items: recurrenceItems,
      labelKey: 'label',
      valueKey: 'value',
      selectedValue: state.recurrenceType,
      placeholder: Text(
        'Selecione a frequência',
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
      onChanged: (value) {
        context.read<AddScheduleBloc>().add(
          RecurrenceTypeSelected(type: value as Recurrencetypes),
        );
      },
    );
  }

  Widget _buildDescriptionField() {
    return AppTextformfield(
      title: 'Descrição',
      controller: _descriptionController,
      multilineInitialLines: 3,
      isMultiline: true,
      maxLength: 200,
    );
  }

  bool _isContinueButtonEnabled(AddScheduleLoaded state) {
    // Para bloqueio, tudo em um step - precisa de horários e membro
    return _startTime != null &&
        _endTime != null &&
        state.memberSelected != null &&
        _titleController.text.trim().isNotEmpty;
  }

  List<Widget> _buildBlockForm(BuildContext context, AddScheduleLoaded state) {
    return [
      _openDates(context, state),
      AppTextformfield(
        isrequired: true,
        title: 'Título',
        controller: _titleController,
        hintText: 'Ex: Reunião interna, Almoço, etc.',
        onChanged: (value) {
          setState(() {});
        },
      ),
      _buildTimeDropdowns(state),
      Column(
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
      _buildRecurrenceSelectionForBlock(context, state),
      _buildDescriptionField(),
    ];
  }

  void _handleButtonPress(BuildContext context, AddScheduleLoaded state) {
    // Para bloqueio, finalizar direto
    final title = _titleController.text.trim();
    final blockName = title.isNotEmpty ? title : 'Bloqueio';
    final recurrenceTypeString = state.recurrenceType.name.toUpperCase();

    if (isEditing) {
      context.read<AddScheduleBloc>().add(
        UpdateBlock(
          CreateBlockResponse(
            name: blockName,
            teamMemberId: state.memberSelected?.id ?? '',
            scheduledFor: (_startTime ?? state.date).toUtc().toIso8601String(),
            duration: int.parse(
              _endTime!
                  .difference(_startTime ?? state.date)
                  .inMinutes
                  .toString(),
            ),
            recurrenceType: recurrenceTypeString,
            recurrenceEndDate: (_startTime ?? state.date)
                .add(Duration(days: 180))
                .toUtc()
                .toIso8601String(),
          ),
          widget.args!.blockId!,
        ),
      );
    } else {
      context.read<AddScheduleBloc>().add(
        SubmitBlock(
          CreateBlockResponse(
            name: blockName,
            teamMemberId: state.memberSelected?.id ?? '',
            scheduledFor: (_startTime ?? state.date).toUtc().toIso8601String(),
            duration: int.parse(
              _endTime!
                  .difference(_startTime ?? state.date)
                  .inMinutes
                  .toString(),
            ),
            recurrenceType: recurrenceTypeString,
            recurrenceEndDate: (_startTime ?? state.date)
                .add(Duration(days: 180))
                .toUtc()
                .toIso8601String(),
          ),
        ),
      );
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
