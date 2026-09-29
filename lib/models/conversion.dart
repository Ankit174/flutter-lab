// Model classes and Enums for the Temperature Converter application.

/// Enum representing supported temperature units.
enum TemperatureUnit {
  celsius,
  fahrenheit,
  kelvin,
}

/// Extension methods for [TemperatureUnit] providing user-friendly display properties
/// and absolute zero thresholds.
extension TemperatureUnitExtension on TemperatureUnit {
  /// Returns the short unit symbol (e.g., °C, °F, K)
  String get symbol {
    switch (this) {
      case TemperatureUnit.celsius:
        return '°C';
      case TemperatureUnit.fahrenheit:
        return '°F';
      case TemperatureUnit.kelvin:
        return 'K';
    }
  }

  /// Returns the full name of the unit (e.g., Celsius)
  String get displayName {
    switch (this) {
      case TemperatureUnit.celsius:
        return 'Celsius';
      case TemperatureUnit.fahrenheit:
        return 'Fahrenheit';
      case TemperatureUnit.kelvin:
        return 'Kelvin';
    }
  }

  /// Absolute zero limit in this unit's scale.
  /// Anything lower than this value is physically impossible.
  double get minLimit {
    switch (this) {
      case TemperatureUnit.celsius:
        return -273.15;
      case TemperatureUnit.fahrenheit:
        return -459.67;
      case TemperatureUnit.kelvin:
        return 0.0;
    }
  }
}

/// Class representing a recorded conversion entry for history persistence.
class ConversionRecord {
  final String id;
  final double fromValue;
  final TemperatureUnit fromUnit;
  final double toValue;
  final TemperatureUnit toUnit;
  final DateTime timestamp;

  ConversionRecord({
    required this.id,
    required this.fromValue,
    required this.fromUnit,
    required this.toValue,
    required this.toUnit,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Converts record to JSON map for local storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromValue': fromValue,
      'fromUnit': fromUnit.name,
      'toValue': toValue,
      'toUnit': toUnit.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Creates a [ConversionRecord] from JSON map.
  factory ConversionRecord.fromJson(Map<String, dynamic> json) {
    return ConversionRecord(
      id: json['id'] as String,
      fromValue: (json['fromValue'] as num).toDouble(),
      fromUnit: TemperatureUnit.values.firstWhere(
        (u) => u.name == json['fromUnit'],
        orElse: () => TemperatureUnit.celsius,
      ),
      toValue: (json['toValue'] as num).toDouble(),
      toUnit: TemperatureUnit.values.firstWhere(
        (u) => u.name == json['toUnit'],
        orElse: () => TemperatureUnit.fahrenheit,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
