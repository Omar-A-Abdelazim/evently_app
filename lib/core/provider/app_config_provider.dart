import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  void changeTheme(ThemeMode newTheme) async {
    if (themeMode == newTheme) return;
    themeMode = newTheme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", isDark);
  }

  bool get isDark => themeMode == ThemeMode.dark;

  String Local = "en";

  void changeLocale(String newLocale) async {
    if (Local == newLocale) return;
    Local = newLocale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("locale", Local);
  }

  bool get isEnglish => Local == "en";
}
