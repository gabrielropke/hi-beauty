import 'package:flutter/material.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class QuickToneGuide extends StatelessWidget {
  final String selectedTone;
  final Function(String) onToneChanged;

  const QuickToneGuide({
    super.key,
    required this.selectedTone,
    required this.onToneChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final toneOptions = [
      {
        'value': 'AMIGAVEL',
        'title': l10n.toneFriendly,
        'description': l10n.toneFriendlyDesc,
        'icon': LucideIcons.smile,
      },
      {
        'value': 'PROFISSIONAL',
        'title': l10n.toneProfessional,
        'description': l10n.toneProfessionalDesc,
        'icon': LucideIcons.briefcase,
      },
      {
        'value': 'DESCONTRAIDO',
        'title': l10n.toneCasual,
        'description': l10n.toneCasualDesc,
        'icon': LucideIcons.coffee,
      },
      {
        'value': 'FORMAL',
        'title': l10n.toneFormal,
        'description': l10n.toneFormalDesc,
        'icon': LucideIcons.filePenLine,
      },
      {
        'value': 'ENGRACADO',
        'title': l10n.toneFunny,
        'description': l10n.toneFunnyDesc,
        'icon': LucideIcons.laugh,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickToneGuide,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ...toneOptions.map((option) {
          final isSelected = selectedTone == option['value'];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => onToneChanged(option['value'] as String),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected 
                        ? Colors.blue.shade400
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected 
                      ? Colors.blue.withValues(alpha: 0.05)
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Icon(
                      option['icon'] as IconData,
                      size: 20,
                      color: isSelected 
                          ? Colors.blue.shade600
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option['title'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected 
                                  ? Colors.blue.shade700
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            option['description'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected 
                                  ? Colors.blue.shade600
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.selected,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}