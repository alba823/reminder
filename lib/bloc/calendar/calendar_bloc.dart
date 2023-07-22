import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reminder/data/models/event.dart';
import 'package:reminder/data/repository/repository.dart';
import 'package:reminder/utils/extensions/date_time_extensions.dart';
import 'package:reminder/utils/services/notification_service.dart';

part 'calendar_event.dart';

part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(
    this._repository, {
    NotificationService? notificationService,
  })  : _notificationService = notificationService ?? NotificationService(),
        super(CalendarState()) {
    on<AddEvent>(_onAddEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<GetAllEvents>(_onGetAllEvents);
    on<GetEventsForDate>(_onGetEventsForDate);
    on<CheckEvent>(_onCheckEvent);
    on<CheckPermissions>(_onCheckPermissions);
  }

  final Repository _repository;
  final NotificationService _notificationService;

  Future<void> _onAddEvent(
    AddEvent event,
    Emitter<CalendarState> emitter,
  ) async {
    await _repository.addEvent(event: event.event);
    _updateState(emitter, event, allEvents: await _repository.getAllEvents());
  }

  Future<void> _onDeleteEvent(
    DeleteEvent event,
    Emitter<CalendarState> emitter,
  ) async {
    await _repository.deleteEvent(event: event.event);
    _updateState(emitter, event, allEvents: await _repository.getAllEvents());
    if (!event.event.shouldShowNotification) return;
    await _notificationService.removeNotification(
        notificationId: event.event.notificationId);
  }

  Future<void> _onGetAllEvents(
    GetAllEvents event,
    Emitter<CalendarState> emitter,
  ) async {
    _updateState(emitter, event, allEvents: await _repository.getAllEvents());
  }

  Future<void> _onGetEventsForDate(
    GetEventsForDate event,
    Emitter<CalendarState> emitter,
  ) async {
    _updateState(emitter, event, currentDateTime: event.dateTime);
  }

  Future<void> _onCheckEvent(
    CheckEvent event,
    Emitter<CalendarState> emitter,
  ) async {
    await _repository.updateEvent(
      event: event.event.copyWith(isChecked: !event.event.isChecked),
    );
    _updateState(
      emitter,
      event,
      allEvents: await _repository.getAllEvents(),
    );
  }

  Future<void> _onCheckPermissions(
    _,
    Emitter<CalendarState> emitter,
  ) async {
    emitter(
      state.copyWith(
        permissionState: await _notificationService.getUpdatedPermissionState(),
      ),
    );
  }

  void _updateState(
    Emitter<CalendarState> emitter,
    CalendarEvent blocEvent, {
    List<Event>? allEvents,
    DateTime? currentDateTime,
  }) async {
    emitter(
      CalendarState(
        events: allEvents ?? state.events,
        currentDateTime: currentDateTime ?? state.currentDateTime,
      ),
    );
  }
}
