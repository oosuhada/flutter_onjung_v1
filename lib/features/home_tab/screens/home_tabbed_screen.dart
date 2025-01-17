// lib/features/home/screens/home_tabbed_screen.dart
import 'package:flutter/material.dart';

import 'my_onjung_screen.dart';
import 'onjung_average_screen.dart';

class HomeTabbedScreen extends StatelessWidget {
  final int initialIndex;

  const HomeTabbedScreen({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex, // Use the provided initial index
      child: Scaffold(
        appBar: AppBar(
          title: const Text('홈 관리'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '나의 온정'),
              Tab(text: '온정 평균'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyOnjungScreen(),
            OnjungAverageScreen(),
          ],
        ),
      ),
    );
  }
}
