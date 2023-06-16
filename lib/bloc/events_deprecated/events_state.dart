part of 'events_cubit.dart';

sealed class EventsState {
  abstract final List<Event> events;
  abstract final List<Event> eventsForSelectedDay;
}

class EventsEmpty extends EventsState {
  @override
  final List<Event> eventsForSelectedDay = List.empty();
  @override
  final List<Event> events = List.empty();
}
class EventsLoaded extends EventsState {
  @override
  final List<Event> eventsForSelectedDay;

  @override
  final List<Event> events;

  EventsLoaded(this.eventsForSelectedDay, this.events);
}
