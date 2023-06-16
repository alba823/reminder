import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:reminder/data/models/event.dart';
import 'package:reminder/data/repo/repository.dart';
import 'package:reminder/utils/date_time_extensions.dart';

part 'events_event.dart';

part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc(this.repository) : super(EventsEmpty(DateTime.now())) {
    on<AddEvent>(_onAddEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<GetAllEvents>(_onGetAllEvents);
    on<GetEventsForDate>(_onGetEventsForDate);
    on<CheckEvent>(_onCheckEvent);
  }

  final Repository repository;

  Future<void> _onAddEvent(AddEvent event, Emitter<EventsState> emitter) async {
    await repository.addEvent(event: event.event);
    _updateState(emitter, event, allEvents: await repository.getAllEvents());
  }

  Future<void> _onDeleteEvent(DeleteEvent event,
      Emitter<EventsState> emitter) async {
    await repository.deleteEvent(event: event.event);
    _updateState(emitter, event, allEvents: await repository.getAllEvents());
  }

  Future<void> _onGetAllEvents(GetAllEvents event,
      Emitter<EventsState> emitter) async {
    _updateState(emitter, event, allEvents: await repository.getAllEvents());
  }

  Future<void> _onGetEventsForDate(GetEventsForDate event,
      Emitter<EventsState> emitter) async {
    _updateState(emitter, event, currentDateTime: event.dateTime);
  }

  Future<void> _onCheckEvent(CheckEvent event,
      Emitter<EventsState> emitter) async {
    await repository.updateEvent(event: event.event.copyWith(isChecked: !event.event.isChecked));
    _updateState(emitter, event, allEvents: await repository.getAllEvents());
  }

  void _updateState(Emitter<EventsState> emitter, EventsEvent blocEvent,
      {List<Event>? allEvents, DateTime? currentDateTime}) async {
    if (allEvents?.isEmpty == true) {
      emitter(EventsEmpty(currentDateTime ?? state.currentDateTime));
    } else {
      emitter(EventsLoaded(allEvents ?? state.events, currentDateTime ?? state.currentDateTime));
    }
    blocEvent.onCompleted?.call();
  }
}
