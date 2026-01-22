import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CopyButton extends StatelessWidget {
  final String code;
  final bool isCopied;
  final ValueChanged<bool> onCopyStateChanged;

  const CopyButton({
    super.key,
    required this.code,
    required this.isCopied,
    required this.onCopyStateChanged,
  });

  Future<void> _onCopyPressed() async {
    await Clipboard.setData(ClipboardData(text: code));
    onCopyStateChanged(true);
    Future.delayed(const Duration(seconds: 3), () {
      onCopyStateChanged(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onCopyPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          spacing: 6,
          children: [
            Icon(
              isCopied ? LucideIcons.copyCheck400 : LucideIcons.copy400,
              size: 20,
            ),
            Text(
              isCopied ? 'Copiado' : 'Copiar',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}