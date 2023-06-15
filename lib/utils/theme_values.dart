import 'package:flutter/material.dart';

const darkThemeColor = Colors.black87;
const lightThemeColor = Colors.white;

final lightTheme = ThemeData.from(
    colorScheme: const ColorScheme.light(primary: darkThemeColor, secondary: darkThemeColor));
final darkTheme = ThemeData.from(
    colorScheme: const ColorScheme.dark(primary: lightThemeColor, secondary: lightThemeColor));
