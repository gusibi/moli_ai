import 'package:flutter/material.dart';

class DefaultSettingProvider with ChangeNotifier {
  late bool _isDark = false;
  late String _darkMode = "";
  late String _themename = "";

  bool get isDark => _isDark;

  void setIsDark(bool value) {
    _isDark = value;
    notifyListeners();
  }

  String get darkMode => _darkMode;

  void setDarkMode(String value) {
    _darkMode = value;
    notifyListeners();
  }

  String get themeName => _themename;

  void setThemeName(String value) {
    _themename = value;
    notifyListeners();
  }
}
