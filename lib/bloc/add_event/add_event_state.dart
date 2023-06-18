part of 'add_event_bloc.dart';

enum ValidationState { success, idle, empty }

final class AddEventState {
  final Event event;
  final ValidationState validationState;

  DateTime get dateTime => event.timeStamp;

  String get name => event.name;

  AddEventState({Event? event, ValidationState? validationState})
      : event = event ?? Event.optional(name: ""),
        validationState = validationState ?? ValidationState.idle;
}
