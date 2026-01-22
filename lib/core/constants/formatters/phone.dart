import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  final String? mask;
  final int? maxDigits;

  PhoneFormatter({this.mask, this.maxDigits});

  factory PhoneFormatter.fromPattern({String? phoneMask, int? phoneMaxLength}) {
    return PhoneFormatter(mask: phoneMask, maxDigits: phoneMaxLength);
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = _digitsOnly(newValue.text);

    final clamped =
        (maxDigits != null && raw.length > maxDigits!)
            ? raw.substring(0, maxDigits!)
            : raw;

    if (mask == null || mask!.isEmpty) {
      final digitsBeforeCursor = _digitsOnly(
        newValue.text.substring(
          0,
          newValue.selection.extentOffset.clamp(0, newValue.text.length),
        ),
      ).length.clamp(0, clamped.length);

      return TextEditingValue(
        text: clamped,
        selection: TextSelection.collapsed(offset: digitsBeforeCursor),
        composing: TextRange.empty,
      );
    }

    final formatted = _applyMask(clamped, mask!);

    final digitsBeforeCursor = _digitsOnly(
      newValue.text.substring(
        0,
        newValue.selection.extentOffset.clamp(0, newValue.text.length),
      ),
    ).length.clamp(0, clamped.length);

    final caret = _offsetForDigitPosition(formatted, digitsBeforeCursor);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: caret),
      composing: TextRange.empty,
    );
  }

  String _applyMask(String digits, String mask) {
    if (digits.isEmpty) return '';

    final buf = StringBuffer();
    int di = 0;

    for (int i = 0; i < mask.length && di < digits.length; i++) {
      final ch = mask[i];
      if (ch == '#') {
        buf.write(digits[di++]);
      } else {
        buf.write(ch);
      }
    }
    return buf.toString();
  }

  int _offsetForDigitPosition(String formatted, int digitPos) {
    if (digitPos <= 0) {
      for (int i = 0; i < formatted.length; i++) {
        if (_isDigit(formatted.codeUnitAt(i))) return i;
      }
      return 0;
    }

    int seen = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (_isDigit(formatted.codeUnitAt(i))) {
        seen++;
        if (seen == digitPos) {
          return i + 1;
        }
      }
    }
    return formatted.length;
  }

  String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

  bool _isDigit(int codeUnit) => codeUnit >= 48 && codeUnit <= 57;
}

bool isValidEmail(String email) {
  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email.trim());
}
