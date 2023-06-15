part of 'calendar_bloc.dart';

abstract class CalendarState {
  abstract final DateTime selectedDay;
}

class CalendarInitial extends CalendarState {
  @override
  final selectedDay = DateTime.now();
}
class CalendarDaySelected extends CalendarState {
  @override
  final DateTime selectedDay;

  CalendarDaySelected(this.selectedDay);
}