import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: LightColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.teal,
        secondary: AppColors.coral,
        surface: LightColors.card,
        onPrimary: AppColors.black,
        onSecondary: AppColors.white,
        onSurface: LightColors.text,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 72,
          fontWeight: FontWeight.w900,
          color: LightColors.text,
          letterSpacing: -3,
          height: 0.95,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: LightColors.text,
          letterSpacing: -2,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: LightColors.text,
          letterSpacing: -1,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: LightColors.text,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: LightColors.text,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: LightColors.text,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: LightColors.textGray,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: LightColors.textGray,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: LightColors.textMuted,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: LightColors.text,
          letterSpacing: 1.5,
        ),
      ),
      cardTheme: CardTheme(
        color: LightColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: LightColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LightColors.text,
          side: const BorderSide(color: LightColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LightColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: LightColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: LightColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
        ),
        labelStyle: GoogleFonts.poppins(color: LightColors.textGray),
        hintStyle: GoogleFonts.poppins(color: LightColors.textMuted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: LightColors.border,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: LightColors.background,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: LightColors.text,
        ),
        iconTheme: const IconThemeData(color: LightColors.text),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.teal,
        secondary: AppColors.coral,
        surface: AppColors.darkGray,
        background: AppColors.black,
        onPrimary: AppColors.black,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        onBackground: AppColors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 72,
          fontWeight: FontWeight.w900,
          color: AppColors.white,
          letterSpacing: -3,
          height: 0.95,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
          letterSpacing: -2,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
          letterSpacing: -1,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.offWhite,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textGray,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textMuted,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
          letterSpacing: 1.5,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderColor, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
        ),
        labelStyle: GoogleFonts.poppins(color: AppColors.textGray),
        hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderColor,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.black,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
    );
  }
}
