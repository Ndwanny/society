import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color black = Color(0xFF0A0A0A);
  static const Color darkGray = Color(0xFF141414);
  static const Color cardBg = Color(0xFF1C1C1C);
  static const Color borderColor = Color(0xFF2A2A2A);

  // Accent Colors (from Society260 brand)
  static const Color teal = Color(0xFF7ECFC0);       // Sol's color
  static const Color coral = Color(0xFFE87B6E);      // Zara's color
  static const Color softBlue = Color(0xFF6B9FD4);   // Moni's color
  static const Color lavender = Color(0xFFB8A9D9);
  static const Color gold = Color(0xFFD4A843);

  // Text Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F0E8);
  static const Color textGray = Color(0xFF8A8A8A);
  static const Color textMuted = Color(0xFF555555);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [teal, coral],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [black, darkGray],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Club260 Colors
  static const Color club260Primary = Color(0xFF7ECFC0);
  static const Color club260Secondary = Color(0xFF1A2E2B);

  // Code260 Colors
  static const Color code260Primary = Color(0xFFFFD166);
  static const Color code260Secondary = Color(0xFFEF476F);
  static const Color code260Bg = Color(0xFF1A1A2E);
}
