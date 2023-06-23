import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
import 'package:reminder/bloc/events_v1/events_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/data/local_storage/local_storage_service.dart';
import 'package:reminder/data/repo/repository.dart';
import 'package:reminder/ui/screens/main_screen.dart';

class BlocsProviderWidget extends StatelessWidget {
  const BlocsProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<Repository>();
    final localStorageService = context.read<LocalStorageService>();
    return MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (_) => ThemeCubit(localStorageService: localStorageService)
              ..setPreviousTheme(),
          ),
          BlocProvider<CalendarBloc>(
            create: (_) => CalendarBloc(repository),
          )
        ],
        child: BlocProvider<EventsBloc>(
          create: (buildContext) => EventsBloc(repository)
            ..add(GetAllEvents(onCompleted: () {
              BlocProvider.of<CalendarBloc>(buildContext).add(OnUpdate());
            })),
          child: const MainScreen(),
        ));
  }
}
