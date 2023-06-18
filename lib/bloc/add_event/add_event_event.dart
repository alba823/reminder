part of 'add_event_bloc.dart';

abstract class AddEventEvent {}

final class DateChangedEvent extends AddEventEvent {
  final DateTime dateTime;

  DateChangedEvent(this.dateTime);
}

final class TimeChangedEvent extends AddEventEvent {
  final DateTime dateTime;

  TimeChangedEvent(this.dateTime);
}

final class NameChangedEvent extends AddEventEvent {
  final String name;

  NameChangedEvent(this.name);
}

final class SaveEvent extends AddEventEvent {}