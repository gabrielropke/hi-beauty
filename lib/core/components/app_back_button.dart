import 'package:hibeauty/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Visibility(
      visible: canPop,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 34,
          height: 40,
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              LucideIcons.arrowLeft300,
              size: 22,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
