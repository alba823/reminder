part of 'events_bloc.dart';

abstract class EventsState {
  abstract final List<Event> events;

  List<Event> getEventsForDate({DateTime? dateTime});

  abstract final DateTime currentDateTime;

  EventsState copyWith({List<Event>? events, DateTime? currentDateTime});
}

class EventsEmpty extends EventsState {
  @override
  final List<Event> events = List.empty();

  @override
  List<Event> getEventsForDate({DateTime? dateTime}) => List.empty();
  @override
  final DateTime currentDateTime;

  EventsEmpty(this.currentDateTime);

  @override
  EventsState copyWith({List<Event>? events, DateTime? currentDateTime}) =>
      EventsEmpty(currentDateTime ?? this.currentDateTime);
}

class EventsLoaded extends EventsState {
  @override
  final List<Event> events;

  @override
  final DateTime currentDateTime;

  EventsLoaded(this.events, this.currentDateTime);

  @override
  EventsState copyWith({List<Event>? events, DateTime? currentDateTime}) =>
      EventsLoaded(
          events ?? this.events, currentDateTime ?? this.currentDateTime);

  @override
  List<Event> getEventsForDate({DateTime? dateTime}) => events
      .where((e) => dateTime == null
          ? e.date == currentDateTime.convertToYearDay()
          : e.date == dateTime.convertToYearDay())
      .toList();
}
