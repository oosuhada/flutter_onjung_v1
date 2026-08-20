import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      await _setupRemoteConfig();
      debugPrint('Firebase 초기화 성공!');
    } catch (e) {
      debugPrint('Firebase 초기화 실패: $e');
    }
  }

  static Future<void> _setupRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    // 플랫폼에 따라 스토어 URL 설정
    final storeUrl = Platform.isIOS
        ? 'https://apps.apple.com/app/id123456789' // iOS 앱스토어 URL
        : 'https://play.google.com/store/apps/details?id=com.example.app'; // Android Play스토어 URL

    // 기본값 설정
    await remoteConfig.setDefaults({
      'latest_version': '1.0.0', // 기본 최신 버전
      'update_url': storeUrl, // 플랫폼에 따른 URL 설정
    });
  }
}

class VersionCheckService {
  final _remoteConfig = FirebaseRemoteConfig.instance;

  // 현재 앱 버전을 가져오는 메서드
  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  // 업데이트 여부 확인 메서드
  Future<bool> checkForUpdate() async {
    try {
      // Remote Config fetch & activate
      bool activated = await _remoteConfig.fetchAndActivate();
      debugPrint('Remote Config 활성화 상태: $activated');

      // 최신 버전 정보 가져오기
      String latestVersion = _remoteConfig.getString('latest_version');
      if (latestVersion.isEmpty) {
        debugPrint('최신 버전 정보가 없습니다.');
        return false; // 최신 버전 정보가 없으면 업데이트 필요 없음
      }

      // 현재 앱 버전 가져오기
      String currentVersion = await getAppVersion();
      debugPrint('현재 버전: $currentVersion');
      debugPrint('최신 버전: $latestVersion');

      // 버전 비교
      return _isNewerVersion(latestVersion, currentVersion);
    } catch (e) {
      debugPrint('업데이트 확인 실패: $e');
      return false; // 오류 발생 시 업데이트 필요 없음
    }
  }

// 버전 비교 로직 (숫자 비교 방식)
  bool _isNewerVersion(String latest, String current) {
    List<int> latestParts = latest.split('.').map(int.parse).toList();
    List<int> currentParts = current.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length || latestParts[i] > currentParts[i]) {
        return true; // 최신 버전이 더 큼
      } else if (latestParts[i] < currentParts[i]) {
        return false; // 현재 버전이 더 큼
      }
    }
    return false; // 버전이 같음
  }

  // 업데이트 URL 가져오는 메서드
  String getUpdateUrl() {
    return _remoteConfig.getString('update_url');
  }

  bool isTestingEnabled() {
    return _remoteConfig.getBool('is_testing_enabled');
  }
}
