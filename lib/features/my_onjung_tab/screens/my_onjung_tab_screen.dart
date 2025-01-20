import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/providers/event_provider.dart';
import 'package:flutter_onjung_v1/shared/widgets/bottom_navigation_bar.dart';
import 'package:flutter_onjung_v1/shared/widgets/drawer_menu.dart';
import 'package:flutter_onjung_v1/shared/widgets/notification_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/celebration_card.dart';

class MyOnjungTabScreen extends ConsumerStatefulWidget {
  const MyOnjungTabScreen({super.key});

  @override
  ConsumerState<MyOnjungTabScreen> createState() => _MyOnjungTabScreenState();
}

class _MyOnjungTabScreenState extends ConsumerState<MyOnjungTabScreen> {
  late ScrollController _scrollController;
  final currencyFormat = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventProvider);

    return Scaffold(
      endDrawer: const RightDrawerMenu(),
      appBar: AppBar(
        title: const Text('나의 온정'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              debugPrint('Search 버튼 클릭');
            },
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
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ),
      body: eventsAsync.when(
        data: (events) => Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '이제 쉽고 빠르게 경조사비 관리 시작해보세요!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7, // 카드 비율 조정
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return CelebrationCard(
                        event: event,
                        onTap: () {
                          context.pushNamed(
                            AppRoute.onjungEvent.name,
                            pathParameters: {
                              'eventId': event.eventId
                            }, // id 대신 eventId 사용
                          );
                        },
                      );
                    },
                  ),
                  // 새 이벤트 추가 카드를 별도로 배치
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          context.pushNamed(AppRoute.onjungCreate.name);
                        },
                        child: const SizedBox(
                          height: 60,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline, size: 24),
                                SizedBox(width: 8),
                                Text('새로운 경조사 추가'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '온정 파트너 리스트',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(37.5665, 126.9780),
                        initialZoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(37.5665, 126.9780),
                              width: 80,
                              height: 80,
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error loading events: $error')),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          debugPrint('BottomNavigationBar 클릭: $index');
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
