// lib/features/address_tab/screens/member_profile_tab.dart
import 'package:flutter/material.dart';

class MemberProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          title: Text('기본 정보'),
          subtitle: Text('전화번호: 010-1234-5678'),
        ),
        Divider(),
        ListTile(
          title: Text('생일'),
          subtitle: Text('1972.08.14'),
        ),
        Divider(),
        SwitchListTile(
          title: Text('알림 설정'),
          value: true,
          onChanged: (value) {
            // 알림 상태 변경
          },
        ),
      ],
    );
  }
}
