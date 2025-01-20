// home_tab_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_onjung_v1/data/home_tab/statistics_models.dart'
    as statistics_model;
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/home_tabbed_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/widgets/my_recent_statistics_summary.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/widgets/my_recent_usage_chart.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/widgets/onjung_statistics_card.dart';
import 'package:flutter_onjung_v1/shared/widgets/bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({Key? key}) : super(key: key);

  @override
  _HomeTabScreenState createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  late statistics_model.StatisticsSummary currentStatistics;
  bool isLoading = true;
  statistics_model.StatisticsType currentType =
      statistics_model.StatisticsType.combined;

  @override
  void initState() {
    super.initState();
    currentStatistics = statistics_model.StatisticsSummary(
      nickname: '르탄이',
      period: const statistics_model.PeriodRange(
          startYear: 2024, startMonth: 1, endYear: 2024, endMonth: 12),
      totalCount: 0,
      sentCount: 0,
      receivedCount: 0,
      totalAmount: 0,
      sentAmount: 0,
      receivedAmount: 0,
      monthlyAmounts: {},
      transactions: [], // 빈 리스트로 초기화
      type: statistics_model.StatisticsType.combined, // 초기 타입 설정
    );

    _loadStatistics();
  }

  Future<void> _loadStatistics({
    statistics_model.PeriodRange? period,
    statistics_model.StatisticsType? type,
  }) async {
    setState(() {
      isLoading = true;
    });

    // 기간과 타입이 전달되지 않으면 현재 값 사용
    final targetPeriod = period ?? currentStatistics.period;
    final targetType = type ?? currentType;

    // 데이터를 비동기로 로드
    final updatedStatistics = await statistics_model.generateStatisticsSummary(
      period: targetPeriod,
      type: targetType,
    );

    setState(() {
      currentStatistics = updatedStatistics;
      currentType = targetType;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🏠 HomeTabScreen: Building HomeTabScreen');

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _buildHomeContent(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          debugPrint('FloatingActionButton pressed');
          try {
            debugPrint('Attempting to navigate to amount input screen...');
            context.push('/amountInput');
            debugPrint('Navigation successful');
          } catch (e) {
            debugPrint('Navigation error occurred: $e');
          }
        },
        backgroundColor: Colors.orange[800],
        label: const Text('빠른등록', style: TextStyle(fontSize: 16.0)),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
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

  Widget _buildHomeContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 100.0, bottom: 32.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecentStatisticsSummary(
              statistics: currentStatistics,
              onPeriodChanged: (statistics_model.PeriodRange newPeriod) {
                _loadStatistics(period: newPeriod);
                debugPrint('Period changed: ${newPeriod.toFormattedString()}');
              },
              // onTypeChanged: (statistics_model.StatisticsType newType) {
              //   _loadStatistics(type: newType);
              //   debugPrint('Type changed to: ${newType.name}');
              // },
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            RecentUsageChart(
              jsonData: currentStatistics.toJson()['monthlyAmounts'],
              period: currentStatistics.period,
              onTap: () => _navigateToTabbedScreen(context, 0),
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _navigateToTabbedScreen(context, 1),
              child: const RandomOnjungStatisticsCard(),
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  void _navigateToTabbedScreen(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeTabbedScreen(initialIndex: initialIndex),
      ),
    );
  }
}
