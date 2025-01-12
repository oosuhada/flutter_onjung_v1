// settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/config/app_settings_manager.dart';
import 'package:flutter_onjung_v1/core/database_services/database_mobile.dart';
import 'package:flutter_onjung_v1/core/database_services/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Future<void> _resetDatabase() async {
    try {
      // 데이터베이스 삭제
      debugPrint('기존 데이터베이스 삭제 시작');
      await DatabaseProvider.instance.deleteDatabase();
      debugPrint('기존 데이터베이스 삭제 완료');

      // 데이터베이스 재초기화
      debugPrint('MobileDatabaseHelper 초기화 시작');
      await MobileDatabaseHelper().initialize();
      debugPrint('MobileDatabaseHelper 초기화 성공');

      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('캐시가 성공적으로 삭제되었습니다')),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('데이터베이스 초기화 실패: $e');
      debugPrint('스택트레이스: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('캐시 삭제 중 오류가 발생했습니다')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(appSettingsProvider);

    // 현재 테마 모드가 다크 모드인지 확인
    final isDarkMode = appSettings.themeMode == ThemeMode.dark ||
        (appSettings.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: const Text('환경설정'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('다크 모드'),
            value: isDarkMode, // 시스템 설정을 반영하도록 수정된 isDarkMode 사용
            onChanged: (bool value) async {
              try {
                final newMode = value ? ThemeMode.dark : ThemeMode.light;
                await ref
                    .read(appSettingsProvider.notifier)
                    .setThemeMode(newMode);
              } catch (e) {
                debugPrint('Theme change error: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('테마 변경 중 오류가 발생했습니다')),
                );
              }
            },
          ),
          SwitchListTile(
            title: const Text('알림 설정'),
            value: appSettings.notificationsEnabled,
            onChanged: (value) {
              ref
                  .read(appSettingsProvider.notifier)
                  .setNotificationsEnabled(value);
            },
          ),
          ListTile(
            title: const Text('캐시 삭제'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              final bool? confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('캐시 삭제'),
                    content: const Text('모든 캐시를 삭제하시겠습니까?\n앱의 모든 데이터가 초기화됩니다.'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('취소'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      TextButton(
                        child: const Text('삭제'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                await _resetDatabase();
              }
            },
          ),
        ],
      ),
    );
  }
}
