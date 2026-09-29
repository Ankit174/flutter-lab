import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/conversion.dart';
import '../services/conversion_service.dart';

/// Prominent result display card with smooth Material animations, 
/// formula hints, and copy-to-clipboard functionality.
class ResultCard extends StatelessWidget {
  final double? resultValue;
  final TemperatureUnit fromUnit;
  final TemperatureUnit toUnit;
  final String? originalInputValue;

  const ResultCard({
    super.key,
    required this.resultValue,
    required this.fromUnit,
    required this.toUnit,
    required this.originalInputValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasResult = resultValue != null && originalInputValue != null;

    final formattedResult = hasResult
        ? ConversionService.formatNumber(resultValue!)
        : '---';

    final formulaHint = ConversionService.getFormulaHint(fromUnit, toUnit);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Result',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                ),
              ),
              if (hasResult)
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  color: theme.colorScheme.onPrimaryContainer,
                  tooltip: 'Copy Result',
                  onPressed: () {
                    final textToCopy = '$formattedResult ${toUnit.symbol}';
                    Clipboard.setData(ClipboardData(text: textToCopy));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Copied "$textToCopy" to clipboard!'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Animated text transition for result value
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: KeyedSubtree(
              key: ValueKey('$formattedResult-${toUnit.name}'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(
                      formattedResult,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    toUnit.symbol,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (hasResult) ...[
            Text(
              '${originalInputValue!} ${fromUnit.symbol} = $formattedResult ${toUnit.symbol}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Formula: $formulaHint',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ] else ...[
            Text(
              'Enter a value and tap Convert',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
