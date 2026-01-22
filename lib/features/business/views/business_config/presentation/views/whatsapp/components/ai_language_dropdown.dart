import 'package:flutter/material.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class AiLanguageDropdown extends StatefulWidget {
  final Function(String)? onChanged;
  final String? initialValue;

  const AiLanguageDropdown({super.key, this.onChanged, this.initialValue});

  @override
  State<AiLanguageDropdown> createState() => _AiLanguageDropdownState();
}

class _AiLanguageDropdownState extends State<AiLanguageDropdown> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue ?? 'PT-BR';
  }

  @override
  void didUpdateWidget(AiLanguageDropdown oldWidget) {
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
      {'value': 'PT_BR', 'label': '🇧🇷 Português (Brasil)'},
      {'value': 'EN_US', 'label': '🇺🇸 English'},
      {'value': 'ES_ES', 'label': '🇪🇸 Español (España)'},
      {'value': 'ES_AR', 'label': '🌎 Español (Latam)'},
      {'value': 'FR_FR', 'label': '🇫🇷 Français'},
      {'value': 'IT_IT', 'label': '🇮🇹 Italiano'},
      {'value': 'DE_DE', 'label': '🇩🇪 Deutsch'},
    ];

    return AppDropdown(
      items: items,
      labelKey: 'label',
      valueKey: 'value',
      title: l10n.language,
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