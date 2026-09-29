import 'package:flutter_test/flutter_test.dart';
import 'package:temperature_converter/models/conversion.dart';
import 'package:temperature_converter/services/conversion_service.dart';

void main() {
  group('Temperature Converter Logic Tests', () {
    // 1. Celsius ↔ Fahrenheit
    test('Celsius to Fahrenheit conversion', () {
      expect(
        ConversionService.convert(0, TemperatureUnit.celsius, TemperatureUnit.fahrenheit),
        closeTo(32.0, 0.001),
      );
      expect(
        ConversionService.convert(100, TemperatureUnit.celsius, TemperatureUnit.fahrenheit),
        closeTo(212.0, 0.001),
      );
      expect(
        ConversionService.convert(-40, TemperatureUnit.celsius, TemperatureUnit.fahrenheit),
        closeTo(-40.0, 0.001),
      );
    });

    test('Fahrenheit to Celsius conversion', () {
      expect(
        ConversionService.convert(32, TemperatureUnit.fahrenheit, TemperatureUnit.celsius),
        closeTo(0.0, 0.001),
      );
      expect(
        ConversionService.convert(212, TemperatureUnit.fahrenheit, TemperatureUnit.celsius),
        closeTo(100.0, 0.001),
      );
      expect(
        ConversionService.convert(98.6, TemperatureUnit.fahrenheit, TemperatureUnit.celsius),
        closeTo(37.0, 0.001),
      );
    });

    // 2. Celsius ↔ Kelvin
    test('Celsius to Kelvin conversion', () {
      expect(
        ConversionService.convert(0, TemperatureUnit.celsius, TemperatureUnit.kelvin),
        closeTo(273.15, 0.001),
      );
      expect(
        ConversionService.convert(100, TemperatureUnit.celsius, TemperatureUnit.kelvin),
        closeTo(373.15, 0.001),
      );
      expect(
        ConversionService.convert(-273.15, TemperatureUnit.celsius, TemperatureUnit.kelvin),
        closeTo(0.0, 0.001),
      );
    });

    test('Kelvin to Celsius conversion', () {
      expect(
        ConversionService.convert(273.15, TemperatureUnit.kelvin, TemperatureUnit.celsius),
        closeTo(0.0, 0.001),
      );
      expect(
        ConversionService.convert(0, TemperatureUnit.kelvin, TemperatureUnit.celsius),
        closeTo(-273.15, 0.001),
      );
    });

    // 3. Fahrenheit ↔ Kelvin
    test('Fahrenheit to Kelvin conversion', () {
      expect(
        ConversionService.convert(32, TemperatureUnit.fahrenheit, TemperatureUnit.kelvin),
        closeTo(273.15, 0.001),
      );
      expect(
        ConversionService.convert(-459.67, TemperatureUnit.fahrenheit, TemperatureUnit.kelvin),
        closeTo(0.0, 0.001),
      );
    });

    test('Kelvin to Fahrenheit conversion', () {
      expect(
        ConversionService.convert(273.15, TemperatureUnit.kelvin, TemperatureUnit.fahrenheit),
        closeTo(32.0, 0.001),
      );
      expect(
        ConversionService.convert(0, TemperatureUnit.kelvin, TemperatureUnit.fahrenheit),
        closeTo(-459.67, 0.001),
      );
    });

    // 4. Same Unit Conversion
    test('Same unit returns exact same value', () {
      expect(
        ConversionService.convert(42.5, TemperatureUnit.celsius, TemperatureUnit.celsius),
        42.5,
      );
    });
  });

  group('Input Validation Tests', () {
    test('Empty input validation', () {
      expect(
        ConversionService.validateInput('', TemperatureUnit.celsius),
        'Please enter a temperature value.',
      );
      expect(
        ConversionService.validateInput('   ', TemperatureUnit.celsius),
        'Please enter a temperature value.',
      );
    });

    test('Non-numeric input validation', () {
      expect(
        ConversionService.validateInput('abc', TemperatureUnit.celsius),
        'Please enter a valid numeric value.',
      );
      expect(
        ConversionService.validateInput('12.3.4', TemperatureUnit.fahrenheit),
        'Please enter a valid numeric value.',
      );
    });

    test('Absolute zero validation', () {
      // 0 Kelvin is valid, -1 Kelvin is invalid
      expect(
        ConversionService.validateInput('0', TemperatureUnit.kelvin),
        isNull,
      );
      expect(
        ConversionService.validateInput('-1', TemperatureUnit.kelvin),
        contains('cannot be below absolute zero'),
      );

      // -273.15 Celsius is valid, -274 Celsius is invalid
      expect(
        ConversionService.validateInput('-273.15', TemperatureUnit.celsius),
        isNull,
      );
      expect(
        ConversionService.validateInput('-274', TemperatureUnit.celsius),
        contains('cannot be below absolute zero'),
      );

      // -459.67 Fahrenheit is valid, -460 Fahrenheit is invalid
      expect(
        ConversionService.validateInput('-459.67', TemperatureUnit.fahrenheit),
        isNull,
      );
      expect(
        ConversionService.validateInput('-460', TemperatureUnit.fahrenheit),
        contains('cannot be below absolute zero'),
      );
    });
  });

  group('Number Formatting Tests', () {
    test('Formats integers without decimal points', () {
      expect(ConversionService.formatNumber(25.0), '25');
      expect(ConversionService.formatNumber(0.0), '0');
    });

    test('Formats decimals without trailing zeros', () {
      expect(ConversionService.formatNumber(373.1500), '373.15');
      expect(ConversionService.formatNumber(98.6), '98.6');
      expect(ConversionService.formatNumber(25.12345), '25.1234');
    });
  });
}
