// home_tab_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/statistics_models.dart'
    as statistics_model;
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/home_tabbed_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/widgets/my_recent_statistics_summary.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/widgets/my_recent_usage_chart.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/widgets/onjung_statistics_card.dart';
import 'package:flutter_onjung_v1/features/home_tab/input_screens/amount_input_screen.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({Key? key}) : super(key: key);

  @override
  _HomeTabScreenState createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  late statistics_model.StatisticsSummary currentStatistics;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    currentStatistics = const statistics_model.StatisticsSummary(
      nickname: '르탄이',
      period: statistics_model.PeriodRange(
          startYear: 2024, startMonth: 1, endYear: 2024, endMonth: 12),
      totalCount: 0,
      sentCount: 0,
      receivedCount: 0,
      totalAmount: 0,
      sentAmount: 0,
      receivedAmount: 0,
      monthlyAmounts: {},
    );

    _loadStatistics();
  }

  Future<void> _loadStatistics({
    statistics_model.PeriodRange? period,
  }) async {
    setState(() {
      isLoading = true;
    });

    // 기간이 전달되지 않으면 초기 기간 사용
    final targetPeriod = period ?? currentStatistics.period;

    // 데이터를 비동기로 로드
    final updatedStatistics = await statistics_model.generateStatisticsSummary(
      period: targetPeriod,
    );

    setState(() {
      currentStatistics = updatedStatistics;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때는 로딩 인디케이터 표시
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: _buildHomeContent(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 빠른등록 버튼 클릭 시 금액 입력 스크린으로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AmountInputScreen(),
            ),
          );
        },
        backgroundColor: Colors.orange[800], // 버튼 배경색
        label: const Text('빠른등록', style: TextStyle(fontSize: 16.0)), // 버튼 텍스트
        icon: const Icon(Icons.add), // 플러스 아이콘
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                _loadStatistics(period: newPeriod); // period 파라미터로 직접 전달
                debugPrint('Period changed: ${newPeriod.toFormattedString()}');
              },
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            RecentUsageChart(
              jsonData: currentStatistics.toJson()['monthlyAmounts'],
              period: currentStatistics.period,
              onTap: () =>
                  _navigateToTabbedScreen(context, 0), // "나의 온정" 탭으로 이동
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _navigateToTabbedScreen(context, 1),
              child: const RandomOnjungStatisticsCard(),
            ),
            const SizedBox(height: 16.0),
            // const SizedBox(height: 16.0),
            // const RelationshipAverageList(),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  // String _formatAmount(int amount) {
  //   return amount.toString().replaceAllMapped(
  //         RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
  //         (Match m) => '${m[1]},',
  //       );
  // }

  void _navigateToTabbedScreen(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeTabbedScreen(initialIndex: initialIndex),
      ),
    );
  }
}
