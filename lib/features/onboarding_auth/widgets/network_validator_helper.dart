import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NetworkValidatorHelper {
  static final Map<String, DateTime> _rateLimiter = {};

  // 레이트 리미터 확인 메서드
  static Future<bool> checkRateLimit(String operation, Duration limit) async {
    final now = DateTime.now();
    final lastAttempt = _rateLimiter[operation];
    if (lastAttempt != null && now.difference(lastAttempt) < limit) {
      debugPrint('요청 제한 초과: $operation');
      return false;
    }
    _rateLimiter[operation] = now;
    return true;
  }

  // 비밀번호 검증 메서드
  static Future<String?> verifyPassword(
      String email, String password, String languageCode) async {
    try {
      if (!await checkRateLimit(
          'password_verify', const Duration(seconds: 30))) {
        return '너무 많은 시도가 있었습니다. 잠시 후 다시 시도해주세요.';
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return '이메일 또는 비밀번호가 올바르지 않습니다.';
      }
      return null;
    } catch (e) {
      debugPrint('비밀번호 검증 중 오류 발생: $e');
      return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
    }
  }

  // 이메일 중복 확인 메서드
  static Future<String?> checkEmailDuplicate(
      String email, String languageCode) async {
    try {
      if (!await checkRateLimit('email_check', const Duration(seconds: 30))) {
        return '너무 많은 시도가 있었습니다. 잠시 후 다시 시도해주세요.';
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return '이미 등록된 이메일입니다.';
      }
      return null;
    } catch (e) {
      debugPrint('이메일 중복 확인 중 오류 발생: $e');
      return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
    }
  }
}
