import 'package:localstorage/localstorage.dart';
import 'package:reminder/data/database/database.dart';
import 'package:reminder/data/database/event.dart';
import 'package:reminder/data/database/event_dao.dart';

abstract class Repository {
  bool isDarkTheme();

  Future<void> changeTheme();

  Future<void> prepare();

  Stream<List<Event>> getEvents();

  Future<void> saveEvents({required List<Event> events});

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
  Stream<List<Event>> getEvents() {
    return eventDao.getEvents();
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


}

const isDarkThemeStorageKey = "isDarkTheme";
const localStorageKey = "localStorageKey";
const eventsKey = "eventsKey";
