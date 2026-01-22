import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/components/step_data.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class StepChip extends StatelessWidget {
  final StepData data;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;
  const StepChip({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: data.completed ? AppColors.secondary.withValues(alpha: 0.5) : Colors.black12, width: 1),
      ),
      child: InkWell(
        onTap: () => context.push(data.route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: data.completed
                      ? AppColors.secondary.withValues(alpha: 0.1)
                      : Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: data.completed
                    ? Icon(
                        LucideIcons.circleCheckBig400,
                        color: AppColors.secondary,
                      )
                    : Icon(data.icon, color: Colors.black54),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      data.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: data.completed ? AppColors.secondary : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      data.subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        height: 1.25,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_right_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
