import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/statistics_models.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/home_tabbed_screen.dart';

class RecentUsageChart extends StatelessWidget {
  final Map<String, dynamic> jsonData;
  final PeriodRange period;
  final VoidCallback? onTap; // onTap 콜백 추가

  const RecentUsageChart({
    Key? key,
    required this.jsonData,
    required this.period,
    this.onTap,
  }) : super(key: key);

  int calculateMonthDifference(DateTime start, DateTime end) {
    return (end.year - start.year) * 12 + (end.month - start.month) + 1;
  }

  List<UsageData> _generateData() {
    DateTime currentDate = DateTime(period.startYear, period.startMonth);
    final endDate = DateTime(period.endYear, period.endMonth);
    final totalMonths = calculateMonthDifference(currentDate, endDate);

    if (totalMonths < 12) {
      return _generateMonthlyData(currentDate, endDate);
    } else {
      return _generateQuarterlyData(currentDate, endDate);
    }
  }

  List<UsageData> _generateMonthlyData(DateTime startDate, DateTime endDate) {
    List<UsageData> monthlyData = [];
    DateTime currentDate = startDate;

    while (!currentDate.isAfter(endDate)) {
      final key = _formatDateKey(currentDate);

      monthlyData.add(UsageData(
        date: currentDate,
        amount:
            jsonData.containsKey(key) ? int.parse(jsonData[key].toString()) : 0,
      ));

      currentDate = _moveToNextMonth(currentDate);
    }

    return monthlyData;
  }

  List<UsageData> _generateQuarterlyData(DateTime startDate, DateTime endDate) {
    Map<String, List<int>> quarterlyAmounts = {};
    DateTime currentDate = startDate;

    while (!currentDate.isAfter(endDate)) {
      final key = _formatDateKey(currentDate);
      final yearQuarterKey = '${currentDate.year}-${_getQuarter(currentDate)}';

      if (!quarterlyAmounts.containsKey(yearQuarterKey)) {
        quarterlyAmounts[yearQuarterKey] = [];
      }

      quarterlyAmounts[yearQuarterKey]?.add(
          jsonData.containsKey(key) ? int.parse(jsonData[key].toString()) : 0);

      currentDate = _moveToNextMonth(currentDate);
    }

    List<MapEntry<String, List<int>>> sortedEntries = quarterlyAmounts.entries
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sortedEntries.map((entry) {
      final amounts = entry.value;
      final avgAmount = amounts.reduce((a, b) => a + b) ~/ amounts.length;
      final quarter = entry.key.split('-')[1];

      return UsageData(
        date: DateTime(startDate.year, startDate.month),
        amount: avgAmount,
        label: '${quarter}Q',
      );
    }).toList();
  }

  DateTime _moveToNextMonth(DateTime date) {
    if (date.month == 12) {
      return DateTime(date.year + 1, 1);
    } else {
      return DateTime(date.year, date.month + 1);
    }
  }

  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  String _getQuarter(DateTime date) {
    return ((date.month - 1) ~/ 3 + 1).toString();
  }

  String _getPeriodText() {
    int totalMonths = ((period.endYear - period.startYear) * 12) +
        (period.endMonth - period.startMonth) +
        1;
    return '총 $totalMonths개월';
  }

  @override
  Widget build(BuildContext context) {
    final data = _generateData();
    final totalMonths = calculateMonthDifference(
        DateTime(period.startYear, period.startMonth),
        DateTime(period.endYear, period.endMonth));
    final showQuarterly = totalMonths >= 12;

    final minY = data.isEmpty
        ? 0.0
        : (data.map((e) => e.amount).reduce((a, b) => a < b ? a : b) * 0.8)
            .toDouble();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeTabbedScreen(initialIndex: 0),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getPeriodText(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: data.length.toDouble() - 1,
                  minY: minY,
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < data.length) {
                            if (showQuarterly) {
                              return Text(
                                data[index].label ?? '',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return Text(
                                '${data[index].date.month}월',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.amount.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orange.withOpacity(0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          final index = spot.x.toInt();
                          final usage = data[index];
                          final monthLabel = showQuarterly
                              ? usage.label!
                              : '${usage.date.month}월';
                          return LineTooltipItem(
                            '$monthLabel\n${_formatCurrency(usage.amount)}',
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int value) {
    return value.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (match) => '${match[1]},',
            ) +
        '원';
  }
}

class UsageData {
  final DateTime date;
  final int amount;
  final String? label;

  UsageData({
    required this.date,
    required this.amount,
    this.label,
  });
}
