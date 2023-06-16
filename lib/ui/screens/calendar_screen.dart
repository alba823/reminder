import 'package:flutter/material.dart';
import 'package:reminder/ui/widgets/calendar_widget.dart';
import 'package:reminder/ui/widgets/events_widget.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        CalendarWidget(),
        Padding(padding: EdgeInsets.only(top: 8), child: Divider()),
        Expanded(child: EventsWidget()),
      ],
    );
  }
}
