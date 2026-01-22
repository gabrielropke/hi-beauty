// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CodeField extends StatefulWidget {
  final bool enabled;
  final bool codeIsValid;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final int index;
  final VoidCallback? onEditingComplete;
  const CodeField({
    super.key,
    required this.codeIsValid,
    required this.enabled,
    required this.controllers,
    required this.focusNodes,
    required this.index,
    this.onEditingComplete,
  });

  @override
  State<CodeField> createState() => _CodeFieldState();
}

class _CodeFieldState extends State<CodeField> {
  final FocusNode keyboardFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    keyboardFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: keyboardFocus,
      onKey: (event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace) {
          final controller = widget.controllers[widget.index];

          if (controller.text.isNotEmpty) {
            controller.clear();
            if (widget.index > 0) {
              widget.focusNodes[widget.index - 1].requestFocus();
            }
          } else {
            if (widget.index > 0) {
              widget.focusNodes[widget.index - 1].requestFocus();
            }
          }
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 8.5,
        child: TextField(
          autofocus: false,
          enabled: widget.enabled,
          controller: widget.controllers[widget.index],
          focusNode: widget.focusNodes[widget.index],
          textAlign: TextAlign.center,
          maxLength: 1,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.characters,
          textInputAction: widget.index < 5
              ? TextInputAction.next
              : TextInputAction.done,
          cursorHeight: 26,
          style: TextStyle(
            fontSize: 17,
            color: Colors.black.withValues(alpha: 0.6),
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: widget.codeIsValid
                    ? Colors.black.withValues(alpha: 0.15)
                    : Colors.red,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: widget.codeIsValid
                    ? Colors.black.withValues(alpha: 0.1)
                    : Colors.red,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: widget.codeIsValid ? AppColors.primary : Colors.red,
                width: 2,
              ),
            ),
          ),
          onChanged: (value) {
            if (value.isEmpty && widget.index > 0) {
              widget.focusNodes[widget.index - 1].requestFocus();
            } else if (value.length == 1 && widget.index < 5) {
              widget.focusNodes[widget.index + 1].requestFocus();
            }

            final fullCode = widget.controllers.map((c) => c.text).join();
            if (fullCode.length == 6) {
              widget.focusNodes[widget.index].unfocus();
              widget.onEditingComplete!();
            }
          },
          onSubmitted: (_) {
            if (widget.index < 5) {
              widget.focusNodes[widget.index + 1].requestFocus();
            } else {
              widget.focusNodes[widget.index].unfocus();
            }
          },
        ),
      ),
    );
  }
}
