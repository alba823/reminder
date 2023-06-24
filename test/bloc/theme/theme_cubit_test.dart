import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reminder/bloc/theme/theme_cubit.dart';
import 'package:reminder/data/local_storage/local_storage_service.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateNiceMocks([MockSpec<LocalStorageService>()])
import 'theme_cubit_test.mocks.dart';

void main() {
  late LocalStorageService mockLocalStorageService;

  setUp(() {
    mockLocalStorageService = MockLocalStorageService();
  });

  blocTest<ThemeCubit, ThemeState>(
    'switchTheme test',
    build: () => ThemeCubit(localStorageService: mockLocalStorageService),
    act: (ThemeCubit bloc) {
      bloc.switchTheme();
    },
    expect: () => <ThemeState>[
      ThemeState.light
    ],
  );

  blocTest<ThemeCubit, ThemeState>(
    'setPreviousTheme should change theme to light',
    build: () => ThemeCubit(localStorageService: mockLocalStorageService),
    act: (ThemeCubit bloc) {
      when(mockLocalStorageService.isDarkTheme()).thenReturn(false);
      bloc.setPreviousTheme();
    },
    expect: () => <ThemeState>[
      ThemeState.light
    ],
  );

  blocTest<ThemeCubit, ThemeState>(
    'setPreviousTheme should change theme to dark',
    build: () => ThemeCubit(localStorageService: mockLocalStorageService),
    act: (ThemeCubit bloc) {
      when(mockLocalStorageService.isDarkTheme()).thenReturn(true);
      bloc.setPreviousTheme();
    },
    expect: () => <ThemeState>[
      ThemeState.dark
    ],
  );
}