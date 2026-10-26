import 'package:flutter/material.dart';

class AppConfigProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  void changeLanguage(String languageCode) {
    if (!['en','ar'].contains(languageCode) ||
        _locale.languageCode == languageCode) {
      return;
    }
    _locale = Locale(languageCode);
    notifyListeners();
  }

  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  void changeTheme(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;
}
