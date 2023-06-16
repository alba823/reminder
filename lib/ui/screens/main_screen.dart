import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
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
      final backgroundColor =
          state.isDarkTheme() ? darkThemeColor : lightThemeColor;
      final icon = state.isDarkTheme() ? Icons.dark_mode : Icons.light_mode;

      return MaterialApp(
          title: 'Flutter Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: Scaffold(
              appBar: _getAppBar(backgroundColor, textColor, icon, () {
                BlocProvider.of<ThemeCubit>(context).switchTheme();
                BlocProvider.of<CalendarBloc>(context).add(OnUpdate());
              }),
              body: const CalendarScreen()));
    });
  }

  PreferredSizeWidget? _getAppBar(Color backgroundColor, Color textColor,
      IconData icon, VoidCallback onSwitchThemePressed) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      title: Text(
        "Reminder",
        style: TextStyle(color: textColor),
      ),
      actions: <Widget>[
        IconButton(
            splashRadius: 24,
            onPressed: onSwitchThemePressed,
            icon: Icon(icon, color: textColor)),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: textColor),
      ),
    );
  }
}
