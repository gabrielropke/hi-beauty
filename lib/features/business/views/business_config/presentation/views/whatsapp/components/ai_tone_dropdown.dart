import 'package:flutter/material.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class AiToneDropdown extends StatefulWidget {
  final Function(String)? onChanged;
  final String? initialValue;

  const AiToneDropdown({super.key, this.onChanged, this.initialValue});

  @override
  State<AiToneDropdown> createState() => _AiToneDropdownState();
}

class _AiToneDropdownState extends State<AiToneDropdown> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue ?? 'AMIGAVEL';
  }

  @override
  void didUpdateWidget(AiToneDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != null && widget.initialValue != _selectedValue) {
      setState(() {
        _selectedValue = widget.initialValue!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final items = [
      {'value': 'AMIGAVEL', 'label': l10n.toneFriendly},
      {'value': 'PROFISSIONAL', 'label': l10n.toneProfessional},
      {'value': 'DESCONTRAIDO', 'label': l10n.toneCasual},
      {'value': 'FORMAL', 'label': l10n.toneFormal},
      {'value': 'ENGRACADO', 'label': l10n.toneFunny},
    ];

    return AppDropdown(
      items: items,
      labelKey: 'label',
      valueKey: 'value',
      title: l10n.tone,
      selectedValue: _selectedValue,
      onChanged: (value) {
        if (value is String) {
          setState(() {
            _selectedValue = value;
          });
          widget.onChanged?.call(value);
        }
      },
    );
  }
}