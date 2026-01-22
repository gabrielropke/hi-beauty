import 'package:flutter/material.dart';

class AppIsEmpty extends StatelessWidget {
  final String label;
  final String? description;
  final Widget? component;
  final Widget? componentBottom;
  const AppIsEmpty({
    super.key,
    required this.label,
    this.description,
    this.component,
    this.componentBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (component != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: component,
            ),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
          if (description != null)
            Text(
              description!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          if (componentBottom != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: componentBottom,
            ),
        ],
      ),
    );
  }
}
