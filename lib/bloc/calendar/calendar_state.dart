part of 'calendar_bloc.dart';

class CalendarState {
  final List<Event> events;
  final DateTime currentDateTime;

  final NotificationPermissionState permissionState;

  CalendarState(
      {List<Event>? events,
      DateTime? currentDateTime,
      NotificationPermissionState? permissionState})
      : events = events ?? List.empty(),
        currentDateTime = currentDateTime ?? DateTime.now(),
        permissionState = permissionState ?? NotificationPermissionState.idle;

  CalendarState copyWith(
          {List<Event>? events,
          DateTime? currentDateTime,
          NotificationPermissionState? permissionState}) =>
      CalendarState(
          events: events ?? this.events,
          currentDateTime: currentDateTime ?? this.currentDateTime,
          permissionState: permissionState ?? this.permissionState);

  List<Event> getEventsForDate({DateTime? dateTime}) => events
      .where((e) => dateTime == null
          ? e.date == currentDateTime.toYearDay()
          : e.date == dateTime.toYearDay())
      .toList();
}
