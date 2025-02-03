import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/%08shared/widgets/bottom_navigation_bar.dart';
import 'package:flutter_onjung_v1/%08shared/widgets/drawer_menu.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import './calendar_view_screen.dart';
import './transaction_list_view_screen.dart';

final selectedCalendarTabProvider = StateProvider<int>((ref) => 0);

class CalendarTabScreen extends ConsumerStatefulWidget {
  const CalendarTabScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CalendarTabScreen> createState() => _CalendarTabScreenState();
}

class _CalendarTabScreenState extends ConsumerState<CalendarTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      ref.read(selectedCalendarTabProvider.notifier).state =
          _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(selectedCalendarTabProvider);

    if (_tabController.index != selectedTab) {
      _tabController.animateTo(selectedTab);
    }

    return Scaffold(
      endDrawer: const RightDrawerMenu(),
      appBar: AppBar(
        title: Text('온정부'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Implement notifications functionality
            },
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: '달력'),
              Tab(text: '내역'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CalendarViewScreen(),
                TransactionListViewScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.goNamed(AppRoute.homeTab.name);
              break;
            case 1:
              context.goNamed(AppRoute.addressTab.name);
              break;
            case 2:
              context.goNamed(AppRoute.calendarTab.name);
              break;
            case 3:
              context.goNamed(AppRoute.onjungTab.name);
              break;
          }
        },
      ),
    );
  }
}
