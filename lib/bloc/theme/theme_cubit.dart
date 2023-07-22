import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/data/local_storage/local_storage_service.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({
    required LocalStorageService localStorageService,
  })  : _localStorageService = localStorageService,
        super(ThemeState.dark);

  final LocalStorageService _localStorageService;

  bool isDarkTheme() => state.isDarkTheme();

  void setPreviousTheme() async {
    await _localStorageService.prepare();
    final isLastThemeDark = _localStorageService.isDarkTheme();
    emit(isLastThemeDark ? ThemeState.dark : ThemeState.light);
  }

  void switchTheme() async {
    emit(state.isDarkTheme() ? ThemeState.light : ThemeState.dark);
    await _localStorageService.changeTheme();
  }
}

extension Theme on ThemeData {
  bool isDarkTheme() => this == ThemeData.dark();
}
