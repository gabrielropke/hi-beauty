import 'package:flutter/material.dart';

class FilterChipCustom extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const FilterChipCustom({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: selected
              ? Colors.blueAccent.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.04),
          border: Border.all(
            color: selected
                ? Colors.blueAccent.withValues(alpha: 0.6)
                : Colors.black.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.blueAccent[700] : Colors.black54,
          ),
        ),
      ),
    );
  }
}

// ARQUIVO PODE SER REMOVIDO - substituído por _FilterListTile no filters_drawer.dart
