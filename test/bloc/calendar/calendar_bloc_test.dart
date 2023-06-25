import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
import 'package:reminder/data/models/event.dart';
import 'package:reminder/data/repository/repository.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateNiceMocks([MockSpec<Repository>()])
import 'calendar_bloc_test.mocks.dart';

void main() {
  late Repository mockRepository;

  final dummyEvents =
      List.generate(5, (index) => Event.optional(id: index, name: "$index"));
  final dummyEvent = Event.optional(name: "dummy");
  final dummyCurrentDateTime = DateTime.now().add(const Duration(days: 2, hours: 4));

  setUp(() {
    mockRepository = MockRepository();
  });

  blocTest<CalendarBloc, CalendarState>(
    'GetAllEvents event should get events from repository and set EventsLoaded state',
    build: () => CalendarBloc(mockRepository),
    act: (CalendarBloc bloc) {
      when(mockRepository.getAllEvents())
          .thenAnswer((realInvocation) => Future(() => dummyEvents));
      bloc.add(GetAllEvents());
    },
    expect: () => [isA<EventsLoaded>()],
  );

  blocTest<CalendarBloc, CalendarState>(
    'GetAllEvents event should get events from repository and set EventsEmpty state',
    build: () => CalendarBloc(mockRepository),
    act: (CalendarBloc bloc) {
      when(mockRepository.getAllEvents())
          .thenAnswer((realInvocation) => Future(() => List.empty()));
      bloc.add(GetAllEvents());
    },
    expect: () => [isA<EventsEmpty>()],
  );

  blocTest<CalendarBloc, CalendarState>(
      'AddEvent should call repository addEvent and then re-fetch events',
      build: () => CalendarBloc(mockRepository),
      act: (CalendarBloc bloc) {
        when(mockRepository.getAllEvents())
            .thenAnswer((realInvocation) => Future(() => List.empty()));
        when(mockRepository.addEvent(event: dummyEvent))
            .thenAnswer((realInvocation) => Future(() => {}));
        bloc.add(AddEvent(dummyEvent));
      },
      wait: const Duration(microseconds: 1),
      expect: () => [isA<EventsEmpty>()],
      verify: (_) {
        verify(mockRepository.addEvent(event: dummyEvent)).called(1);
        verify(mockRepository.getAllEvents()).called(1);
      });

  blocTest<CalendarBloc, CalendarState>(
      'DeleteEvent should call repository addEvent and then re-fetch events',
      build: () => CalendarBloc(mockRepository),
      act: (CalendarBloc bloc) {
        when(mockRepository.getAllEvents())
            .thenAnswer((realInvocation) => Future(() => List.empty()));
        when(mockRepository.deleteEvent(event: dummyEvent))
            .thenAnswer((realInvocation) => Future(() => {}));
        bloc.add(DeleteEvent(dummyEvent));
      },
      wait: const Duration(microseconds: 1),
      expect: () => [isA<EventsEmpty>()],
      verify: (_) {
        verify(mockRepository.deleteEvent(event: dummyEvent)).called(1);
        verify(mockRepository.getAllEvents()).called(1);
      });

  // FIXME
  // blocTest<CalendarBloc, CalendarState>(
  //     'CheckEvent should call repository updateEvent and then re-fetch events',
  //     build: () => CalendarBloc(mockRepository),
  //     act: (CalendarBloc bloc) {
  //       when(mockRepository.getAllEvents())
  //           .thenAnswer((realInvocation) => Future(() => List.empty()));
  //       bloc.add(CheckEvent(dummyEvent));
  //     },
  //     wait: const Duration(microseconds: 1),
  //     // expect: () => [isA<EventsEmpty>()],
  //     verify: (_) {
  //       verify(mockRepository.updateEvent(event: any)).called(1);
  //       verify(mockRepository.getAllEvents()).called(1);
  //     });

  blocTest<CalendarBloc, CalendarState>(
      'GetEventsForDate should update currentDateTime',
      build: () => CalendarBloc(mockRepository),
      act: (CalendarBloc bloc) {
        bloc.add(GetEventsForDate(dummyCurrentDateTime));
      },
      wait: const Duration(microseconds: 1),
      verify: (bloc) {
        expect(bloc.state.currentDateTime, equals(dummyCurrentDateTime));
      });
}
