import 'package:hibeauty/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppToggleSwitch extends StatelessWidget {
  final void Function()? function;
  final bool isTrue;

  const AppToggleSwitch({
    super.key,
    this.isTrue = false,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: 40,
        height: 24,
        decoration: BoxDecoration(
          color: isTrue
              ? AppColors.orangeCustom
              : const Color(0xFFCED1E0).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 3),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuad,
            alignment: isTrue ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 2,
                    offset: const Offset(1, 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
