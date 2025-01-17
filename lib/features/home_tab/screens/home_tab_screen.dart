// home_tab_screen.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/statistics_models.dart';
import 'package:flutter_onjung_v1/features/home_tab/screens/home_tabbed_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/widgets/onjung_statistics_card.dart';
import 'package:flutter_onjung_v1/features/home_tab/widgets/recent_statistics_summary.dart';
import 'package:flutter_onjung_v1/features/home_tab/widgets/recent_usage_chart.dart';
import 'package:flutter_onjung_v1/features/home_tab/widgets/relationship_average_list.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({Key? key}) : super(key: key);

  @override
  _HomeTabScreenState createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  late StatisticsSummary currentStatistics = const StatisticsSummary(
    nickname: '초기 닉네임',
    period: PeriodRange(
        startYear: 2024, startMonth: 1, endYear: 2024, endMonth: 12),
    totalCount: 0,
    sentCount: 0,
    receivedCount: 0,
    totalAmount: 0,
    sentAmount: 0,
    receivedAmount: 0,
    monthlyAmounts: {},
  );

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

// JSON 데이터 로드 함수

  Future<void> _loadStatistics() async {
    const filePath = 'assets/dummy_transactions.json'; // 파일 경로 업데이트
    final file = File(filePath);

    if (!await file.exists()) {
      throw Exception('File not found at $filePath');
    }

    final content = await file.readAsString();
    final data = json.decode(content);
    setState(() {
      currentStatistics = StatisticsSummary.fromJson(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHomeContent(context),
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
              onPeriodChanged: (PeriodRange newPeriod) {
                // 여기서 새로운 기간에 대한 데이터를 불러오거나 처리
                debugPrint('Period changed: ${newPeriod.toFormattedString()}');
              },
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
            RecentUsageChart(
              statistics: currentStatistics,
              period: currentStatistics.period,
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _navigateToTabbedScreen(context, 1),
              child: const OnjungStatisticsCard(
                title: '평균 온정지수 보기',
                subtitle: '30대는 친구와 결혼식에 115,333원 보내고 있어요.',
              ),
            ),
            const SizedBox(height: 16.0),
            const RelationshipAverageList(),
            const SizedBox(height: 16.0),
            OnjungStatisticsCard(
              title: '누적 온정 나누기 통계',
              subtitle:
                  '전체 누적 금액: ${_formatAmount(currentStatistics.totalAmount)}원 (보냄 ${_formatAmount(currentStatistics.sentAmount)}원 / 받음 ${_formatAmount(currentStatistics.receivedAmount)}원)',
            ),
            const SizedBox(height: 16.0),
            const OnjungStatisticsCard(
              title: '현재 활성 사용자 현황',
              subtitle: '활성 사용자: 500명 / 최근 일주일: 120명',
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
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
