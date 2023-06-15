import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/ui/widgets/calendar_widget.dart';
import 'package:reminder/ui/widgets/events_widget.dart';
import 'package:reminder/utils/theme_values.dart';

class MainThemeScreen extends StatelessWidget {
  const MainThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, themeState) {
      return MaterialApp(
          title: 'Flutter Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode:
          themeState.isDarkTheme() ? ThemeMode.dark : ThemeMode.light,
          home: const MainScreen());
    });
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
      final textColor = state.isDarkTheme()
          ? lightThemeColor
          : darkThemeColor;
      final backgroundColor = state.isDarkTheme()
          ? darkThemeColor
          : lightThemeColor;
      final icon = state.isDarkTheme()
          ? Icons.dark_mode
          : Icons.light_mode;

      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: backgroundColor,
            title: Text(
              "Reminder",
              style: TextStyle(color: textColor),
            ),
            actions: <Widget>[
              IconButton(
                  splashRadius: 24,
                  onPressed: () =>
                      BlocProvider.of<ThemeCubit>(context).switchTheme(),
                  icon: Icon(
                      icon,
                      color: textColor)),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(height: 1, color: textColor),
            ),
          ),
          body: const Column(
            children: <Widget>[
              CalendarWidget(),
              Padding(padding: EdgeInsets.only(top: 8), child: Divider()),
              Expanded(child: EventsWidget()),
            ],
          ));
    });
  }
}
