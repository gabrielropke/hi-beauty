import 'package:flutter/material.dart';
import 'package:hibeauty/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 6,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.wind_power_rounded,
          size: 30,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
