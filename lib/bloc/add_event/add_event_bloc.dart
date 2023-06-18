import 'package:bloc/bloc.dart';
import 'package:reminder/data/models/event.dart';
import 'package:reminder/utils/extensions/date_time_extensions.dart';

part 'add_event_event.dart';

part 'add_event_state.dart';

class AddEventBloc extends Bloc<AddEventEvent, AddEventState> {
  AddEventBloc({Event? event}) : super(AddEventState(event: event)) {
    on<DateChangedEvent>(_onDateChanged);
    on<TimeChangedEvent>(_onTimeChanged);
    on<NameChangedEvent>(_onNameChangedEvent);
    on<SaveEvent>(_onSaveEvent);
  }

  void _onDateChanged(DateChangedEvent event, Emitter<AddEventState> emitter) {
    final updatedTime = DateTime.parse(
        "${event.dateTime.monthDateYearString} ${state.dateTime.timeString}");
    emitter(AddEventState(event: state.event.copyWith(timeStamp: updatedTime)));
  }

  void _onTimeChanged(TimeChangedEvent event, Emitter<AddEventState> emitter) {
    final updatedTime = DateTime.parse(
        "${state.dateTime.monthDateYearString} ${event.dateTime.timeString}");
    emitter(AddEventState(event: state.event.copyWith(timeStamp: updatedTime)));
  }

  void _onNameChangedEvent(
      NameChangedEvent event, Emitter<AddEventState> emitter) {
    emitter(AddEventState(event: state.event.copyWith(name: event.name)));
  }

  void _onSaveEvent(_, Emitter<AddEventState> emitter) {
    if (state.name.isEmpty) {
      emitter(AddEventState(event: state.event, validationState: ValidationState.empty));
    } else {
      emitter(AddEventState(
          event: state.event.copyWith(timeStamp: state.event.timeStamp, date: state.event.timeStamp.toYearDay()),
          validationState: ValidationState.success)
      );
    }
  }
}
