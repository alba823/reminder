import 'package:localstorage/localstorage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reminder/data/local_storage/local_storage_service.dart';

@GenerateNiceMocks([MockSpec<LocalStorage>()])
import 'local_storage_service_test.mocks.dart';

void main() {
  late MockLocalStorage mockLocalStorage;
  late LocalStorageService localStorageService;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    localStorageService =
        LocalStorageServiceImpl(localStorage: mockLocalStorage);
  });

  test("prepare should await till local storage is ready", () async {
    when(mockLocalStorage.ready)
        .thenAnswer((realInvocation) => Future(() => true));
    final result = await localStorageService.prepare();
    expect(result, equals(true));
  });

  test("isDarkTheme should read flag from local storage", () {
    const expectedResult = true;
    when(mockLocalStorage
            .getItem(LocalStorageServiceImpl.isDarkThemeStorageKey))
        .thenReturn(expectedResult);
    final actualResult = localStorageService.isDarkTheme();
    expect(expectedResult, equals(actualResult));
  });

  test("changeTheme should get saved flag and then change it to the opposite",
      () async {
    const currentValue = true;
    when(mockLocalStorage
            .getItem(LocalStorageServiceImpl.isDarkThemeStorageKey))
        .thenReturn(currentValue);
    await localStorageService.changeTheme();
    verify(mockLocalStorage.setItem(
        LocalStorageServiceImpl.isDarkThemeStorageKey, !currentValue));
  });
}
