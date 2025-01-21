// lib/features/my_onjung_tab/screens/notification_screen.dart
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.notifications),
            ),
            title: Text('알림 ${index + 1}'),
            subtitle: const Text('알림 내용이 여기에 표시됩니다.'),
            trailing: const Text('방금 전'),
            onTap: () {
              // Handle notification tap
            },
          );
        },
      ),
    );
  }
}
