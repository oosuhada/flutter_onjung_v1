// lib/features/address_tab/screens/member_history_tab.dart
import 'package:flutter/material.dart';

class MemberHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4, // 추후 데이터 연동
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.event),
          title: Text('생일 선물'),
          subtitle: Text('50,000원'),
        );
      },
    );
  }
}
