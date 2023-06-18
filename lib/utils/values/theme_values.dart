import 'package:flutter/material.dart';

const darkThemeColor = Colors.black87;
const lightThemeColor = Colors.white;

const darkThemeButtonBackgroundColor = Color(0xFF1e1e1e);
const lightThemeButtonBackgroundColor = Color(0xFFececec);

final lightTheme = ThemeData.from(
    colorScheme: const ColorScheme.light(
        primary: darkThemeColor, secondary: darkThemeColor),
    textTheme: TextTheme()
);
final darkTheme = ThemeData.from(
    colorScheme: const ColorScheme.dark(
        primary: lightThemeColor, secondary: lightThemeColor),
    textTheme: TextTheme()
);
