// lib/features/address_tab/screens/address_tab_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/%08shared/widgets/bottom_navigation_bar.dart';
import 'package:flutter_onjung_v1/features/address_tab/screens/group_tab.dart';
import 'package:flutter_onjung_v1/features/address_tab/screens/personal_tab.dart';
import 'package:go_router/go_router.dart';

class AddressTabScreen extends StatelessWidget {
  const AddressTabScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('주소록'),
          bottom: TabBar(
            tabs: [
              Tab(text: '개인'),
              Tab(text: '그룹'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PersonalTab(),
            GroupTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add new address
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 1, // 현재 탭 인덱스
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
