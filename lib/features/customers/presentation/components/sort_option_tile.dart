import 'package:flutter/material.dart';

class SortOptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const SortOptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            if (selected) const Icon(Icons.check, size: 20),
          ],
        ),
      ),
    );
  }
}
