import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/ui/screens/calendar_screen.dart';
import 'package:reminder/utils/values/theme_values.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeMode =
            state.isDarkTheme() ? ThemeMode.dark : ThemeMode.light;
        final textColor =
            state.isDarkTheme() ? lightThemeColor : darkThemeColor;
        final buttonBackgroundColor = state.isDarkTheme()
            ? darkThemeButtonBackgroundColor
            : lightThemeButtonBackgroundColor;
        final backgroundColor =
            state.isDarkTheme() ? darkThemeColor : lightThemeColor;
        final icon = state.isDarkTheme() ? Icons.dark_mode : Icons.light_mode;

        return MaterialApp(
          title: 'Flutter Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CalendarScreen(
            textColor: textColor,
            buttonBackgroundColor: buttonBackgroundColor,
            backgroundColor: backgroundColor,
            icon: icon,
          ),
        );
      },
    );
  }
}
