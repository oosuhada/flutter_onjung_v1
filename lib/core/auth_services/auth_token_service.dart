import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenService {
  static const String _lastLoginTimeKey = 'last_login_time';
  static const String _authTokenKey = 'auth_token';
  static const Duration _autoLoginDuration = Duration(days: 14);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 로그인 시 호출
  Future<void> saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      // 현재 시간 저장
      await prefs.setString(
          _lastLoginTimeKey, DateTime.now().toIso8601String());

      // ID 토큰 저장
      final idToken = await currentUser.getIdToken();
      await prefs.setString(_authTokenKey, idToken!);
    }
  }

  // 앱 시작시 자동 로그인 체크
  Future<bool> checkAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastLoginTimeStr = prefs.getString(_lastLoginTimeKey);

      if (lastLoginTimeStr == null) return false;

      final lastLoginTime = DateTime.parse(lastLoginTimeStr);
      final now = DateTime.now();
      final difference = now.difference(lastLoginTime);

      // 현재 사용자가 있고 로그인한지 2주 이내인 경우
      if (_auth.currentUser != null && difference <= _autoLoginDuration) {
        // 토큰 리프레시
        await _auth.currentUser?.getIdToken(true);
        return true;
      }

      // 2주가 지났거나 사용자가 없는 경우
      await clearLoginState();
      return false;
    } catch (e) {
      print('자동 로그인 체크 실패: $e');
      return false;
    }
  }

  // 로그아웃 시 호출
  Future<void> clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastLoginTimeKey);
    await prefs.remove(_authTokenKey);
    await _auth.signOut();
  }
}

// Provider 설정
final authTokenProvider = Provider<AuthTokenService>((ref) {
  return AuthTokenService();
});
