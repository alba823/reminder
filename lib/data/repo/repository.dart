import 'package:reminder/data/models/event.dart';
import 'package:reminder/data/models/event_dao.dart';
import 'package:reminder/utils/date_time_extensions.dart';

abstract class Repository {
  Future<List<Event>> getAllEvents();

  Future<List<Event>> getEventsByDateTime({required DateTime dateTime});

  Future<void> saveEvents({required List<Event> events});

  Future<void> addEvent({required Event event});

  Future<void> updateEvent({required Event event});

  Future<void> deleteEvents({required List<Event> events});

  Future<void> deleteEvent({required Event event});
}

final class RepositoryImpl implements Repository {
  RepositoryImpl(this.eventDao);

  final EventDao eventDao;

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
