import 'package:localstorage/localstorage.dart';

abstract class LocalStorageService {
  bool isDarkTheme();

  Future<void> changeTheme();

  Future<bool> prepare();
}

class LocalStorageServiceImpl implements LocalStorageService {
  static const isDarkThemeStorageKey = "isDarkTheme";
  static const _localStorageKey = "localStorageKey";

  LocalStorageServiceImpl({LocalStorage? localStorage})
      : _localStorage = localStorage ?? LocalStorage(_localStorageKey);

  final LocalStorage _localStorage;

  @override
  Future<bool> prepare() async {
    return _localStorage.ready;
  }

  @override
  Future<void> changeTheme() async {
    final isCurrentThemeDark = isDarkTheme();
    await _localStorage.setItem(isDarkThemeStorageKey, !isCurrentThemeDark);
  }

  @override
  bool isDarkTheme() {
    return _localStorage.getItem(isDarkThemeStorageKey) ?? true;
  }
}
