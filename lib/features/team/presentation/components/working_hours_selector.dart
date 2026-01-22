// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/core/components/app_toggle_switch.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class WorkingHoursSelector extends StatefulWidget {
  final List<Map<String, dynamic>> initialWorkingHours;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;
  
  const WorkingHoursSelector({
    super.key,
    required this.initialWorkingHours,
    required this.onChanged,
  });

  @override
  State<WorkingHoursSelector> createState() => _WorkingHoursSelectorState();
}

class _WorkingHoursSelectorState extends State<WorkingHoursSelector> {
  late List<Map<String, dynamic>> _workingHours;

  static const List<String> _weekDays = [
    'Domingo',
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
  ];

  static final List<Map<String, Object?>> _hourOptions = [
    for (int i = 0; i < 24; i++)
      {
        'label': '${i.toString().padLeft(2, '0')}:00',
        'value': '${i.toString().padLeft(2, '0')}:00',
      }
  ];

  @override
  void initState() {
    super.initState();
    _workingHours = _initializeWorkingHours();
  }

  List<Map<String, dynamic>> _initializeWorkingHours() {
    if (widget.initialWorkingHours.isNotEmpty) {
      return List<Map<String, dynamic>>.from(widget.initialWorkingHours);
    }

    // Padrão: segunda a sexta 08:00-17:00, sábado 08:00-12:00, domingo fechado
    return _weekDays.map((day) {
      switch (day) {
        case 'Domingo':
          return {
            'day': day,
            'startAt': '08:00',
            'endAt': '17:00',
            'isWorking': false,
          };
        case 'Sábado':
          return {
            'day': day,
            'startAt': '08:00',
            'endAt': '12:00',
            'isWorking': true,
          };
        default:
          return {
            'day': day,
            'startAt': '08:00',
            'endAt': '17:00',
            'isWorking': true,
          };
      }
    }).toList();
  }

  void _updateWorkingHour(int index, String key, dynamic value) {
    setState(() {
      _workingHours[index][key] = value;
    });
    widget.onChanged(_workingHours);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Icon(LucideIcons.clock, size: 20),
            Text(
              'Horários de trabalho',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Defina os dias e horários de trabalho do colaborador.',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.only(left: 0, right: 8, top: 12, bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (int i = 0; i < _workingHours.length; i++)
                _WorkingDayTile(
                  day: _workingHours[i]['day'],
                  isWorking: _workingHours[i]['isWorking'],
                  startAt: _workingHours[i]['startAt'],
                  endAt: _workingHours[i]['endAt'],
                  hourOptions: _hourOptions,
                  onWorkingChanged: (value) => _updateWorkingHour(i, 'isWorking', value),
                  onStartChanged: (value) => _updateWorkingHour(i, 'startAt', value),
                  onEndChanged: (value) => _updateWorkingHour(i, 'endAt', value),
                  isLast: i == _workingHours.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkingDayTile extends StatelessWidget {
  final String day;
  final bool isWorking;
  final String startAt;
  final String endAt;
  final List<Map<String, Object?>> hourOptions;
  final ValueChanged<bool> onWorkingChanged;
  final ValueChanged<String> onStartChanged;
  final ValueChanged<String> onEndChanged;
  final bool isLast;

  const _WorkingDayTile({
    required this.day,
    required this.isWorking,
    required this.startAt,
    required this.endAt,
    required this.hourOptions,
    required this.onWorkingChanged,
    required this.onStartChanged,
    required this.onEndChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    // Extrair apenas a primeira parte antes do "-" (ou usar nome completo se não tiver)
    final displayDay = day.contains('-') ? day.split('-')[0] : day;
    
    return Column(
      children: [
        Row(
          children: [
             SizedBox(width: 8),
            AppToggleSwitch(
              isTrue: isWorking,
              function: () => onWorkingChanged(!isWorking),
            ),

            SizedBox(width: 12),

            SizedBox(
              width: 75,
              child: Text(
                displayDay,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            
            if (isWorking) ...[
              Expanded(
                child: Row(
                  spacing: 4,
                  children: [
                    Expanded(
                      child: AppDropdown(
                        items: hourOptions,
                        labelKey: 'label',
                        valueKey: 'value',
                        selectedValue: startAt,
                        placeholder: const Text('Início'),
                        onChanged: (v) => onStartChanged(v as String),
                        borderRadius: 8,
                      ),
                    ),
                    Text('às', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    Expanded(
                      child: AppDropdown(
                        items: hourOptions,
                        labelKey: 'label',
                        valueKey: 'value',
                        selectedValue: endAt,
                        placeholder: const Text('Fim'),
                        onChanged: (v) => onEndChanged(v as String),
                        borderRadius: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
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
          ],
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              height: 1,
              color: Colors.black.withOpacity(0.05),
            ),
          ),
      ],
    );
  }
}
