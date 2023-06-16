import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/ui/screens/calendar_screen.dart';
import 'package:reminder/utils/theme_values.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
      final themeMode = state.isDarkTheme() ? ThemeMode.dark : ThemeMode.light;
      final textColor = state.isDarkTheme() ? lightThemeColor : darkThemeColor;
      final floatingButtonBackgroundColor = state.isDarkTheme()
          ? const Color(0xFF1e1e1e)
          : const Color(0xFFececec);
      final backgroundColor =
          state.isDarkTheme() ? darkThemeColor : lightThemeColor;
      final icon = state.isDarkTheme() ? Icons.dark_mode : Icons.light_mode;

      return MaterialApp(
          title: 'Flutter Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: CalendarScreen(
            textColor: textColor,
            floatingButtonBackgroundColor: floatingButtonBackgroundColor,
            backgroundColor: backgroundColor,
            icon: icon,
          )
      );
    });
  }
}
