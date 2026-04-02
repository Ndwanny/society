import 'package:flutter/material.dart';

class ThemeController {
  static final ThemeController _instance = ThemeController._();
  static ThemeController get instance => _instance;
  ThemeController._();

  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.dark);

  void toggle() {
    themeMode.value =
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  bool get isDark => themeMode.value == ThemeMode.dark;
}
