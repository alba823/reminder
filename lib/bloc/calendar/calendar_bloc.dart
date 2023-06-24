import 'package:bloc/bloc.dart';
import 'package:reminder/data/repository/repository.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(this.repository) : super(CalendarInitial()) {
    on<OnDayClicked>(_onDaySelected);
    on<OnUpdate>(_onUpdate);
  }

  final Repository repository;

  void _onDaySelected(OnDayClicked event, Emitter<CalendarState> emitter) {
    emitter(CalendarDaySelected(event.selectedDay));
  }

  void _onUpdate(_, Emitter<CalendarState> emitter, {DateTime? selectedDay}) {
    emitter(CalendarDaySelected(selectedDay ?? state.selectedDay));
  }
}