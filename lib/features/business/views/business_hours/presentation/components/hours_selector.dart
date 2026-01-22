// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/core/components/app_toggle_switch.dart';

class HoursSelector extends StatefulWidget {
  final List<Map<String, dynamic>> initialWorkingHours;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;
  
  const HoursSelector({
    super.key,
    required this.initialWorkingHours,
    required this.onChanged,
  });

  @override
  State<HoursSelector> createState() => _HoursSelectorState();
}

class _HoursSelectorState extends State<HoursSelector> {
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
        SizedBox(height: 24),
        Text(
          'Configure os horários de funcionamento da sua empresa',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          spacing: 10,
          children: [
            for (int i = 0; i < _workingHours.length; i++)
              _WorkingDayTile(
                day: _workingHours[i]['day'],
                isWorking: _workingHours[i]['open'],
                startAt: _workingHours[i]['startAt'],
                endAt: _workingHours[i]['endAt'],
                hourOptions: _hourOptions,
                onWorkingChanged: (value) => _updateWorkingHour(i, 'open', value),
                onStartChanged: (value) => _updateWorkingHour(i, 'startAt', value),
                onEndChanged: (value) => _updateWorkingHour(i, 'endAt', value),
                isLast: i == _workingHours.length - 1,
              ),
          ],
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
                    'Fechado',
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
        SizedBox(height:10),
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
