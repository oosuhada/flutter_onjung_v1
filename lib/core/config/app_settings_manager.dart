// app_settings_manager.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 앱 전체 설정을 위한 Provider
final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});

// 앱 설정 상태 클래스
class AppSettings {
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final String? authToken;
  final bool isLoggedIn;
  final bool hasUserSetTheme; // 사용자가 테마를 직접 설정했는지 여부

  AppSettings({
    required this.themeMode,
    required this.notificationsEnabled,
    this.authToken,
    required this.isLoggedIn,
    required this.hasUserSetTheme,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    String? authToken,
    bool? isLoggedIn,
    bool? hasUserSetTheme,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      authToken: authToken ?? this.authToken,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      hasUserSetTheme: hasUserSetTheme ?? this.hasUserSetTheme,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier()
      : super(AppSettings(
          themeMode: ThemeMode.system,
          notificationsEnabled: true,
          authToken: null,
          isLoggedIn: false,
          hasUserSetTheme: false,
        )) {
    _initializeSettings();
  }

  static const String _themeModeKey = 'theme_mode';
  static const String _hasUserSetThemeKey = 'has_user_set_theme';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _authTokenKey = 'auth_token';

  Future<void> _initializeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Verify SharedPreferences is working by attempting a simple operation
      await prefs.reload();
      final hasUserSetTheme = prefs.getBool(_hasUserSetThemeKey) ?? false;
      final themeModeString = prefs.getString(_themeModeKey);
      final notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
      final authToken = prefs.getString(_authTokenKey);

      // 사용자가 테마를 설정한 적이 있는 경우에만 저장된 테마 사용
      final ThemeMode themeMode = hasUserSetTheme && themeModeString != null
          ? _stringToThemeMode(themeModeString)
          : ThemeMode.system;

      state = AppSettings(
        themeMode: themeMode,
        notificationsEnabled: notificationsEnabled,
        authToken: authToken,
        isLoggedIn: authToken != null,
        hasUserSetTheme: hasUserSetTheme,
      );
    } catch (e) {
      debugPrint('설정 초기화 중 오류 발생: $e');
      state = AppSettings(
        themeMode: ThemeMode.system,
        notificationsEnabled: true,
        authToken: null,
        isLoggedIn: false,
        hasUserSetTheme: false,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      // Update state first for immediate UI response
      state = state.copyWith(
        themeMode: mode,
        hasUserSetTheme: true,
      );

      // Then persist the change
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload(); // Ensure connection is valid

      await Future.wait([
        prefs.setString(_themeModeKey, mode.toString().split('.').last),
        prefs.setBool(_hasUserSetThemeKey, true),
      ]);

      debugPrint(
          '테마 모드가 ${mode == ThemeMode.dark ? '다크 모드' : '라이트 모드'}로 성공적으로 저장되었습니다.');
    } catch (e) {
      debugPrint('테마 모드 설정 중 오류 발생: $e');
      // State is already updated, so UI will reflect the change even if persistence fails
    }
  }

  ThemeMode _stringToThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setNotificationsEnabled(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsKey, value);

      state = state.copyWith(notificationsEnabled: value);
    } catch (e) {
      debugPrint('알림 설정 중 오류 발생: $e');
    }
  }

  // 로그인 처리
  Future<void> login(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_authTokenKey, token);

      state = state.copyWith(
        authToken: token,
        isLoggedIn: true,
      );
    } catch (e) {
      debugPrint('로그인 처리 중 오류 발생: $e');
    }
  }

  // 로그아웃 처리
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authTokenKey);

      state = state.copyWith(
        authToken: null,
        isLoggedIn: false,
      );
    } catch (e) {
      debugPrint('로그아웃 처리 중 오류 발생: $e');
    }
  }
}
