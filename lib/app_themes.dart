import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void themeToggle(bool isDarkMode) {
    if (isDarkMode) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}

Color backgroundColorLight = const Color(0xFFF1F7ED);
Color primaryColorLight = const Color(0xFF46CE7C);
Color textColorLight = const Color(0xFF09361B);
Color primaryColorLightLight = const Color(0xFF88E3AB);
Color cardColorLight = const Color(0xFFC0EDCE);
Color textColorLightLight = const Color(0xAA09361B);

Color backgroundColorDark = const Color(0xFF242B33);
Color primaryColorDark = const Color(0xFF09361B);
Color textColorDark = const Color(0xFF46A958);
Color primaryColorDarkLight = const Color(0xFF88E3AB);
Color cardColorDark = const Color(0xFF2F383F);
Color textColorDarkLight = const Color(0xAA46A958);

class AppThemes {
  static final light = ThemeData(
    primaryColor: primaryColorLight,
    primaryColorLight: primaryColorLightLight,
    backgroundColor: backgroundColorLight,
    cardColor: cardColorLight,
    iconTheme: IconThemeData(color: textColorLight),
    tabBarTheme: TabBarTheme(
      labelColor: textColorLight,
      labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: textColorLight),
      unselectedLabelColor: textColorLightLight,
      unselectedLabelStyle:
          TextStyle(fontSize: 14, letterSpacing: 1, color: textColorLightLight),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundColorLight,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        letterSpacing: 1,
        fontSize: 16,
        color: textColorLight,
      ),
      selectedIconTheme: IconThemeData(color: textColorLight),
      unselectedIconTheme: IconThemeData(color: textColorLightLight),
      selectedItemColor: textColorLight,
      unselectedItemColor: textColorLightLight,
      showSelectedLabels: true,
      showUnselectedLabels: false,
    ),
  );

  static final dark = ThemeData(
    primaryColor: primaryColorDark,
    primaryColorLight: primaryColorDarkLight,
    backgroundColor: backgroundColorDark,
    cardColor: cardColorDark,
    iconTheme: IconThemeData(color: textColorDark),
    tabBarTheme: TabBarTheme(
      labelColor: textColorDark,
      labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: textColorDark),
      unselectedLabelColor: textColorDarkLight,
      unselectedLabelStyle:
          TextStyle(fontSize: 14, letterSpacing: 1, color: textColorDarkLight),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundColorDark,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        letterSpacing: 1,
        fontSize: 16,
        color: textColorDark,
      ),
      selectedIconTheme: IconThemeData(color: textColorDark),
      unselectedIconTheme: IconThemeData(color: textColorDarkLight),
      selectedItemColor: textColorDark,
      unselectedItemColor: textColorDarkLight,
      showSelectedLabels: true,
      showUnselectedLabels: false,
    ),
  );
}
