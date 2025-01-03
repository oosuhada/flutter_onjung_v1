// lib/features/main/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/%08shared/widgets/bottom_navigation_bar.dart';
import 'package:flutter_onjung_v1/features/address_tab/screens/address_tab_screen.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/screens/calendar_tab_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/screens/home_tab_screen.dart';
import 'package:flutter_onjung_v1/features/onjung_tab/screens/onjung_tab_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTabScreen(),
    const AddressTabScreen(),
    const CalendarTabScreen(),
    const OnjungTabScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
