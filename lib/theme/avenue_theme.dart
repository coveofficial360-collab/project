import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvenueColors {
  static const Color primary = Color(0xFF005BBF);
  static const Color primaryContainer = Color(0xFF1A73E8);
  static const Color primaryFixed = Color(0xFFD8E2FF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceLow = Color(0xFFF3F4F5);
  static const Color surfaceLowest = Color(0xFFFFFFFF);
  static const Color surfaceHigh = Color(0xFFE7E8E9);
  static const Color outline = Color(0xFF727785);
  static const Color outlineVariant = Color(0xFFC1C6D6);
  static const Color onSurface = Color(0xFF191C1D);
  static const Color onSurfaceVariant = Color(0xFF414754);
  static const Color secondaryFixed = Color(0xFFFFDDAF);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AvenueTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    final interTextTheme = GoogleFonts.interTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: AvenueColors.surface,
      colorScheme: const ColorScheme.light(
        primary: AvenueColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AvenueColors.primaryContainer,
        onPrimaryContainer: Colors.white,
        surface: AvenueColors.surface,
        onSurface: AvenueColors.onSurface,
        secondary: AvenueColors.primary,
      ),
      textTheme: interTextTheme.copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          color: AvenueColors.onSurface,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
          color: AvenueColors.onSurface,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          color: AvenueColors.onSurface,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: AvenueColors.onSurface,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: AvenueColors.onSurface,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AvenueColors.onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AvenueColors.onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AvenueColors.onSurface,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AvenueColors.onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AvenueColors.primary,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
