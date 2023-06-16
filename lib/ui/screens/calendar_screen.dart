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
      required this.floatingButtonBackgroundColor,
      required this.backgroundColor,
      required this.icon});

  final Color textColor;
  final Color floatingButtonBackgroundColor;

  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getAppBar(backgroundColor, textColor, icon, () {
          BlocProvider.of<ThemeCubit>(context).switchTheme();
          BlocProvider.of<CalendarBloc>(context).add(OnUpdate());
        }),
        floatingActionButton: _getFloatingButton(
            iconColor: textColor,
            backgroundColor: floatingButtonBackgroundColor,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Container(height: 200, color: Colors.greenAccent);
                  });
            }),
        body: const Column(
          children: <Widget>[
            CalendarWidget(),
            Padding(padding: EdgeInsets.only(top: 8), child: Divider()),
            Expanded(child: EventsWidget()),
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

  Widget _getFloatingButton(
      {required Color iconColor,
      required Color backgroundColor,
      required VoidCallback onPressed}) {
    return FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        mini: true,
        child: Icon(
          Icons.add,
          color: iconColor,
        ));
  }
}
