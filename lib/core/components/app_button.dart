// ignore_for_file: deprecated_member_use

import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppButton extends StatelessWidget {
  final Color? fillColor;
  final Color? labelColor;
  final Color? borderColor;
  final Color? assetColor;
  final String? label;
  final double? width;
  final double? height;
  final double? borderWidth;
  final String? asset;
  final Widget? preffixIcon;
  final Widget? suffixIcon;
  final double? assetWidth;
  final double? assetOpacity;
  final MainAxisAlignment? mainAxisAlignment;
  final int? maxLines;
  final void Function()? function;
  final double? borderRadius;
  final bool? enabled;
  final double? spacing;
  final bool? loading;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;
  final MainAxisSize? mainAxisSize;
  const AppButton({
    super.key,
    this.fillColor,
    this.labelColor,
    this.label,
    this.assetColor,
    this.width,
    this.height,
    this.borderColor,
    this.borderWidth,
    this.asset,
    this.mainAxisAlignment,
    this.assetWidth,
    this.assetOpacity,
    this.maxLines,
    this.function,
    this.preffixIcon,
    this.borderRadius,
    this.enabled = true,
    this.suffixIcon,
    this.spacing,
    this.loading = false,
    this.labelStyle,
    this.padding,
    this.mainAxisSize,
  });

  @override
  Widget build(BuildContext context) {
    final isLabelEmpty = label == null || label!.isEmpty;
    return Opacity(
      opacity: enabled! ? 1 : 0.3,
      child: GestureDetector(
        onTap: enabled! || loading! ? function : null,
        child: Container(
          width: width,
          height: height ?? 48,
          padding:
              padding ?? EdgeInsets.symmetric(vertical: !enabled! ? 12 : 0),
          decoration: BoxDecoration(
            border: Border.all(
              width: borderWidth ?? 1,
              color: borderColor ?? Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 62),
            color:
                fillColor ??
                (loading!
                    ? AppColors.primary.withValues(alpha: 0.7)
                    : AppColors.primary),
          ),
          child: loading!
              ? AppLoader(color: labelColor ?? Colors.white)
              : Row(
                  spacing: spacing ?? 5,
                  mainAxisAlignment:
                      mainAxisAlignment ?? MainAxisAlignment.center,
                  mainAxisSize: mainAxisSize ?? MainAxisSize.max,
                  children: [
                    if (preffixIcon != null) preffixIcon!,
                    if (asset != null)
                      Opacity(
                        opacity: assetOpacity ?? 1,
                        child: SvgPicture.asset(
                          asset!,
                          width: assetWidth ?? 18,
                          color: assetColor,
                        ),
                      ),
                    if (!isLabelEmpty)
                      Flexible(
                        child: Text(
                          label ?? 'texto',
                          maxLines: maxLines ?? 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              labelStyle ??
                              TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: labelColor ?? Colors.white,
                              ),
                        ),
                      ),
                    if (suffixIcon != null) suffixIcon!,
                  ],
                ),
        ),
      ),
    );
  }
}
