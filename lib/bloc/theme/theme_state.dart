part of 'theme_cubit.dart';

extension ThemeCheck on ThemeState {
  bool isDarkTheme () => this == ThemeState.dark;
}

enum ThemeState { dark, light }
