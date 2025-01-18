// lib/features/calendar_tab/screens/calendar_tab_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/%08shared/widgets/bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';

class CalendarTabScreen extends StatelessWidget {
  const CalendarTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('달력'),
      ),
      body: const Center(
        child: Text('달력 화면'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // 현재 탭 인덱스
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/address');
              break;
            case 2:
              context.go('/calendar');
              break;
            case 3:
              context.go('/onjung');
              break;
          }
        },
      ),
    );
  }
}
