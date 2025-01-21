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

    await remoteConfig.setDefaults({
      'latest_version': '1.0.0', // 기본 버전
      'is_testing_enabled': false, // 테스트 모드 기본값
    });
  }
}

class VersionCheckService {
  final _remoteConfig = FirebaseRemoteConfig.instance;

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<bool> checkForUpdate() async {
    try {
      await _remoteConfig.fetchAndActivate();
      String latestVersion = _remoteConfig.getString('latest_version');
      String currentVersion = await getAppVersion();

      debugPrint('현재 버전: $currentVersion');
      debugPrint('최신 버전: $latestVersion');

      return latestVersion != currentVersion;
    } catch (e) {
      debugPrint('업데이트 확인 실패: $e');
      return false;
    }
  }

  bool isTestingEnabled() {
    return _remoteConfig.getBool('is_testing_enabled');
  }
}
