import 'package:floor/floor.dart';
import 'package:reminder/data/database/event.dart';

@dao
abstract class EventDao {
  @Query("SELECT * FROM events")
  Stream<List<Event>> getEvents();

  @Query("SELECT * FROM events WHERE dateTime == :dateTime")
  Future<List<Event>?> getEventsByDateTime(DateTime dateTime);

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