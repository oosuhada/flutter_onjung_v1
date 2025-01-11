import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_onjung_v1/features/address_tab/main_screens/group_tab.dart';
import 'package:flutter_onjung_v1/features/address_tab/main_screens/personal_tab.dart';
import 'package:flutter_onjung_v1/features/shared_drawer_tab/drawer_menu.dart';
import 'package:flutter_onjung_v1/shared/shared_widgets/bottom_navigation_bar.dart';
import 'package:flutter_onjung_v1/shared/shared_widgets/notification_screen.dart';
import 'package:go_router/go_router.dart';

class AddressTabScreen extends StatefulWidget {
  const AddressTabScreen({Key? key}) : super(key: key);

  @override
  _AddressTabScreenState createState() => _AddressTabScreenState();
}

class _AddressTabScreenState extends State<AddressTabScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTabIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  void _initializeTabController() {
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_handleTabChange);
    _isInitialized = true;
  }

  void _handleTabChange() {
    // 실제로 탭이 변경될 때만 setState 호출
    if (!_tabController.indexIsChanging) {
      return;
    }
    if (_currentTabIndex != _tabController.index) {
      setState(() {
        _currentTabIndex = _tabController.index;
        debugPrint('🔄 현재 Tab Index: $_currentTabIndex');
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      endDrawer: const RightDrawerMenu(), // 오른쪽에서 나오는 드로어
      appBar: AppBar(
        title: const Text(
          '온정록',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications), // 알림 아이콘
            onPressed: () {
              debugPrint('Notifications 버튼 클릭');
              // NotificationScreen으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // 오른쪽 드로어 열기
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '개인'),
            Tab(text: '그룹'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PersonalTab(),
          GroupTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_currentTabIndex == 0) {
            debugPrint('인원 등록 클릭됨');
          } else {
            debugPrint('그룹 등록 클릭됨');
          }
        },
        backgroundColor: Colors.orange[800],
        label: Text(
          _currentTabIndex == 0 ? '인원 등록' : '그룹 등록',
          style: const TextStyle(fontSize: 16.0),
        ),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
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
