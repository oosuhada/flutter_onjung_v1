import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/%08shared/widgets/bottom_navigation_bar.dart';
import 'package:flutter_onjung_v1/features/address_tab/screens/address_tab_screen.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/screens/calendar_tab_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/home_tab_screen.dart';
import 'package:flutter_onjung_v1/features/onjung_tab/screens/onjung_tab_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // 초기 인덱스 설정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeTabScreen(),
          AddressTabScreen(),
          CalendarTabScreen(),
          OnjungTabScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex, // 현재 활성화된 인덱스 전달
        onTap: (index) {
          setState(() {
            _currentIndex = index; // 인덱스 업데이트
          });
        },
      ),
    );
  }
}
