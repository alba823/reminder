// ignore_for_file: prefer_function_declarations_over_variables

part of 'events_bloc.dart';

abstract class EventsEvent {
  abstract final VoidCallback? onCompleted;
}

class AddEvent extends EventsEvent {
  final Event event;
  @override
  final VoidCallback onCompleted;

  AddEvent(this.event, this.onCompleted);
}

class DeleteEvent extends EventsEvent {
  final Event event;
  @override
  final VoidCallback onCompleted;

  DeleteEvent(this.event, this.onCompleted);
}

class GetAllEvents extends EventsEvent {
  @override
  final VoidCallback? onCompleted;

  GetAllEvents({this.onCompleted});
}

class GetEventsForDate extends EventsEvent {
  final DateTime dateTime;

  @override
  VoidCallback get onCompleted => () {};

  GetEventsForDate(this.dateTime);
}

class CheckEvent extends EventsEvent {
  final Event event;
  final bool isChecked;
  @override
  final VoidCallback onCompleted;

  CheckEvent(this.event, this.isChecked, this.onCompleted);
}