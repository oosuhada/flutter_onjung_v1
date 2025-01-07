// screens/calendar_view_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/screens/transaction_list_view_screen.dart';

import '../widgets/app_bar_with_icons.dart';
import '../widgets/calendar_view.dart';

class CalendarViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithIcons(),
      body: Column(
        children: [
          TabBar(
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
    );
  }
}
