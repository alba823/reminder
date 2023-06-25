part of 'calendar_bloc.dart';

abstract class CalendarState {
  abstract final List<Event> events;

  List<Event> getEventsForDate({DateTime? dateTime});

  abstract final DateTime currentDateTime;

  CalendarState copyWith({List<Event>? events, DateTime? currentDateTime});
}

class EventsEmpty extends CalendarState {
  @override
  final List<Event> events = List.empty();

  @override
  List<Event> getEventsForDate({DateTime? dateTime}) => List.empty();
  @override
  final DateTime currentDateTime;

  EventsEmpty(this.currentDateTime);

  @override
  CalendarState copyWith({List<Event>? events, DateTime? currentDateTime}) =>
      EventsEmpty(currentDateTime ?? this.currentDateTime);
}

class EventsLoaded extends CalendarState {
  @override
  final List<Event> events;

  @override
  final DateTime currentDateTime;

  EventsLoaded(this.events, this.currentDateTime);

  @override
  CalendarState copyWith({List<Event>? events, DateTime? currentDateTime}) =>
      EventsLoaded(
          events ?? this.events, currentDateTime ?? this.currentDateTime);

  @override
  List<Event> getEventsForDate({DateTime? dateTime}) => events
      .where((e) => dateTime == null
          ? e.date == currentDateTime.toYearDay()
          : e.date == dateTime.toYearDay())
      .toList();
}
