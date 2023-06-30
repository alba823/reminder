import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/ui/widgets/calendar_widget.dart';
import 'package:reminder/ui/widgets/events_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reminder/ui/widgets/general/customized_outlined_button.dart';
import 'package:reminder/utils/services/notification_service.dart';

class CalendarScreen extends StatefulWidget {
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
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with WidgetsBindingObserver {

  AppLifecycleState _lifecycleState = AppLifecycleState.resumed;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // FIXME: update permissions state on each on resume callback
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_lifecycleState != state) {
      if (state == AppLifecycleState.resumed) {
        // BlocProvider.of<CalendarBloc>(context).add(CheckPermissions());
      }
      setState(() {
        _lifecycleState = state;
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getAppBar(AppLocalizations.of(context)!.appTitle,
            widget.backgroundColor, widget.textColor, widget.icon, () {
          BlocProvider.of<ThemeCubit>(context).switchTheme();
        }),
        body: Center(child: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            final permissionState = state.permissionState;
            return _getBodyByState(permissionState);
          },
        )));
  }

  Widget _getBodyByState(NotificationPermissionState state) {
    switch (state) {
      case NotificationPermissionState.denied:
        return Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Notifications are required for this app\nPlease enable them"),
            CustomizedOutlinedButton(
                onPressed: () => AppSettings.openNotificationSettings(),
                buttonBackgroundColor: widget.buttonBackgroundColor,
              text: "Open Settings",
            )
          ],
        ));
      case NotificationPermissionState.granted:
        return Column(
          children: <Widget>[
            const CalendarWidget(),
            const Padding(
                padding: EdgeInsets.only(top: 8), child: Divider(height: 0.1)),
            Expanded(
                child:
                EventsWidget(buttonBackgroundColor: widget.buttonBackgroundColor)),
          ],
        );
      case NotificationPermissionState.idle:
        return const Center(child: CircularProgressIndicator());
    }
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
