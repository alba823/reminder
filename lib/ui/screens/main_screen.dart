import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/events/events_cubit.dart';
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
    final themeCubit = BlocProvider.of<ThemeCubit>(context);
    final textColor =
        themeCubit.isDarkTheme() ? lightThemeColor : darkThemeColor;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor:
              themeCubit.isDarkTheme() ? darkThemeColor : lightThemeColor,
          title: Text(
            "Reminder",
            style: TextStyle(color: textColor),
          ),
          actions: <Widget>[
            IconButton(
                splashRadius: 24,
                onPressed: () => themeCubit.switchTheme(),
                icon: Icon(
                    themeCubit.isDarkTheme()
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: textColor)),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: textColor),
          ),
        ),
        body: BlocBuilder<EventsCubit, EventsState>(
          builder: (context, state) {
            switch (state) {
              case EventsLoading():
                return const Center(child: CircularProgressIndicator());
              case EventsFailure():
                return const Center(
                  child: Text("Oops, something went wrong"),
                );
              case EventsLoaded():
                return const Column(
                  children: <Widget>[
                    CalendarWidget(),
                    Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Divider()),
                    Expanded(child: EventsWidget()),
                  ],
                );
            }
          },
        ));
  }
}
