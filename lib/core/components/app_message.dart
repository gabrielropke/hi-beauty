import 'package:flutter/material.dart';

enum MessageType { success, warning, failure }

class AppMessage extends StatelessWidget {
  final String label;
  final MessageType type;
  final void Function()? function;
  final void Function()? onTapAction;
  final double? radius;

  const AppMessage({
    super.key,
    required this.label,
    required this.type,
    this.function,
    this.radius,
    this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: label.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: _color(type).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(radius ?? 8),
            border: Border.all(color: _color(type).withValues(alpha: 0.5),),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _color(type),
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(text: label),
                        if (onTapAction != null) ...[const TextSpan(text: ' ')],
                      ],
                    ),
                  ),
                ),
                if (function != null)
                  IconButton(
                    onPressed: function,
                    icon: Icon(
                      Icons.close,
                      color: _color(type),
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _color(MessageType type) {
  switch (type) {
    case MessageType.success:
      return Colors.green;
    case MessageType.warning:
      return Colors.orange;
    case MessageType.failure:
      return Colors.red;
  }
}
