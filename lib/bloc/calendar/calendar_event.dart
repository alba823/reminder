part of 'calendar_bloc.dart';

abstract class CalendarEvent {
  abstract final DateTime selectedDay;
}

class OnDayClicked extends CalendarEvent {
  @override
  final DateTime selectedDay;

  OnDayClicked(this.selectedDay);
}
class OnDayLongClicked extends CalendarEvent {
  @override
  final DateTime selectedDay;

  OnDayLongClicked(this.selectedDay);
}
