import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
import 'package:reminder/bloc/events_v1/events_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/data/database/event.dart';
import 'package:reminder/utils/calendar_values.dart';
import 'package:reminder/utils/date_time_extensions.dart';
import 'package:reminder/utils/theme_values.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = BlocProvider.of<ThemeCubit>(context);

    final themeColor =
        themeCubit.isDarkTheme() ? lightThemeColor : darkThemeColor;

    return BlocBuilder<CalendarBloc, CalendarState>(
        builder: (buildContext, state) {
      return TableCalendar<Event>(
        focusedDay: state.selectedDay,
        firstDay: kFirstDay,
        lastDay: kLastDay,
        headerStyle: const HeaderStyle(titleCentered: true),
        availableCalendarFormats: const {CalendarFormat.month: ''},
        calendarStyle: CalendarStyle(
            markersAlignment: Alignment.topRight,
            markerDecoration:
                BoxDecoration(color: themeColor, shape: BoxShape.circle),
            todayDecoration: BoxDecoration(
                border: Border.all(color: themeColor), shape: BoxShape.circle),
            todayTextStyle: TextStyle(color: themeColor)),
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarBuilders: CalendarBuilders(markerBuilder: _getMarkerBuilder),
        eventLoader: (dateTime) => BlocProvider.of<EventsBloc>(buildContext)
            .state
            .getEventsForDate(dateTime: dateTime),
        selectedDayPredicate: (d) =>
            d.convertToYearDay() == state.selectedDay.convertToYearDay(),
        onDaySelected: (dateTime, _) {
          BlocProvider.of<CalendarBloc>(buildContext)
              .add(OnDayClicked(dateTime));
          BlocProvider.of<EventsBloc>(buildContext)
              .add(GetEventsForDate(dateTime));
        },
        onDayLongPressed: (dateTime, _) {
          BlocProvider.of<CalendarBloc>(context)
              .add(OnDayLongClicked(dateTime, () {
            BlocProvider.of<EventsBloc>(context)
                .add(GetAllEvents(onCompleted: () {
                  BlocProvider.of<EventsBloc>(context)
                      .add(GetEventsForDate(dateTime));
            }));
          }));
        },
      );
    });
  }

  final _markerSize = 20.0;

  Widget? _getMarkerBuilder(_, __, List<Event> events) =>
      events.isEmpty ? null : _getMarker(events);

  Widget _getMarker(List<Event> events) => Container(
        alignment: Alignment.center,
        width: _markerSize,
        height: _markerSize,
        decoration: BoxDecoration(
            color: events.every((e) => e.isChecked)
                ? Colors.green
                : Colors.redAccent,
            shape: BoxShape.circle),
        child: Text(events.length.toString()),
      );
}
