// statistics_models.dart

class PeriodRange {
  final int startYear;
  final int startMonth;
  final int endYear;
  final int endMonth;

  const PeriodRange({
    required this.startYear,
    required this.startMonth,
    required this.endYear,
    required this.endMonth,
  });

  String toFormattedString() {
    return '${startYear}년 ${startMonth}월부터 ${endYear}년 ${endMonth}월까지';
  }
}

class StatisticsSummary {
  final String nickname;
  final PeriodRange period;
  final int totalCount;
  final int sentCount;
  final int receivedCount;
  final int totalAmount;
  final int sentAmount;
  final int receivedAmount;
  final Map<int, int> monthlyAmounts;

  const StatisticsSummary({
    required this.nickname,
    required this.period,
    required this.totalCount,
    required this.sentCount,
    required this.receivedCount,
    required this.totalAmount,
    required this.sentAmount,
    required this.receivedAmount,
    required this.monthlyAmounts,
  });

  // JSON 데이터를 기반으로 StatisticsSummary 생성
  factory StatisticsSummary.fromJson(Map<String, dynamic> json) {
    return StatisticsSummary(
      nickname: json['nickname'],
      period: PeriodRange(
        startYear: json['period']['startYear'],
        startMonth: json['period']['startMonth'],
        endYear: json['period']['endYear'],
        endMonth: json['period']['endMonth'],
      ),
      totalCount: json['totalCount'],
      sentCount: json['sentCount'],
      receivedCount: json['receivedCount'],
      totalAmount: json['totalAmount'],
      sentAmount: json['sentAmount'],
      receivedAmount: json['receivedAmount'],
      monthlyAmounts: Map<int, int>.from(json['monthlyAmounts']),
    );
  }
}
