import 'package:localstorage/localstorage.dart';
import 'package:reminder/data/database/event.dart';
import 'package:reminder/data/database/event_dao.dart';
import 'package:reminder/utils/date_time_extensions.dart';

abstract class Repository {
  bool isDarkTheme();

  Future<void> changeTheme();

  Future<void> prepare();

  Future<List<Event>> getAllEvents();

  Future<List<Event>> getEventsByDateTime({required DateTime dateTime});

  Future<void> saveEvents({required List<Event> events});

  Future<void> addEvent({required Event event});

  Future<void> updateEvent({required Event event});

  Future<void> deleteEvents({required List<Event> events});

  Future<void> deleteEvent({required Event event});
}

final class RepositoryImpl implements Repository {
  RepositoryImpl(this.eventDao, {LocalStorage? localStorage})
      : localStorage = localStorage ?? LocalStorage(localStorageKey);

  final LocalStorage localStorage;
  final EventDao eventDao;

  @override
  Future<void> prepare() async {
    await localStorage.ready;
  }

  @override
  Future<void> changeTheme() async {
    final isCurrentThemeDark = isDarkTheme();
    await localStorage.setItem(isDarkThemeStorageKey, !isCurrentThemeDark);
  }

  @override
  bool isDarkTheme() {
    return localStorage.getItem(isDarkThemeStorageKey) ?? true;
  }

  @override
  Stream<List<Event>> getAllEventsStream() {
    return eventDao.getAllEventsStream();
  }

  @override
  Future<void> saveEvents({required List<Event> events}) async {
    await eventDao.insertEvents(events);
  }

  @override
  Future<void> updateEvent({required Event event}) async {
    await eventDao.updateEvent(event);
  }

  @override
  Future<void> deleteEvents({required List<Event> events}) async {
    await eventDao.deleteEvents(events);
  }

  @override
  Future<void> deleteEvent({required Event event}) async {
    await eventDao.deleteEvent(event);
  }

  @override
  Future<List<Event>> getEventsByDateTime({required DateTime dateTime}) {
    return eventDao.getEventsByDateTime(dateTime.convertToYearDay());
  }

  @override
  Future<List<Event>> getAllEvents() {
    return eventDao.getAllEvents();
  }

  @override
  Future<void> addEvent({required Event event}) {
    return eventDao.insertEvent(event);
  }
}

const isDarkThemeStorageKey = "isDarkTheme";
const localStorageKey = "localStorageKey";
const eventsKey = "eventsKey";
