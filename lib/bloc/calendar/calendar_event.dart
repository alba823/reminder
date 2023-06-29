part of 'calendar_bloc.dart';

abstract class CalendarEvent {}

class AddEvent extends CalendarEvent {
  final Event event;

  AddEvent(this.event);
}

class DeleteEvent extends CalendarEvent {
  final Event event;

  DeleteEvent(this.event);
}

class GetAllEvents extends CalendarEvent {
  GetAllEvents();
}

class GetEventsForDate extends CalendarEvent {
  final DateTime dateTime;

  GetEventsForDate(this.dateTime);
}

class CheckEvent extends CalendarEvent {
  final Event event;

  CheckEvent(this.event);
}

class CheckPermissions extends CalendarEvent {}