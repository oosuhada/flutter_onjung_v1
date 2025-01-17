import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/statistics_models.dart';

class RecentUsageChart extends StatelessWidget {
  final StatisticsSummary statistics;
  final PeriodRange period;

  const RecentUsageChart({
    Key? key,
    required this.statistics,
    required this.period,
  }) : super(key: key);

  // _generateMonthlyData 수정
  List<UsageData> _generateMonthlyData() {
    final data = statistics.monthlyAmounts.entries
        .map((entry) => UsageData(
              date: DateTime(period.startYear, entry.key),
              amount: entry.value,
            ))
        .toList();
    return data;
  }

  List<UsageData> _generateQuarterlyData() {
    final monthlyData = _generateMonthlyData();
    final Map<String, int> quarterlySum = {};

    for (var data in monthlyData) {
      final quarter = '${data.date.year}Q${(data.date.month - 1) ~/ 3 + 1}';
      quarterlySum[quarter] = (quarterlySum[quarter] ?? 0) + data.amount;
    }

    return quarterlySum.entries.map((entry) {
      final year = int.parse(entry.key.substring(0, 4));
      final quarter = int.parse(entry.key.substring(5));
      final month = (quarter - 1) * 3 + 1;
      return UsageData(
        date: DateTime(year, month),
        amount: entry.value,
      );
    }).toList();
  }

  String _formatAmount(int amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)}천만';
    } else if (amount >= 10000) {
      return '${(amount / 10000).toStringAsFixed(1)}만';
    }
    return amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    final startDate = DateTime(period.startYear, period.startMonth);
    final endDate = DateTime(period.endYear, period.endMonth);
    final months = (endDate.year - startDate.year) * 12 +
        endDate.month -
        startDate.month +
        1;

    final isMonthly = months <= 12;
    final data = isMonthly ? _generateMonthlyData() : _generateQuarterlyData();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '최근 ${isMonthly ? months : '${(months / 3).ceil()}분기'} 동안 나눈 금액',
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
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatAmount(value.toInt()),
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          final date = data[index].date;
                          return Text(
                            isMonthly
                                ? '${date.month}월'
                                : 'Q${(date.month - 1) ~/ 3 + 1}',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          );
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
                          entry.key.toDouble(), entry.value.amount.toDouble());
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UsageData {
  final DateTime date;
  final int amount;

  UsageData({
    required this.date,
    required this.amount,
  });
}
