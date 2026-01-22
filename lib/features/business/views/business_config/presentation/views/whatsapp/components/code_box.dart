import 'package:flutter/material.dart';

class CodeBox extends StatelessWidget {
  final String part;

  const CodeBox({super.key, required this.part});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Text(
        part,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
          color: Colors.black87,
        ),
      ),
    );
  }
}