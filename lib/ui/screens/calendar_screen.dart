import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/ui/widgets/calendar_widget.dart';
import 'package:reminder/ui/widgets/events_widget.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen(
      {super.key,
      required this.textColor,
      required this.buttonBackgroundColor,
      required this.backgroundColor,
      required this.icon});

  final Color textColor;
  final Color buttonBackgroundColor;

  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getAppBar(backgroundColor, textColor, icon, () {
          BlocProvider.of<ThemeCubit>(context).switchTheme();
          BlocProvider.of<CalendarBloc>(context).add(OnUpdate());
        }),
        body: Column(
          children: <Widget>[
            const CalendarWidget(),
            const Padding(padding: EdgeInsets.only(top: 8), child: Divider(height: 0.1)),
            Expanded(child: EventsWidget(buttonBackgroundColor: buttonBackgroundColor)),
          ],
        ));
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
