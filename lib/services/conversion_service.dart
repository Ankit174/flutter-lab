import '../models/conversion.dart';

/// Pure service class handling temperature conversion formulas, 
/// input validation, and formatting logic.
class ConversionService {
  /// Converts a temperature [value] from unit [from] to unit [to].
  static double convert(double value, TemperatureUnit from, TemperatureUnit to) {
    if (from == to) {
      return value;
    }

    switch (from) {
      case TemperatureUnit.celsius:
        if (to == TemperatureUnit.fahrenheit) {
          // F = (C * 9/5) + 32
          return (value * 9 / 5) + 32;
        } else if (to == TemperatureUnit.kelvin) {
          // K = C + 273.15
          return value + 273.15;
        }
        break;

      case TemperatureUnit.fahrenheit:
        if (to == TemperatureUnit.celsius) {
          // C = (F - 32) * 5/9
          return (value - 32) * 5 / 9;
        } else if (to == TemperatureUnit.kelvin) {
          // K = (F - 32) * 5/9 + 273.15
          return (value - 32) * 5 / 9 + 273.15;
        }
        break;

      case TemperatureUnit.kelvin:
        if (to == TemperatureUnit.celsius) {
          // C = K - 273.15
          return value - 273.15;
        } else if (to == TemperatureUnit.fahrenheit) {
          // F = (K - 273.15) * 9/5 + 32
          return (value - 273.15) * 9 / 5 + 32;
        }
        break;
    }

    return value;
  }

  /// Validates string input [inputText] against [unit] limits.
  /// Returns an error message string if invalid, or `null` if valid.
  static String? validateInput(String inputText, TemperatureUnit unit) {
    final trimmed = inputText.trim();
    if (trimmed.isEmpty) {
      return 'Please enter a temperature value.';
    }

    final parsedValue = double.tryParse(trimmed);
    if (parsedValue == null) {
      return 'Please enter a valid numeric value.';
    }

    if (parsedValue < unit.minLimit) {
      return 'Temperature cannot be below absolute zero (${formatNumber(unit.minLimit)} ${unit.symbol}).';
    }

    return null;
  }

  /// Formats a double number neatly without unnecessary trailing zeros.
  /// Examples:
  /// - 25.00 -> "25"
  /// - 373.1500 -> "373.15"
  /// - 98.6 -> "98.6"
  static String formatNumber(double value) {
    // Round to max 4 decimal places to prevent float precision artifacts (e.g. 25.000000000000004)
    final rounded = double.parse(value.toStringAsFixed(4));
    
    if (rounded == rounded.truncateToDouble()) {
      return rounded.toInt().toString();
    }
    
    // Remove trailing zeros
    String str = rounded.toString();
    if (str.contains('.')) {
      str = str.replaceAll(RegExp(r'0+$'), '');
      str = str.replaceAll(RegExp(r'\.$'), '');
    }
    return str;
  }

  /// Returns the mathematical formula string for educational display.
  static String getFormulaHint(TemperatureUnit from, TemperatureUnit to) {
    if (from == to) {
      return '${to.symbol} = ${from.symbol}';
    }
    
    if (from == TemperatureUnit.celsius && to == TemperatureUnit.fahrenheit) {
      return 'F = (C × 9/5) + 32';
    } else if (from == TemperatureUnit.fahrenheit && to == TemperatureUnit.celsius) {
      return 'C = (F − 32) × 5/9';
    } else if (from == TemperatureUnit.celsius && to == TemperatureUnit.kelvin) {
      return 'K = C + 273.15';
    } else if (from == TemperatureUnit.kelvin && to == TemperatureUnit.celsius) {
      return 'C = K − 273.15';
    } else if (from == TemperatureUnit.fahrenheit && to == TemperatureUnit.kelvin) {
      return 'K = (F − 32) × 5/9 + 273.15';
    } else if (from == TemperatureUnit.kelvin && to == TemperatureUnit.fahrenheit) {
      return 'F = (K − 273.15) × 9/5 + 32';
    }
    return '';
  }
}
