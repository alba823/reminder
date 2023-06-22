import 'package:bloc/bloc.dart';
import 'package:reminder/data/models/event.dart';
import 'package:reminder/utils/extensions/date_time_extensions.dart';
import 'package:reminder/utils/services/notification_service.dart';

part 'add_event_event.dart';

part 'add_event_state.dart';

class AddEventBloc extends Bloc<AddEventEvent, AddEventState> {
  AddEventBloc(this.notificationService, {Event? event})
      : super(AddEventState(event: event)) {
    on<DateChangedEvent>(_onDateChanged);
    on<TimeChangedEvent>(_onTimeChanged);
    on<NameChangedEvent>(_onNameChangedEvent);
    on<ShouldShowNotificationChangedEvent>(
        _onShouldShowNotificationChangedEvent);
    on<SaveEvent>(_onSaveEvent);
  }

  final NotificationService notificationService;

  void _onDateChanged(DateChangedEvent event, Emitter<AddEventState> emitter) {
    final updatedTime = getCombinedDate(
        dateWithYear: event.dateTime, dateWithTime: state.dateTime);
    emitter(
        state.copyWith(event: state.event.copyWith(timeStamp: updatedTime)));
  }

  void _onTimeChanged(TimeChangedEvent event, Emitter<AddEventState> emitter) {
    final updatedTime = getCombinedDate(
        dateWithYear: state.dateTime, dateWithTime: event.dateTime);
    emitter(
        state.copyWith(event: state.event.copyWith(timeStamp: updatedTime)));
  }

  void _onNameChangedEvent(
      NameChangedEvent event, Emitter<AddEventState> emitter) {
    emitter(state.copyWith(event: state.event.copyWith(name: event.name)));
  }

  void _onSaveEvent(_, Emitter<AddEventState> emitter) async {
    if (state.name.isEmpty) {
      emitter(AddEventState(
          event: state.event, validationState: ValidationState.empty));
    } else {
      await _setNotificationIfNeeded();
      emitter(state.copyWith(
          event: state.event.copyWith(
              timeStamp: state.event.timeStamp,
              date: state.event.timeStamp.toYearDay()),
          validationState: ValidationState.success));
    }
  }

  Future<void> _setNotificationIfNeeded() async {
    if (state.shouldSetNotification) {
      final event = state.event;
      await notificationService.scheduleNotification(
          notificationId: event.notificationId,
          text: event.name,
          dateTime: event.timeStamp);
    }
  }

  void _onShouldShowNotificationChangedEvent(
      ShouldShowNotificationChangedEvent event,
      Emitter<AddEventState> emitter) {
    emitter(state.copyWith(event: state.event, shouldSetNotification: event.newValue));
  }
}
