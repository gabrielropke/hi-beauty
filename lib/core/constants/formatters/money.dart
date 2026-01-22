import 'package:flutter/widgets.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:intl/intl.dart';



num _parseFlexibleNumber(String input) {
  if (input.trim().isEmpty) return 0;

  final cleaned = input.trim().replaceAll(RegExp(r'[^0-9,.\-]'), '');
  if (cleaned.isEmpty) return 0;

  final isNegative = cleaned.startsWith('-');
  var s = isNegative ? cleaned.substring(1) : cleaned;

  final lastDot = s.lastIndexOf('.');
  final lastComma = s.lastIndexOf(',');

  final decimalIndex = (lastDot > lastComma) ? lastDot : lastComma;

  if (decimalIndex >= 0) {
    final integerPart = s
        .substring(0, decimalIndex)
        .replaceAll(RegExp(r'[^0-9]'), '');
    var fracPart = s
        .substring(decimalIndex + 1)
        .replaceAll(RegExp(r'[^0-9]'), '');
    if (fracPart.isEmpty) fracPart = '0';
    s = '$integerPart.$fracPart';
  } else {
    s = s.replaceAll(RegExp(r'[^0-9]'), '');
  }

  final parsed = num.tryParse(s) ?? 0;
  return isNegative ? -parsed : parsed;
}

String moneyFormat(
  final BuildContext context,
  String valueString, {
  bool includeSymbol = true,
  int? decimalDigits,
  String? overrideCurrency,
}) {
  if (!context.mounted) {
    final value = _parseFlexibleNumber(valueString);
    final fmt = NumberFormat.currency(
      locale: 'pt_BR',
      name: 'BRL',
      symbol: includeSymbol ? 'R\$' : '',
      decimalDigits: decimalDigits ?? 2,
    );
    return fmt.format(value);
  }

  try {
    AppLocalizations.of(context);

    final value = _parseFlexibleNumber(valueString);

    // Always use BRL and pt_BR
    final fmt = NumberFormat.currency(
      locale: 'pt_BR',
      name: 'BRL',
      symbol: includeSymbol ? 'R\$' : '',
      decimalDigits: decimalDigits ?? 2,
    );
    return fmt.format(value);
  } catch (e) {
    final value = _parseFlexibleNumber(valueString);
    final fmt = NumberFormat.currency(
      locale: 'pt_BR',
      name: 'BRL',
      symbol: includeSymbol ? 'R\$' : '',
      decimalDigits: decimalDigits ?? 2,
    );
    return fmt.format(value);
  }
}

String formatCurrencyFromContext(
  BuildContext context,
  String valueString, {
  bool includeSymbol = true,
  int? decimalDigits,
  String? overrideCurrency,
}) {
  if (!context.mounted) {
    final value = _parseFlexibleNumber(valueString);
    final fmt = NumberFormat.currency(
      locale: 'pt_BR',
      name: 'BRL',
      symbol: includeSymbol ? 'R\$' : '',
      decimalDigits: decimalDigits ?? 2,
    );
    return fmt.format(value);
  }

  return moneyFormat(
    context,
    valueString,
    includeSymbol: includeSymbol,
    decimalDigits: decimalDigits,
    overrideCurrency: overrideCurrency,
  );
}

String safeMoneyFormat(
  String valueString, {
  bool includeSymbol = true,
  int? decimalDigits = 2,
  String? locale = 'pt_BR',
  String? currency = 'BRL',
  String? symbol = 'R\$',
}) {
  try {
    final value = _parseFlexibleNumber(valueString);
    final fmt = NumberFormat.currency(
      locale: locale ?? 'pt_BR',
      name: currency ?? 'BRL',
      symbol: includeSymbol ? (symbol ?? 'R\$') : '',
      decimalDigits: decimalDigits ?? 2,
    );
    return fmt.format(value);
  } catch (e) {
    final value = _parseFlexibleNumber(valueString);
    return includeSymbol
        ? 'R\$ ${value.toStringAsFixed(2)}'
        : value.toStringAsFixed(2);
  }
}

String moneyFormatFromCents(
  int cents, {
  bool includeSymbol = true,
  int? decimalDigits = 2,
  String? locale = 'pt_BR',
  String? currency = 'BRL',
  String? symbol = 'R\$',
}) {
  try {
    // Converte centavos para reais dividindo por 100
    final value = cents / 100.0;
    final fmt = NumberFormat.currency(
      locale: locale ?? 'pt_BR',
      name: currency ?? 'BRL',
      symbol: includeSymbol ? (symbol ?? 'R\$') : '',
      decimalDigits: decimalDigits ?? 2,
    );
    return fmt.format(value);
  } catch (e) {
    // Fallback em caso de erro
    final value = cents / 100.0;
    return includeSymbol
        ? 'R\$ ${value.toStringAsFixed(2)}'
        : value.toStringAsFixed(2);
  }
}
