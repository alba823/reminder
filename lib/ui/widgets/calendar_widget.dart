import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
import 'package:reminder/bloc/events_v1/events_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/data/models/event.dart';
import 'package:reminder/utils/values/calendar_values.dart';
import 'package:reminder/utils/extensions/date_time_extensions.dart';
import 'package:reminder/utils/values/theme_values.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
        builder: (buildContext, state) {
      final calendarBloc = BlocProvider.of<CalendarBloc>(context);
      final eventBloc = BlocProvider.of<EventsBloc>(context);

      final themePrimaryColor =
          BlocProvider.of<ThemeCubit>(context).isDarkTheme()
              ? lightThemeColor
              : darkThemeColor;
      final themeBackgroundColor =
          BlocProvider.of<ThemeCubit>(context).isDarkTheme()
              ? darkThemeColor
              : lightThemeColor;
      return TableCalendar<Event>(
        focusedDay: state.selectedDay,
        firstDay: kFirstDay,
        lastDay: kLastDay,
        headerStyle: const HeaderStyle(titleCentered: true),
        availableCalendarFormats: const {CalendarFormat.month: ''},
        calendarStyle: CalendarStyle(
            markersAlignment: Alignment.topRight,
            todayDecoration: BoxDecoration(
                border: Border.all(color: themePrimaryColor),
                shape: BoxShape.circle),
            todayTextStyle: TextStyle(color: themePrimaryColor),
            selectedDecoration:
                BoxDecoration(color: themePrimaryColor, shape: BoxShape.circle),
            selectedTextStyle: TextStyle(color: themeBackgroundColor)),
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarBuilders: CalendarBuilders(markerBuilder: _getMarkerBuilder),
        eventLoader: (dateTime) =>
            eventBloc.state.getEventsForDate(dateTime: dateTime),
        selectedDayPredicate: (d) =>
            d.toYearDay() == state.selectedDay.toYearDay(),
        onDaySelected: (dateTime, _) {
          calendarBloc.add(OnDayClicked(dateTime));
          eventBloc.add(GetEventsForDate(dateTime));
        },
        onDayLongPressed: (dateTime, _) {
          calendarBloc.add(OnDayLongClicked(dateTime, () {
            eventBloc.add(GetAllEvents(onCompleted: () {
              eventBloc.add(GetEventsForDate(dateTime));
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
        child: Text(
          events.length.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
}
