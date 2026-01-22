import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/core/components/app_toggle_switch.dart';
import 'package:hibeauty/features/business/views/business_hours/presentation/bloc/business_hours_bloc.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class WeeklyScheduleList extends StatefulWidget {
  final List<TeamMemberModel> teamMembers;
  const WeeklyScheduleList({super.key, required this.teamMembers});

  @override
  State<WeeklyScheduleList> createState() => _WeeklyScheduleListState();
}

class _WeeklyScheduleListState extends State<WeeklyScheduleList> {
  static const List<String> _weekDays = [
    'Domingo',
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
  ];

  String? _expandedDay; // dia atualmente expandido
  late List<TeamMemberModel> _members; // lista mutável local

  @override
  void initState() {
    super.initState();
    _members = List<TeamMemberModel>.from(widget.teamMembers);
  }

  @override
  void didUpdateWidget(covariant WeeklyScheduleList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.teamMembers != widget.teamMembers) {
      setState(() {
        _members = List<TeamMemberModel>.from(widget.teamMembers);
      });
    }
  }

  List<TeamMemberModel> _getMembersWorkingOnDay(String day) {
    return _members.where((member) {
      return member.workingHours.any(
        (wh) => wh.day == day && wh.isWorking == true,
      );
    }).toList();
  }

  WorkingHourModel? _getHourForDay(TeamMemberModel m, String day) {
    try {
      return m.workingHours.firstWhere((wh) => wh.day == day && wh.isWorking);
    } catch (_) {
      return null;
    }
  }

  void _toggleDay(String day) {
    setState(() {
      _expandedDay = _expandedDay == day ? null : day;
    });
  }

  // Substituir stub apagado por implementação real
  Future<List<WorkingHourModel>?> showMemberHoursEditor({
    required BuildContext context,
    required TeamMemberModel member,
  }) async {
    final bloc = context.read<BusinessHoursBloc>(); // captura instancia existente
    return showModalBottomSheet<List<WorkingHourModel>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => BlocProvider.value(
        value: bloc,
        child: _MemberHoursEditor(member: member),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Visualize e configure os horários individuais de cada colaborador',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          spacing: 32,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _weekDays.map((day) {
            final workingMembers = _getMembersWorkingOnDay(day);
            final expanded = _expandedDay == day;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _toggleDay(day),
              child: Container(
                width: double.infinity,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: expanded ? Colors.black : Colors.black87,
                      ),
                    ),
                    workingMembers.isEmpty
                        ? const Text(
                            'Não há colaboradores disponíveis',
                            key: ValueKey('empty'),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        : expanded
                        ? Column(
                            key: ValueKey('expanded_$day'),
                            spacing: 12,
                            children: workingMembers.map((m) {
                              final hour = _getHourForDay(m, day);
                              final schedule = hour != null
                                  ? '${hour.startAt} - ${hour.endAt}'
                                  : '—';
                              return _ExpandedMemberRow(
                                member: m,
                                schedule: schedule,
                                onEdit: () async {
                                  final updated = await showMemberHoursEditor(
                                    context: context,
                                    member: m,
                                  );
                                  if (updated != null) {
                                    setState(() {
                                      final idx = _members.indexWhere(
                                        (tm) => tm.id == m.id,
                                      );
                                      if (idx != -1) {
                                        _members[idx] = TeamMemberModel(
                                          id: m.id,
                                          userId: m.userId,
                                          name: m.name,
                                          email: m.email,
                                          phone: m.phone,
                                          profileImageUrl: m.profileImageUrl,
                                          role: m.role,
                                          status: m.status,
                                          themeColor: m.themeColor,
                                          workingHours: updated,
                                          businessId: m.businessId,
                                          isActive: m.isActive,
                                          createdAt: m.createdAt,
                                          updatedAt: DateTime.now(),
                                        );
                                      }
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          )
                        : Wrap(
                            key: ValueKey('compact_$day'),
                            spacing: 12,
                            runSpacing: 8,
                            children: workingMembers
                                .map((m) => _MemberAvatar(member: m))
                                .toList(),
                          ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 30),
        Text(
          'Não consegue encontrar alguém?',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        AppButton(
          label: 'Gerenciar colaboradores',
          spacing: 0,
          height: 30,
          mainAxisAlignment: MainAxisAlignment.start,
          fillColor: Colors.transparent,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
          function: () => context.push(AppRoutes.team),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}

class _MemberHoursEditor extends StatefulWidget {
  final TeamMemberModel member;
  const _MemberHoursEditor({required this.member});

  @override
  State<_MemberHoursEditor> createState() => _MemberHoursEditorState();
}

class _MemberHoursEditorState extends State<_MemberHoursEditor> {
  late List<WorkingHourModel> _hours;

  static final List<Map<String, Object?>> _hourOptions = [
    for (int i = 0; i < 24; i++)
      {
        'label': '${i.toString().padLeft(2, '0')}:00',
        'value': '${i.toString().padLeft(2, '0')}:00',
      },
  ];

  @override
  void initState() {
    super.initState();
    _hours = widget.member.workingHours
        .map(
          (e) => WorkingHourModel(
            day: e.day,
            startAt: e.startAt,
            endAt: e.endAt,
            isWorking: e.isWorking,
          ),
        )
        .toList();
  }

  void _update(int index, {String? start, String? end, bool? working}) {
    final current = _hours[index];
    _hours[index] = WorkingHourModel(
      day: current.day,
      startAt: start ?? current.startAt,
      endAt: end ?? current.endAt,
      isWorking: working ?? current.isWorking,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Horários de ${widget.member.name}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(LucideIcons.x300),
                  splashRadius: 24,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < _hours.length; i++)
                      _DayEditorRow(
                        model: _hours[i],
                        hourOptions: _hourOptions,
                        onWorkingChanged: (v) => _update(i, working: v),
                        onStartChanged: (v) => _update(i, start: v),
                        onEndChanged: (v) => _update(i, end: v),
                        isLast: i == _hours.length - 1,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            BlocBuilder<BusinessHoursBloc, BusinessHoursState>(
              builder: (context, blocState) {
                final loading = blocState is BusinessHoursLoaded ? blocState.loading : false;
                return AppButton(
                  label: 'Salvar alterações',
                  loading: loading,
                  function: loading
                      ? null
                      : () => context.read<BusinessHoursBloc>().add(
                            UpdateTeamMember(
                              widget.member.id,
                              CreateTeamModel(
                                name: widget.member.name,
                                email: widget.member.email,
                                phone: widget.member.phone,
                                role: widget.member.role,
                                status: widget.member.status,
                                themeColor: widget.member.themeColor,
                                workingHours: _hours.map((h) => {
                                  'day': h.day,
                                  'startAt': h.startAt,
                                  'endAt': h.endAt,
                                  'isWorking': h.isWorking,
                                }).toList(),
                                profileImageUrl: widget.member.profileImageUrl,
                              ),
                            ),
                          ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DayEditorRow extends StatelessWidget {
  final WorkingHourModel model;
  final List<Map<String, Object?>> hourOptions;
  final ValueChanged<bool> onWorkingChanged;
  final ValueChanged<String> onStartChanged;
  final ValueChanged<String> onEndChanged;
  final bool isLast;

  const _DayEditorRow({
    required this.model,
    required this.hourOptions,
    required this.onWorkingChanged,
    required this.onStartChanged,
    required this.onEndChanged,
    this.isLast = false,
  });

  String get displayDay =>
      model.day.contains('-') ? model.day.split('-')[0] : model.day;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 75,
              child: Text(
                displayDay,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            // Substituído ícone por AppToggleSwitch
            AppToggleSwitch(
              isTrue: model.isWorking,
              function: () => onWorkingChanged(!model.isWorking),
            ),
            const SizedBox(width: 12),
            if (model.isWorking)
              Expanded(
                child: Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: AppDropdown(
                        items: hourOptions,
                        labelKey: 'label',
                        valueKey: 'value',
                        selectedValue: model.startAt,
                        placeholder: const Text('Início'),
                        onChanged: (v) => onStartChanged(v as String),
                        borderRadius: 8,
                      ),
                    ),
                    Text(
                      'às',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: AppDropdown(
                        items: hourOptions,
                        labelKey: 'label',
                        valueKey: 'value',
                        selectedValue: model.endAt,
                        placeholder: const Text('Fim'),
                        onChanged: (v) => onEndChanged(v as String),
                        borderRadius: 8,
                      ),
                    ),
                  ],
                ),
              )
            else
              const Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Não trabalha',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 1,
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ),
      ],
    );
  }
}

class _ExpandedMemberRow extends StatelessWidget {
  final TeamMemberModel member;
  final String schedule;
  final VoidCallback onEdit; // novo callback
  const _ExpandedMemberRow({
    required this.member,
    required this.schedule,
    required this.onEdit,
  });

  Color _parseColor(String hex) {
    if (hex.isEmpty) return Colors.blueGrey;
    final cleaned = hex.replaceFirst('#', '');
    final full = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    return Color(int.tryParse('0x$full') ?? 0xFF607D8B);
  }

  @override
  Widget build(BuildContext context) {
    _parseColor(member.themeColor);
    return GestureDetector(
      onTap: onEdit, // abrir modal de editar hora
      child: Container(
        color: Colors.transparent,
        child: Row(
          spacing: 12,
          children: [
            _MemberAvatar(member: member),
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    schedule,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  final TeamMemberModel member;
  const _MemberAvatar({required this.member});
  Color _parseColor(String hex) {
    if (hex.isEmpty) return Colors.blueGrey;
    final cleaned = hex.replaceFirst('#', '');
    final full = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    return Color(int.tryParse('0x$full') ?? 0xFF607D8B);
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(member.themeColor);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 1),
          ),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.15),
                image:
                    member.profileImageUrl != null &&
                        member.profileImageUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(member.profileImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child:
                  member.profileImageUrl == null ||
                      member.profileImageUrl!.isEmpty
                  ? Center(
                      child: Text(
                        member.name.isNotEmpty
                            ? member.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: color.withValues(alpha: 0.9),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
