import 'package:flutter/services.dart';

class PaymentsFormatters {
  static final TextInputFormatter cardNumberMaskFormatter = _CardNumberMaskFormatter();
  static final TextInputFormatter cardExpiryInputFormatter = _CardExpiryInputFormatter();
}

class _CardExpiryInputFormatter extends TextInputFormatter {
  String _onlyDigits(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    return digits.length > 4 ? digits.substring(0, 4) : digits;
  }

  String _formatDigits(String digits) {
    if (digits.isEmpty) return '';
    if (digits.length <= 2) return digits; 
    final month = digits.substring(0, 2);
    final year = digits.substring(2);
    return '$month/$year';
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = _onlyDigits(newValue.text);
    final formatted = _formatDigits(digits);

    final newCursorDigitPosition = _onlyDigits(
      newValue.text.substring(0, newValue.selection.end),
    ).length;

    var digitCount = 0;
    var selectionIndex = 0;
    while (selectionIndex < formatted.length && digitCount < newCursorDigitPosition) {
      if (RegExp(r'\d').hasMatch(formatted[selectionIndex])) digitCount++;
      selectionIndex++;
    }

    if (selectionIndex > formatted.length) selectionIndex = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class _CardNumberMaskFormatter extends TextInputFormatter {
  static const int _maxDigits = 16;
  static const int _groupSize = 4;
  static const String _separator = ' ';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int rawCursorPos = newValue.selection.end.clamp(0, newValue.text.length);

    final onlyDigits = newValue.text.replaceAll(RegExp(r'\D'), '');

    final limitedDigits = onlyDigits.length > _maxDigits
        ? onlyDigits.substring(0, _maxDigits)
        : onlyDigits;

    final digitsBeforeCursor = _countDigitsBefore(rawCursorPos, newValue.text);

    final formatted = _applySpacing(limitedDigits);

    final newCursorPos = _mapDigitIndexToFormattedIndex(digitsBeforeCursor, formatted);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
  }

  int _countDigitsBefore(int index, String text) {
    int count = 0;
    final limit = index.clamp(0, text.length);
    for (int i = 0; i < limit; i++) {
      if (RegExp(r'\d').hasMatch(text[i])) count++;
    }
    return count.clamp(0, _maxDigits);
  }

  String _applySpacing(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i != 0 && i % _groupSize == 0) buffer.write(_separator);
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  int _mapDigitIndexToFormattedIndex(int digitIndex, String formatted) {
    final groupsBefore = digitIndex ~/ _groupSize;
    final idx = digitIndex + groupsBefore;
    return idx.clamp(0, formatted.length);
  }
}
