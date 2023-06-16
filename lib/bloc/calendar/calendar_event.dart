part of 'calendar_bloc.dart';

abstract class CalendarEvent {}

class OnDayClicked extends CalendarEvent {
  final DateTime selectedDay;

  OnDayClicked(this.selectedDay);
}
class OnDayLongClicked extends CalendarEvent {
  final DateTime selectedDay;
  final VoidCallback onDayAdded;

  OnDayLongClicked(this.selectedDay, this.onDayAdded);
}

class OnUpdate extends CalendarEvent {}