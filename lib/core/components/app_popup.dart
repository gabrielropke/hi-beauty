import 'package:flutter/material.dart';

enum AppPopupType { confirm, warning, delete }

class AppPopup extends StatelessWidget {
  final AppPopupType type;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const AppPopup({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onCancel,
    this.onConfirm,
  });

  String _getDefaultActionLabel() {
    switch (type) {
      case AppPopupType.confirm:
        return 'Confirmar';
      case AppPopupType.warning:
        return 'Confirmar';
      case AppPopupType.delete:
        return 'Excluir';
    }
  }

  Color _getActionColor() {
    switch (type) {
      case AppPopupType.confirm:
        return Colors.blue;
      case AppPopupType.warning:
        return Colors.orange;
      case AppPopupType.delete:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionColor = _getActionColor();
    final effectiveActionLabel = actionLabel ?? _getDefaultActionLabel();

    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: actionColor,
          ),
          child: Text(effectiveActionLabel),
        ),
      ],
    );
  }

  /// Método estático para exibir o popup
  static Future<bool?> show({
    required BuildContext context,
    required AppPopupType type,
    required String title,
    required String description,
    String? actionLabel,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AppPopup(
        type: type,
        title: title,
        description: description,
        actionLabel: actionLabel,
        onCancel: onCancel ?? () => Navigator.of(context).pop(false),
        onConfirm: onConfirm ?? () => Navigator.of(context).pop(true),
      ),
    );
  }
}
