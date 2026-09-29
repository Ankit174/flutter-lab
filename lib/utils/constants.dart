import 'package:flutter/material.dart';
import '../models/conversion.dart';

/// Class representing a quick conversion example preset.
class QuickExample {
  final double fromValue;
  final TemperatureUnit fromUnit;
  final double toValue;
  final TemperatureUnit toUnit;
  final String title;

  const QuickExample({
    required this.fromValue,
    required this.fromUnit,
    required this.toValue,
    required this.toUnit,
    required this.title,
  });
}

/// Constant values, theme parameters, and presets used throughout the app.
class AppConstants {
  // SharedPreferences Keys
  static const String prefThemeKey = 'is_dark_mode';
  static const String prefHistoryKey = 'conversion_history_v1';

  // Professional Teal/Blue Color Scheme
  static const Color primaryTeal = Color(0xFF00796B);
  static const Color primaryBlue = Color(0xFF0288D1);
  static const Color accentCyan = Color(0xFF00BCD4);
  static const Color accentAmber = Color(0xFFFFB300);

  // Gradient Colors for Background
  static const List<Color> lightGradient = [
    Color(0xFFE0F7FA),
    Color(0xFFE1F5FE),
    Color(0xFFF3E5F5),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF0F172A),
    Color(0xFF1E293B),
    Color(0xFF0F2027),
  ];

  // Quick Examples Presets
  static const List<QuickExample> quickExamples = [
    QuickExample(
      fromValue: 0,
      fromUnit: TemperatureUnit.celsius,
      toValue: 32,
      toUnit: TemperatureUnit.fahrenheit,
      title: 'Freezing Point (0°C = 32°F)',
    ),
    QuickExample(
      fromValue: 100,
      fromUnit: TemperatureUnit.celsius,
      toValue: 212,
      toUnit: TemperatureUnit.fahrenheit,
      title: 'Boiling Point (100°C = 212°F)',
    ),
    QuickExample(
      fromValue: 0,
      fromUnit: TemperatureUnit.celsius,
      toValue: 273.15,
      toUnit: TemperatureUnit.kelvin,
      title: 'Absolute Zero °C (0°C = 273.15K)',
    ),
    QuickExample(
      fromValue: 37,
      fromUnit: TemperatureUnit.celsius,
      toValue: 98.6,
      toUnit: TemperatureUnit.fahrenheit,
      title: 'Body Temp (37°C = 98.6°F)',
    ),
  ];

  // UI Dimensions
  static const double borderRadius = 16.0;
  static const double padding = 16.0;
}
