import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppGlobalTopMessage extends StatelessWidget {
  final String message;
  final String route;
  const AppGlobalTopMessage({
    super.key,
    required this.message,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(route),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: topPadding,
            bottom: 12,
            left: 16,
            right: 16,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.blue, Colors.lightBlueAccent],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.rocket, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Icon(LucideIcons.chevronRight, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
