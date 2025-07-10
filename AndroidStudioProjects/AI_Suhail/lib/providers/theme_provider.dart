import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _isDarkModeKey = 'isDarkMode';
  bool _isDarkMode = true;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  Future<void> _loadThemePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_isDarkModeKey) ?? true; // Default to dark mode
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isDarkModeKey, _isDarkMode);
      notifyListeners();
    }
  }
}
