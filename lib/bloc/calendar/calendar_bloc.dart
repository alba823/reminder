import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:reminder/data/models/event.dart';
import 'package:reminder/data/repository/repository.dart';
import 'package:reminder/utils/extensions/date_time_extensions.dart';

part 'calendar_event.dart';

part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(this._repository) : super(EventsEmpty(DateTime.now())) {
    on<AddEvent>(_onAddEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<GetAllEvents>(_onGetAllEvents);
    on<GetEventsForDate>(_onGetEventsForDate);
    on<CheckEvent>(_onCheckEvent);
  }

  final Repository _repository;

  Future<void> _onAddEvent(AddEvent event, Emitter<CalendarState> emitter) async {
    await _repository.addEvent(event: event.event);
    _updateState(emitter, event, allEvents: await _repository.getAllEvents());
  }

  Future<void> _onDeleteEvent(DeleteEvent event,
      Emitter<CalendarState> emitter) async {
    await _repository.deleteEvent(event: event.event);
    _updateState(emitter, event, allEvents: await _repository.getAllEvents());
  }

  Future<void> _onGetAllEvents(GetAllEvents event,
      Emitter<CalendarState> emitter) async {
    _updateState(emitter, event, allEvents: await _repository.getAllEvents());
  }

  Future<void> _onGetEventsForDate(GetEventsForDate event,
      Emitter<CalendarState> emitter) async {
    _updateState(emitter, event, currentDateTime: event.dateTime);
  }

  Future<void> _onCheckEvent(CheckEvent event,
      Emitter<CalendarState> emitter) async {
    await _repository.updateEvent(event: event.event.copyWith(isChecked: !event.event.isChecked));
    _updateState(emitter, event, allEvents: await _repository.getAllEvents());
  }

  void _updateState(Emitter<CalendarState> emitter, CalendarEvent blocEvent,
      {List<Event>? allEvents, DateTime? currentDateTime}) async {
    if (allEvents?.isEmpty == true) {
      emitter(EventsEmpty(currentDateTime ?? state.currentDateTime));
    } else {
      emitter(EventsLoaded(allEvents ?? state.events, currentDateTime ?? state.currentDateTime));
    }
  }
}
