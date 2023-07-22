import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/bloc/calendar/calendar_bloc.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/data/local_storage/local_storage_service.dart';
import 'package:reminder/data/repository/repository.dart';
import 'package:reminder/ui/screens/main_screen.dart';

class BlocsProviderWidget extends StatelessWidget {
  const BlocsProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<Repository>();
    final localStorageService = context.read<LocalStorageService>();
    return BlocProvider<ThemeCubit>(
      create: (_) => ThemeCubit(localStorageService: localStorageService)
        ..setPreviousTheme(),
      child: BlocProvider<CalendarBloc>(
        create: (buildContext) => CalendarBloc(repository)..add(GetAllEvents()),
        child: const MainScreen(),
      ),
    );
  }
}
