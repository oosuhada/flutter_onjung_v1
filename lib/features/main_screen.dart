// import 'package:flutter/material.dart';
// import 'package:flutter_onjung_v1/%08shared/widgets/bottom_navigation_bar.dart';
// import 'package:flutter_onjung_v1/features/address_tab/screens/address_tab_screen.dart';
// import 'package:flutter_onjung_v1/features/calendar_tab/screens/calendar_tab_screen.dart';
// import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/home_tab_screen.dart';
// import 'package:flutter_onjung_v1/features/onjung_tab/screens/onjung_tab_screen.dart';
// import 'package:go_router/go_router.dart';

// class MainScreen extends StatefulWidget {
//   final int initialIndex;
//   final Widget? child;

//   const MainScreen({Key? key, this.initialIndex = 0, this.child})
//       : super(key: key);

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   late int _currentIndex;

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//   }

//   @override
//   Widget build(BuildContext context) {
//     debugPrint('🛠 MainScreen: Building MainScreen');
//     debugPrint(
//         '🛠 MainScreen: _currentIndex=$_currentIndex, widget.child=${widget.child}');

//     return Scaffold(
//       body: Stack(
//         children: [
//           // IndexedStack을 렌더링하여 탭 구조 유지
//           IndexedStack(
//             index: _currentIndex,
//             children: const [
//               HomeTabScreen(),
//               AddressTabScreen(),
//               CalendarTabScreen(),
//               OnjungTabScreen(),
//             ],
//           ),
//           // 추가된 child가 있으면 렌더링
//           if (widget.child != null) widget.child!,
//         ],
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           debugPrint('🛠 MainScreen: BottomNavigationBar index=$index');
//           setState(() {
//             _currentIndex = index;
//           });
//           switch (index) {
//             case 0:
//               context.go('/main/home');
//               break;
//             case 1:
//               context.go('/main/address');
//               break;
//             case 2:
//               context.go('/main/calendar');
//               break;
//             case 3:
//               context.go('/main/onjung');
//               break;
//           }
//         },
//       ),
//     );
//   }
// }
