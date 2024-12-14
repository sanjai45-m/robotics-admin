import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Initial theme is light
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  // Toggle between light and dark theme
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
