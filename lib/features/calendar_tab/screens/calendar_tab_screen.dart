// lib/features/calendar_tab/screens/calendar_tab_screen.dart
import 'package:flutter/material.dart';

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
    );
  }
}
