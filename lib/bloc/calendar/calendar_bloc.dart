import 'dart:async';

import 'package:bloc/bloc.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
    on<OnDayClicked>((event, emit) {
      print("OnDayClicked: ${event.selectedDay}");
      emit(CalendarDaySelected(event.selectedDay));
    });
    on<OnDayLongClicked>((event, emit) => emit(CalendarInitial()));
  }
}
