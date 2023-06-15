import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/data/repo/repository.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required this.repository}) : super(ThemeState.dark);

  final Repository repository;

  bool isDarkTheme() => state.isDarkTheme();

  void setPreviousTheme() async {
    await repository.prepare();
    final isLastThemeDark = repository.isDarkTheme();
    emit(isLastThemeDark ? ThemeState.dark : ThemeState.light);
  }

  void switchTheme() async {
    emit(state.isDarkTheme() ? ThemeState.light : ThemeState.dark);
    await repository.changeTheme();
  }
}

extension Theme on ThemeData {
  bool isDarkTheme () => this == ThemeData.dark();
}