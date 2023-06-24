import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reminder/data/models/event.dart';
import 'package:reminder/data/models/event_dao.dart';
import 'package:reminder/data/repository/repository.dart';
import 'package:reminder/utils/extensions/date_time_extensions.dart';

@GenerateNiceMocks([MockSpec<EventDao>()])
import 'repository_test.mocks.dart';

void main() {
  late EventDao mockEventDao;
  late Repository repository;

  final dummyEvents =
      List.generate(3, (index) => Event.optional(id: index, name: "$index"));

  setUp(() {
    mockEventDao = MockEventDao();
    repository = RepositoryImpl(mockEventDao);
  });

  test("saveEvents should use EventDao to insert events", () async {
    await repository.saveEvents(events: dummyEvents);
    verify(mockEventDao.insertEvents(dummyEvents));
  });

  test("updateEvent should use EventDao to update event", () async {
    await repository.updateEvent(event: dummyEvents.first);
    verify(mockEventDao.updateEvent(dummyEvents.first));
  });

  test("deleteEvents should use EventDao to delete events", () async {
    await repository.deleteEvents(events: dummyEvents);
    verify(mockEventDao.deleteEvents(dummyEvents));
  });

  test("deleteEvent should use EventDao to delete event", () async {
    await repository.deleteEvent(event: dummyEvents.first);
    verify(mockEventDao.deleteEvent(dummyEvents.first));
  });

  test("getEventsByDateTime should use EventDao to get event by DateTime",
      () async {
    final dateTime = DateTime.now();
    when(mockEventDao.getEventsByDateTime(dateTime.toYearDay()))
        .thenAnswer((realInvocation) => Future(() => dummyEvents));
    final result = await repository.getEventsByDateTime(dateTime: dateTime);
    verify(mockEventDao.getEventsByDateTime(dateTime.toYearDay()));
    expect(result, equals(dummyEvents));
  });

  test("getAllEvents should use EventDao to get all events", () async {
    when(mockEventDao.getAllEvents())
        .thenAnswer((realInvocation) => Future(() => dummyEvents));
    final result = await repository.getAllEvents();
    verify(mockEventDao.getAllEvents());
    expect(result, equals(dummyEvents));
  });

  test("addEvent should use EventDao to insert event", () async {
    await repository.addEvent(event: dummyEvents.first);
    verify(mockEventDao.insertEvent(dummyEvents.first));
  });
}
