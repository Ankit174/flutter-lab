import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/conversion.dart';
import '../services/conversion_service.dart';
import '../utils/constants.dart';
import '../widgets/history_list.dart';
import '../widgets/result_card.dart';
import '../widgets/temperature_input.dart';
import '../widgets/unit_dropdown.dart';

/// Main screen of the Temperature Converter app.
class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  
  TemperatureUnit _fromUnit = TemperatureUnit.celsius;
  TemperatureUnit _toUnit = TemperatureUnit.fahrenheit;
  
  double? _resultValue;
  String? _originalInputText;
  String? _errorMessage;
  
  List<ConversionRecord> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Loads stored conversion history from SharedPreferences.
  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? historyJsonStr = prefs.getString(AppConstants.prefHistoryKey);
      if (historyJsonStr != null) {
        final List<dynamic> jsonList = jsonDecode(historyJsonStr);
        setState(() {
          _history = jsonList
              .map((item) => ConversionRecord.fromJson(item as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  /// Saves current conversion history list to SharedPreferences.
  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _history.map((item) => item.toJson()).toList();
      await prefs.setString(AppConstants.prefHistoryKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  /// Performs temperature conversion and validates user input.
  void _convert() {
    final text = _controller.text;
    final validationError = ConversionService.validateInput(text, _fromUnit);

    if (validationError != null) {
      setState(() {
        _errorMessage = validationError;
        _resultValue = null;
        _originalInputText = null;
      });
      return;
    }

    final double val = double.parse(text.trim());
    final double converted = ConversionService.convert(val, _fromUnit, _toUnit);

    setState(() {
      _errorMessage = null;
      _resultValue = converted;
      _originalInputText = ConversionService.formatNumber(val);

      // Create new record for history
      final record = ConversionRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fromValue: val,
        fromUnit: _fromUnit,
        toValue: converted,
        toUnit: _toUnit,
      );

      // Prepend to history list (most recent first)
      _history.insert(0, record);
    });

    _saveHistory();
  }

  /// Swaps the "From" and "To" temperature units.
  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });

    // Automatically recalculate if valid input is already present
    if (_controller.text.trim().isNotEmpty && _errorMessage == null) {
      _convert();
    }
  }

  /// Resets the converter state and clears inputs.
  void _reset() {
    setState(() {
      _controller.clear();
      _fromUnit = TemperatureUnit.celsius;
      _toUnit = TemperatureUnit.fahrenheit;
      _resultValue = null;
      _originalInputText = null;
      _errorMessage = null;
    });
  }

  /// Applies a quick conversion example preset.
  void _applyQuickExample(QuickExample example) {
    setState(() {
      _controller.text = ConversionService.formatNumber(example.fromValue);
      _fromUnit = example.fromUnit;
      _toUnit = example.toUnit;
    });
    _convert();
  }

  /// Deletes a specific history record.
  void _deleteHistoryItem(ConversionRecord record) {
    setState(() {
      _history.removeWhere((item) => item.id == record.id);
    });
    _saveHistory();
  }

  /// Clears all stored conversion history.
  void _clearAllHistory() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to delete all conversion history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _history.clear();
              });
              _saveHistory();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Temperature Converter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () => widget.onThemeChanged(!isDark),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? AppConstants.darkGradient
                : AppConstants.lightGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Result Display Card
                ResultCard(
                  resultValue: _resultValue,
                  fromUnit: _fromUnit,
                  toUnit: _toUnit,
                  originalInputValue: _originalInputText,
                ),
                const SizedBox(height: 20),

                // Main Converter Form Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Temperature Input TextField
                        TemperatureInput(
                          controller: _controller,
                          errorText: _errorMessage,
                          onChanged: (_) {
                            if (_errorMessage != null) {
                              setState(() {
                                _errorMessage = null;
                              });
                            }
                          },
                          onClear: () {
                            setState(() {
                              _controller.clear();
                              _errorMessage = null;
                              _resultValue = null;
                              _originalInputText = null;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Unit Selectors and Swap Button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: UnitDropdown(
                                label: 'From',
                                value: _fromUnit,
                                onChanged: (unit) {
                                  if (unit != null) {
                                    setState(() {
                                      _fromUnit = unit;
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 22, left: 4, right: 4),
                              child: Material(
                                color: theme.colorScheme.primaryContainer,
                                shape: const CircleBorder(),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.swap_horiz_rounded,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                  tooltip: 'Swap Units',
                                  onPressed: _swapUnits,
                                ),
                              ),
                            ),
                            Expanded(
                              child: UnitDropdown(
                                label: 'To',
                                value: _toUnit,
                                onChanged: (unit) {
                                  if (unit != null) {
                                    setState(() {
                                      _toUnit = unit;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Action Buttons: Convert & Reset
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: _convert,
                                icon: const Icon(Icons.check_circle_outline_rounded),
                                label: const Text('Convert'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: OutlinedButton.icon(
                                onPressed: _reset,
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text('Reset'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Examples Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Quick Examples',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: AppConstants.quickExamples.map((example) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ActionChip(
                              avatar: const Icon(Icons.bolt_rounded, size: 16),
                              label: Text(example.title),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onPressed: () => _applyQuickExample(example),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Conversion History List Section
                HistoryList(
                  history: _history,
                  onDeleteItem: _deleteHistoryItem,
                  onClearHistory: _clearAllHistory,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
