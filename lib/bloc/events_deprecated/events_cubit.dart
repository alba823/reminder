import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/data/database/event.dart';
import 'package:reminder/data/repo/repository.dart';
import 'package:reminder/utils/date_time_extensions.dart';

part 'events_state.dart';

class EventsBlock extends Cubit<EventsState> {
  EventsBlock(this.repository) : super(EventsEmpty());

  final Repository repository;

  List<Event> eventForDay() => state.eventsForSelectedDay;
  List<Event> allEvents(DateTime date) => state.events.where((e) => e.date == date.convertToYearDay()).toList();

  // Stream<List<Event>> eventsStream() => state.eventsStream;

  void getEvents() async {
      final eventsForToday =
          await repository.getEventsByDateTime(dateTime: DateTime.now());
      final events = await repository.getAllEvents();

      emit(EventsLoaded(events, eventsForToday));
  }

  void getEventsForDateTime(DateTime dateTime) async {
    final a = await repository.getEventsByDateTime(dateTime: dateTime);
    final b = await repository.getAllEvents();
    print(a);
    // emit(EventsLoaded(state.eventsStream, a, state.events));
  }

  // List<Event> test() {
  //   state.eventsForSelectedDayStream
  // }

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