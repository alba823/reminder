part of 'events_cubit.dart';

sealed class EventsState {
  final Stream<List<Event>> eventsStream = const Stream.empty();
}

class EventsLoading extends EventsState {}
class EventsFailure extends EventsState {}
class EventsLoaded extends EventsState {
  @override
  final Stream<List<Event>> eventsStream;

  EventsLoaded(this.eventsStream);
}
