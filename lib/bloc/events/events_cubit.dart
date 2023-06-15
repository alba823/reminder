import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/data/database/event.dart';
import 'package:reminder/data/repo/repository.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  EventsCubit(this.repository) : super(EventsLoading());

  final Repository repository;

  // FIXME: use real stream
  Stream<List<Event>> eventForDayStream() => state.eventsStream;
  Stream<List<Event>> eventsStream() => state.eventsStream;

  void getEvents() {
    emit(EventsLoaded(repository.getEvents()));
  }

  void getEventsForDateTime(DateTime dateTime) {
    // TODO: return stream of day events
  }

  Future<void> checkEvent(Event e, bool isChecked) async {
    await repository.updateEvent(event: e.copyWith(isChecked: isChecked));
  }

  Future<void> deleteEvent({required Event event}) async {
    await repository.deleteEvent(event: event);
  }

  Future<void> saveTestEvents() async {
    await repository.saveEvents(events: [Event.optional(name: "test Event")]);
  }
}