import 'package:flutter/material.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppLoader extends StatelessWidget {
  final double? size;
  final Color? color;
  const AppLoader({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        color: color ?? AppColors.primary,
        size: size ?? 36,
      ),
    );
  }
}
