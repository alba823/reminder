part of 'calendar_bloc.dart';

abstract class CalendarEvent {}

class OnDayClicked extends CalendarEvent {
  final DateTime selectedDay;

  OnDayClicked(this.selectedDay);
}

class OnUpdate extends CalendarEvent {}