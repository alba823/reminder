import 'package:floor/floor.dart';
import 'package:reminder/data/models/event.dart';

@dao
abstract class EventDao {
  @Query("SELECT * FROM events")
  Stream<List<Event>> getAllEventsStream();

  @Query("SELECT * FROM events")
  Future<List<Event>> getAllEvents();

  @Query("SELECT * FROM events WHERE date == :dateTime")
  Future<List<Event>> getEventsByDateTime(String dateTime);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateEvent(Event event);

  @delete
  Future<void> deleteEvent(Event event);

  @delete
  Future<void> deleteEvents(List<Event> events);

  @insert
  Future<void> insertEvent(Event event);

  @insert
  Future<void> insertEvents(List<Event> events);
}