import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
import 'package:reminder/bloc/events/events_cubit.dart';
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
    final eventsCubit = BlocProvider.of<EventsCubit>(context);

    final themeColor =
        themeCubit.isDarkTheme() ? lightThemeColor : darkThemeColor;

    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      return TableCalendar<Event>(
        focusedDay: state.selectedDay,
        firstDay: kFirstDay,
        lastDay: kLastDay,
        headerStyle: const HeaderStyle(titleCentered: true),
        availableCalendarFormats: const {CalendarFormat.month: ''},
        calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
                border: Border.all(color: themeColor), shape: BoxShape.circle),
            todayTextStyle: TextStyle(color: themeColor)),
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (d) => d.convertToYearDay() == state.selectedDay.convertToYearDay(),
        onDaySelected: (dateTime, _) {
          BlocProvider.of<CalendarBloc>(context).add(OnDayClicked(dateTime));
          eventsCubit.getEventsForDateTime(dateTime);
        },
      );
    });
  }
}
