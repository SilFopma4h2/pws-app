import 'package:flutter/material.dart';

/// Design tokens: archive / museum palette.
class AppColors {
  AppColors._();
  static const paper = Color(0xFFF2EADB); // warm beige
  static const paperLight = Color(0xFFFAF7F0); // gebroken wit
  static const paperDark = Color(0xFFE4D8C2);
  static const green = Color(0xFF1F3A2E); // donkergroen
  static const olive = Color(0xFF5E6B3A); // olijfgroen
  static const anthracite = Color(0xFF2A2B2A);
  static const muted = Color(0xFF5F5A50);
  static const red = Color(0xFF8C2F27); // accent
  static const river = Color(0xFF7C97A3);
  static const line = Color(0xFFCDBFA6);
}

class AppFonts {
  AppFonts._();
  static const heading = 'ZillaSlab';
  static const stamp = 'SpecialElite';
}

ThemeData buildTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.green,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.green,
        onPrimary: Colors.white,
        secondary: AppColors.olive,
        tertiary: AppColors.red,
        surface: AppColors.paperLight,
        onSurface: AppColors.anthracite,
        surfaceContainerHighest: AppColors.paperDark,
        outline: AppColors.line,
        error: AppColors.red,
      );

  const headingStyle = TextStyle(
    fontFamily: AppFonts.heading,
    fontWeight: FontWeight.w700,
    color: AppColors.anthracite,
    height: 1.15,
  );

  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.paper,
    textTheme: base.textTheme
        .apply(
          bodyColor: AppColors.anthracite,
          displayColor: AppColors.anthracite,
        )
        .copyWith(
          displaySmall: headingStyle.copyWith(fontSize: 34),
          headlineMedium: headingStyle.copyWith(fontSize: 28),
          headlineSmall: headingStyle.copyWith(fontSize: 24),
          titleLarge: headingStyle.copyWith(fontSize: 21),
          titleMedium: base.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
          bodyLarge: base.textTheme.bodyLarge?.copyWith(
            fontSize: 17,
            height: 1.5,
          ),
          bodyMedium: base.textTheme.bodyMedium?.copyWith(
            fontSize: 15.5,
            height: 1.45,
          ),
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.paper,
      foregroundColor: AppColors.anthracite,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: AppFonts.heading,
        fontWeight: FontWeight.w700,
        fontSize: 22,
        color: AppColors.anthracite,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.paperLight,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.line),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        minimumSize: const Size(64, 56),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.green,
        minimumSize: const Size(64, 52),
        side: const BorderSide(color: AppColors.green, width: 1.4),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.green,
        minimumSize: const Size(48, 48),
        textStyle: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.paperLight,
      indicatorColor: AppColors.olive.withValues(alpha: 0.22),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      height: 70,
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: AppColors.paperLight,
      side: const BorderSide(color: AppColors.line),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.line, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.paperLight,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.anthracite,
    ),
  );
}
