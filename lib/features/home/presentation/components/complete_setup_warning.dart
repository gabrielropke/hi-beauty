import 'package:flutter/material.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CompleteSetupWarning extends StatelessWidget {
  const CompleteSetupWarning({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      // color: Colors.deepPurple
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(LucideIcons.building2300, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  l10n.completeSetup,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
