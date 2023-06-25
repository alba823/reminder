import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/ui/widgets/calendar_widget.dart';
import 'package:reminder/ui/widgets/events_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        appBar: _getAppBar(AppLocalizations.of(context)!.appTitle,
            backgroundColor, textColor, icon, () {
          BlocProvider.of<ThemeCubit>(context).switchTheme();
        }),
        body: Column(
          children: <Widget>[
            const CalendarWidget(),
            const Padding(
                padding: EdgeInsets.only(top: 8), child: Divider(height: 0.1)),
            Expanded(
                child:
                    EventsWidget(buttonBackgroundColor: buttonBackgroundColor)),
          ],
        ));
  }

  PreferredSizeWidget? _getAppBar(String title, Color backgroundColor,
      Color textColor, IconData icon, VoidCallback onSwitchThemePressed) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      title: Text(
        title,
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
