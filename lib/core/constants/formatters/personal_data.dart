import 'package:flutter/services.dart';

class PersonalDataFormatters {
  static final TextInputFormatter documentMaskFormatter =
      _CpfInputFormatter();
  static final TextInputFormatter birthDateMaskFormatter =
      _BirthDateInputFormatter();
  static final TextInputFormatter cepMaskFormatter = _CepInputFormatter();
}

class _CpfInputFormatter extends TextInputFormatter {
  String _formatDigits(String digits) {
    final d = digits.length > 11 ? digits.substring(0, 11) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < d.length; i++) {
      if (i == 3 || i == 6) buffer.write('.');
      if (i == 9) buffer.write('-');
      buffer.write(d[i]);
    }
    return buffer.toString();
  }

  String _onlyDigits(String text) => text.replaceAll(RegExp(r'\D'), '');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = _onlyDigits(newValue.text);
    final formatted = _formatDigits(digits);

    final newCursorDigitPosition =
        _onlyDigits(newValue.text.substring(0, newValue.selection.end)).length;

    var digitCount = 0;
    var selectionIndex = 0;
    while (selectionIndex < formatted.length &&
        digitCount < newCursorDigitPosition) {
      if (RegExp(r'\d').hasMatch(formatted[selectionIndex])) digitCount++;
      selectionIndex++;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class _BirthDateInputFormatter extends TextInputFormatter {
  String _formatDigits(String digits) {
    final d = digits.length > 8 ? digits.substring(0, 8) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < d.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(d[i]);
    }
    return buffer.toString();
  }

  String _onlyDigits(String text) => text.replaceAll(RegExp(r'\D'), '');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = _onlyDigits(newValue.text);
    final formatted = _formatDigits(digits);

    // Recalcula a posição do cursor
    final newCursorDigitPosition =
        _onlyDigits(newValue.text.substring(0, newValue.selection.end)).length;

    var digitCount = 0;
    var selectionIndex = 0;
    while (selectionIndex < formatted.length &&
        digitCount < newCursorDigitPosition) {
      if (RegExp(r'\d').hasMatch(formatted[selectionIndex])) digitCount++;
      selectionIndex++;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class _CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // somente dígitos
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 8) digits = digits.substring(0, 8);

    String text;
    if (digits.length <= 5) {
      text = digits;
    } else {
      text = '${digits.substring(0, 5)}-${digits.substring(5)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
