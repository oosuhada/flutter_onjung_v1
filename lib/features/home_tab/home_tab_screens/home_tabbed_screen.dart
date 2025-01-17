import 'package:flutter/material.dart';

import 'my_onjung_screen.dart';
import 'onjung_statistics_screen.dart';

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
          title: const Text(''),
          bottom: TabBar(
            indicatorColor: Colors.orange[800], // 활성화된 탭의 밑줄 색상
            labelColor: Colors.orange[800], // 활성화된 탭 텍스트 색상
            unselectedLabelColor: Colors.grey, // 비활성화된 탭 텍스트 색상
            tabs: const [
              Tab(text: '나의 온정'),
              Tab(text: '온정 평균'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const MyOnjungScreen(),
            OnjungStatisticsScreen(),
          ],
        ),
      ),
    );
  }
}
