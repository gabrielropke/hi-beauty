import 'package:flutter/material.dart';

class AppColors {
  static ThemeColors? _instance;

  /// Inicializa a instância a partir de um Map JSON
  static void initFromJson(Map<String, dynamic> json) {
    _instance = ThemeColors.fromJson(json);
  }

  /// Define a instância diretamente
  static void setInstance(ThemeColors colors) {
    _instance = colors;
  }

  // Getters seguros usando null check
  static Color get primary => _instance?.primary ?? Colors.black;
  static Color get secondary => _instance?.secondary ?? Colors.deepPurple;
  static Color get background => _instance?.background ?? Color(0xFFF8F8F8);
  static Color get accent => _instance?.accent ?? Colors.orange;
  static Color get text => _instance?.text ?? Colors.black;
  static Color get orangeCustom => _instance?.orangeCustom ?? const Color(0xFFFE7D6B);
}

class ThemeColors {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color accent;
  final Color text;
  final Color orangeCustom;

  const ThemeColors({
    required this.primary,
    required this.secondary,
    required this.background,
    this.accent = Colors.orange,
    this.text = Colors.black,
    this.orangeCustom = const Color(0xFFFE7D6B),
  });

  factory ThemeColors.fromJson(Map<String, dynamic> json) {
    Color parseColor(String? hex, {Color fallback = Colors.black}) {
      if (hex == null || hex.isEmpty) return fallback;
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    }

    return ThemeColors(
      primary: parseColor(json['primary'], fallback: Colors.black),
      secondary: parseColor(json['secondary'], fallback: Colors.deepPurple),
      background: parseColor(json['background'], fallback: Color(0xFFF8F8F8)),
      accent: parseColor(json['accent'], fallback: Colors.orange),
      text: parseColor(json['text'], fallback: Colors.black),
      orangeCustom: parseColor(json['orangeCustom'], fallback: const Color(0xFFFE7D6B)),
    );
  }
}

Color parseColor(String colorString) {
  try {
    if (colorString.isEmpty) return Colors.blue;
    final color = colorString.replaceFirst('#', '');
    final fullColor = color.length == 6 ? 'FF$color' : color;
    return Color(int.parse('0x$fullColor'));
  } catch (e) {
    return Colors.blue;
  }
}