// address_tab_screen.dart 업데이트
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/%08shared/widgets/bottom_navigation_bar.dart';
import 'package:flutter_onjung_v1/features/address_tab/screens/group_tab.dart';
import 'package:flutter_onjung_v1/features/address_tab/screens/personal_tab.dart';
import 'package:go_router/go_router.dart';

class AddressTabScreen extends StatefulWidget {
  const AddressTabScreen({Key? key}) : super(key: key);

  @override
  _AddressTabScreenState createState() => _AddressTabScreenState();
}

class _AddressTabScreenState extends State<AddressTabScreen> {
  int _currentTabIndex = 0; // 현재 탭 상태 관리

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _currentTabIndex = index; // 현재 탭 업데이트
              });
            },
            tabs: const [
              Tab(text: '개인'),
              Tab(text: '그룹'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const PersonalTab(),
            GroupTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_currentTabIndex == 0) {
              // 인원 등록 로직
              debugPrint('인원 등록 클릭됨');
            } else {
              // 그룹 등록 로직
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
      ),
    );
  }
}
