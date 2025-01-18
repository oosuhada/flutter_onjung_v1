// member_profile_tab.dart
import 'package:flutter/material.dart';

class MemberProfileTab extends StatelessWidget {
  const MemberProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 기본 정보
        const Text('기본 정보',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('전화번호'),
          subtitle: const Text('010-8232-8123'),
        ),
        const Divider(),

        // 나머지정보
        const Text('나머지정보',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('가족/아버지'),
        ),
        const Divider(),

        // 그룹 2
        const Text('그룹 2',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('문항 입력 140초 초과'),
          subtitle: const Text('응답 자전 불가 온조표'),
        ),
        const Divider(),

        // 생일
        const Text('생일',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('양력'),
          subtitle: const Text('1972.08.14'),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('음력'),
          subtitle: const Text('1972.07.01'),
        ),
        const Divider(),

        // 알림 설정 2
        const Text('알림 설정 2',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('결혼기념일(1985.09.24)'),
          value: true,
          onChanged: (bool value) {},
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('환갑연(1985.09.24)'),
          value: false,
          onChanged: (bool value) {},
        ),
      ],
    );
  }
}
