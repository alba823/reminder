import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
import 'package:reminder/bloc/events/events_cubit.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/data/repo/repository.dart';
import 'package:reminder/ui/screens/main_screen.dart';

class BlocsProviderWidget extends StatelessWidget {
  const BlocsProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<Repository>();
    return MultiBlocProvider(providers: [
      BlocProvider<ThemeCubit>(
        create: (_) => ThemeCubit(repository: repository)..setPreviousTheme(),
      ),
      BlocProvider<EventsCubit>(
          create: (_) => EventsCubit(repository)..getEvents()
      ),
      BlocProvider<CalendarBloc>(
        create: (_) => CalendarBloc(),
      )
    ], child: const MainThemeScreen());
  }
}
