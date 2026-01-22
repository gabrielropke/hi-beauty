import 'package:hibeauty/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextFormFieldType { password }

class AppTextformfield extends StatelessWidget {
  final String? title;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final double? borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final bool shadowOn;
  final bool borderOn;
  final bool? obscureText;
  final String? countryCode;
  final TextInputFormatter? textInputFormatter;
  final bool? enabled;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final void Function()? function;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final String? error;
  final double? errorHeight;
  final bool? hasIcon;
  final bool? hasIconDefault;
  final TextFormFieldType? type;
  final bool isMultiline;
  final BorderRadius? borderRadiusCustomized;
  final int? multilineInitialLines;
  final int? maxLength;
  final bool? isrequired;
  const AppTextformfield({
    super.key,
    this.title = '',
    this.hintText,
    this.borderRadius,
    this.prefixIcon,
    this.borderColor,
    this.shadowOn = true,
    this.borderOn = false,
    this.controller,
    this.keyboardType,
    this.countryCode,
    this.textInputFormatter,
    this.enabled = true,
    this.onChanged,
    this.suffixIcon,
    this.obscureText,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.error,
    this.errorHeight,
    this.hasIcon = true,
    this.isMultiline = false,
    this.hasIconDefault = true,
    this.type,
    this.function,
    this.borderRadiusCustomized,
    this.multilineInitialLines,
    this.maxLength,
    this.isrequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled! ? 1 : 0.5,
      child: Column(
        children: [
          if (title!.isNotEmpty)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    if (isrequired == true)
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          TextFormField(
            controller: controller,
            obscureText: obscureText ?? false,
            onChanged: onChanged,
            enabled: enabled,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            maxLength: maxLength,
            keyboardType: isMultiline ? TextInputType.multiline : keyboardType,
            minLines: isMultiline ? (multilineInitialLines ?? 1) : null,
            maxLines: isMultiline ? null : 1,
            textInputAction: isMultiline
                ? TextInputAction.newline
                : textInputAction,

            focusNode: focusNode,
            onFieldSubmitted: onFieldSubmitted,
            onEditingComplete: onEditingComplete,
            inputFormatters: textInputFormatter == null
                ? []
                : [textInputFormatter!],
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              errorText: error,
              errorStyle: TextStyle(
                height: errorHeight,
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: error?.isEmpty ?? true ? 0 : 14,
              ),
              hintText: hintText ?? 'Digite aqui...',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.black.withValues(alpha: 0.6),
              ),
              disabledBorder: borderOn
                  ? OutlineInputBorder(
                      borderRadius:
                          borderRadiusCustomized ??
                          BorderRadius.circular(borderRadius ?? 8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.black.withValues(alpha: 0.2),
                      ),
                    )
                  : InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    borderRadiusCustomized ??
                    BorderRadius.circular(borderRadius ?? 8),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.black.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    borderRadiusCustomized ??
                    BorderRadius.circular(borderRadius ?? 8),
                borderSide: BorderSide(
                  width: 1,
                  color:
                      borderColor ?? AppColors.secondary.withValues(alpha: 0.5),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                    borderRadiusCustomized ??
                    BorderRadius.circular(borderRadius ?? 8),
                borderSide: const BorderSide(width: 1, color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius:
                    borderRadiusCustomized ??
                    BorderRadius.circular(borderRadius ?? 8),
                borderSide: const BorderSide(width: 1, color: Colors.red),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              prefixIcon: prefixIcon,
              suffixIcon: type == TextFormFieldType.password
                  ? _suffixIcon(obscureText ?? false, function)
                  : suffixIcon,
              prefixIconConstraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  _suffixIcon(bool obscure, void Function()? function) {
    return Opacity(
      opacity: 0.2,
      child: IconButton(
        constraints: BoxConstraints(),
        onPressed: function,
        icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }
}
