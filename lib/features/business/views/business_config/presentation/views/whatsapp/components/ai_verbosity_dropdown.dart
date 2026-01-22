import 'package:flutter/material.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class AiVerbosityDropdown extends StatefulWidget {
  final Function(String)? onChanged;
  final String? initialValue;

  const AiVerbosityDropdown({super.key, this.onChanged, this.initialValue});

  @override
  State<AiVerbosityDropdown> createState() => _AiVerbosityDropdownState();
}

class _AiVerbosityDropdownState extends State<AiVerbosityDropdown> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue ?? 'MEDIO';
  }

  @override
  void didUpdateWidget(AiVerbosityDropdown oldWidget) {
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
      {'value': 'CURTO', 'label': l10n.short},
      {'value': 'MEDIO', 'label': l10n.medium},
      {'value': 'DETALHADO', 'label': l10n.detailed},
    ];

    return AppDropdown(
      items: items,
      labelKey: 'label',
      valueKey: 'value',
      title: l10n.verbosity,
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