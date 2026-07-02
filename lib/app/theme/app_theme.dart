import 'package:flutter/material.dart';

/// App theming. Material 3, seeded from a botanical green so light and dark modes
/// stay harmonised from a single source color. Screen-level widgets read colors via
/// `Theme.of(context).colorScheme` — no hard-coded hex outside this file.
class AppTheme {
  const AppTheme._();

  /// Primary brand seed — a leafy green.
  static const Color _seed = Color(0xFF2E7D32);

  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        elevation: 0,
      ),
    );
  }
}
