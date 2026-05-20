import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  String locale = "en";

  AppConfigProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString("locale");
    final isDarkSaved = prefs.getBool("isDark");

    if (savedLocale != null) {
      locale = savedLocale;
    }
    if (isDarkSaved != null) {
      themeMode = isDarkSaved ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  void changeTheme(ThemeMode newTheme) async {
    if (themeMode == newTheme) return;
    themeMode = newTheme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", themeMode == ThemeMode.dark);
  }

  void toggleTheme() => changeTheme(isDark ? ThemeMode.light : ThemeMode.dark);

  void changeLocale(String newLocale) async {
    if (locale == newLocale) return;
    locale = newLocale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("locale", locale);
  }

  Future<void> toggleLanguage() async {
    locale = (locale == "en") ? "ar" : "en";
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("locale", locale);
  }

  bool get isDark => themeMode == ThemeMode.dark;
  bool get isEnglish => locale == "en";
}
