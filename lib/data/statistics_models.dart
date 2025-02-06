// statistics_models.dart

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

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
  final Map<String, int> monthlyAmounts;

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
      monthlyAmounts: Map<String, int>.from(json['monthlyAmounts']),
    );
  }

  // 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'period': {
        'startYear': period.startYear,
        'startMonth': period.startMonth,
        'endYear': period.endYear,
        'endMonth': period.endMonth,
      },
      'totalCount': totalCount,
      'sentCount': sentCount,
      'receivedCount': receivedCount,
      'totalAmount': totalAmount,
      'sentAmount': sentAmount,
      'receivedAmount': receivedAmount,
      'monthlyAmounts': monthlyAmounts.map(
          (key, value) => MapEntry(key.toString(), value)), // 키를 String으로 변환
    };
  }
}

// 거래 데이터 로드 함수
Future<List<Map<String, dynamic>>> loadTransactionsFromFile(
    String filePath) async {
  // File I/O 대신 rootBundle 사용
  final content = await rootBundle.loadString(filePath);
  final data = json.decode(content);
  return List<Map<String, dynamic>>.from(data['transactions']);
}

// 월별 통계 계산
Map<String, int> calculateMonthlyAmounts(
    List<Map<String, dynamic>> transactions) {
  Map<String, int> monthlyAmounts = {};
  for (var transaction in transactions) {
    final dateParts = transaction["date"].split('-');
    final key = "${dateParts[0]}-${dateParts[1]}";
    monthlyAmounts[key] =
        (monthlyAmounts[key] ?? 0) + transaction["amount"] as int;
  }
  return monthlyAmounts;
}

// StatisticsSummary 생성 함수
Future<StatisticsSummary> generateStatisticsSummary({
  required PeriodRange period,
}) async {
  // 거래 데이터 로드
  const filePath = 'assets/dummy_transactions_personal.json';
  final transactions = await loadTransactionsFromFile(filePath);

  // 선택된 기간에 해당하는 데이터 필터링
  final filteredTransactions = transactions.where((t) {
    final dateParts = t["date"].split('-').map(int.parse).toList();
    final transactionDate = DateTime(dateParts[0], dateParts[1]);

    return !transactionDate
            .isBefore(DateTime(period.startYear, period.startMonth)) &&
        !transactionDate.isAfter(DateTime(period.endYear, period.endMonth));
  }).toList();

  // 월별 통계 계산
  final monthlyAmounts = calculateMonthlyAmounts(filteredTransactions);

  // StatisticsSummary 객체 생성 및 반환
  return StatisticsSummary(
    nickname: '르탄이',
    period: period,
    totalCount: filteredTransactions.length,
    sentCount: filteredTransactions.where((t) => t["type"] == "sent").length,
    receivedCount:
        filteredTransactions.where((t) => t["type"] == "received").length,
    totalAmount: filteredTransactions.fold(
      0,
      (sum, t) => sum + t["amount"] as int,
    ),
    sentAmount: filteredTransactions
        .where((t) => t["type"] == "sent")
        .fold(0, (sum, t) => sum + t["amount"] as int),
    receivedAmount: filteredTransactions
        .where((t) => t["type"] == "received")
        .fold(0, (sum, t) => sum + t["amount"] as int),
    monthlyAmounts: monthlyAmounts,
  );
}
