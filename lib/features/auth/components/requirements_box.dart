import 'package:hibeauty/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

enum PasswordRule { min6, upper, lower, special }

class RequirementsBox extends StatelessWidget {
  final Set<PasswordRule> values;
  const RequirementsBox({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: Colors.black.withValues(alpha: 0.1),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 12,
          children: [
            _item(values.contains(PasswordRule.min6), l10n.min6Chars),
            _item(values.contains(PasswordRule.upper), l10n.oneUppercase),
            _item(values.contains(PasswordRule.lower), l10n.oneLowercase),
            _item(values.contains(PasswordRule.special), l10n.oneSpecialChar),
          ],
        ),
      ),
    );
  }

  Widget _item(bool check, String label) {
    return Row(
      spacing: 10,
      children: [
        Icon(
          check ? Icons.check_circle : Icons.circle_outlined,
          color: check
              ? AppColors.primary
              : Colors.black.withValues(alpha: 0.5),
          size: 18,
        ),
        Text(
          label,
          style: TextStyle(
            fontWeight: check ? FontWeight.w600 : null,
            color: check
                ? AppColors.primary
                : Colors.black.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
