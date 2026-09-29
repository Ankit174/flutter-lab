import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved theme preference prior to app launch
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool(AppConstants.prefThemeKey) ?? false;

  runApp(TemperatureConverterApp(initialDarkMode: isDarkMode));
}

/// Root widget for the Temperature Converter Mobile Application.
class TemperatureConverterApp extends StatefulWidget {
  final bool initialDarkMode;

  const TemperatureConverterApp({
    super.key,
    required this.initialDarkMode,
  });

  @override
  State<TemperatureConverterApp> createState() => _TemperatureConverterAppState();
}

class _TemperatureConverterAppState extends State<TemperatureConverterApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialDarkMode;
  }

  /// Toggles theme mode and saves the state to SharedPreferences.
  Future<void> _toggleTheme(bool isDark) async {
    setState(() {
      _isDarkMode = isDark;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefThemeKey, isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      
      // Light Material 3 Theme Data
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryTeal,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: const CardThemeData(
          elevation: 2,
          color: Colors.white,
        ),
      ),

      // Dark Material 3 Theme Data
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryTeal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardTheme: const CardThemeData(
          elevation: 2,
          color: Color(0xFF1E293B),
        ),
      ),

      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}
