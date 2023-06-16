import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:reminder/data/models/event.dart';
import 'package:reminder/data/repo/repository.dart';
import 'package:reminder/utils/date_time_extensions.dart';

part 'calendar_event.dart';

part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(this.repository) : super(CalendarInitial()) {
    on<OnDayClicked>(_onDaySelected);
    on<OnDayLongClicked>(_onDayLongClick);
    on<OnUpdate>(_onUpdate);
  }

  final Repository repository;

  void _onDaySelected(OnDayClicked event, Emitter<CalendarState> emitter) {
    emitter(CalendarDaySelected(event.selectedDay));
  }

  void _onDayLongClick(
      OnDayLongClicked event, Emitter<CalendarState> emitter) async {
    await repository.addEvent(
        event: Event.optional(
            name: "Added Event: ${event.selectedDay.convertToYearDay()}",
            timeStamp: event.selectedDay));
    _onUpdate(null, emitter, selectedDay: event.selectedDay);
    event.onDayAdded();
  }

  void _onUpdate(_, Emitter<CalendarState> emitter, {DateTime? selectedDay}) {
    emitter(CalendarDaySelected(selectedDay ?? state.selectedDay));
  }
}
