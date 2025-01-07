import 'package:flutter/material.dart';

import '../widgets/app_bar_with_icons.dart';
import '../widgets/calendar_view.dart';
import './transaction_list_view_screen.dart';

class CalendarTabScreen extends StatelessWidget {
  const CalendarTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 탭 수
      child: Scaffold(
        appBar: AppBarWithIcons(),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: '달력'),
                Tab(text: '내역'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CalendarView(),
                  TransactionListViewScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
