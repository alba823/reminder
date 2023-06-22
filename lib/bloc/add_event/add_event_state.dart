part of 'add_event_bloc.dart';

enum ValidationState { success, idle, empty }

final class AddEventState {
  final Event event;
  final ValidationState validationState;
  final bool shouldSetNotification;

  DateTime get dateTime => event.timeStamp;

  String get name => event.name;

  AddEventState(
      {Event? event,
      ValidationState? validationState,
      bool? shouldSetNotification})
      : event = event ?? Event.optional(name: ""),
        validationState = validationState ?? ValidationState.idle,
        shouldSetNotification = shouldSetNotification ?? false;

  AddEventState copyWith(
          {Event? event,
          ValidationState? validationState,
          bool? shouldSetNotification}) =>
      AddEventState(
          event: event ?? this.event,
          validationState: validationState ?? this.validationState,
          shouldSetNotification: shouldSetNotification ?? this.shouldSetNotification);
}
