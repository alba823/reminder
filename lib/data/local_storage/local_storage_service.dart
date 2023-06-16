import 'package:localstorage/localstorage.dart';

abstract class LocalStorageService {
  bool isDarkTheme();

  Future<void> changeTheme();

  Future<void> prepare();
}

class LocalStorageServiceImpl implements LocalStorageService {
  static const _isDarkThemeStorageKey = "isDarkTheme";
  static const _localStorageKey = "localStorageKey";

  LocalStorageServiceImpl({LocalStorage? localStorage})
      : _localStorage = localStorage ?? LocalStorage(_localStorageKey);

  final LocalStorage _localStorage;

  @override
  Future<void> prepare() async {
    await _localStorage.ready;
  }

  @override
  Future<void> changeTheme() async {
    final isCurrentThemeDark = isDarkTheme();
    await _localStorage.setItem(_isDarkThemeStorageKey, !isCurrentThemeDark);
  }

  @override
  bool isDarkTheme() {
    return _localStorage.getItem(_isDarkThemeStorageKey) ?? true;
  }
}
