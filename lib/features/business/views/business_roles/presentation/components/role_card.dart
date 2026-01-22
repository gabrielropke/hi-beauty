import 'package:flutter/material.dart';
import 'package:hibeauty/theme/app_colors.dart';

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget body;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.body,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      spacing: 14,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 12,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.10),
                  width: 1,
                ),
              ),
              child: Icon(icon, size: 22, color: AppColors.secondary),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body,
      ],
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: Material(
        key: ValueKey(title),
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: onTap == null ? Colors.transparent : null,
          highlightColor: onTap == null ? Colors.transparent : null,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
