import 'dart:convert';
import 'dart:io';

import 'package:flutter_onjung_v1/data/statistics_models.dart';

// 거래 데이터 로드 함수
Future<List<Map<String, dynamic>>> loadTransactionsFromFile(
    String filePath) async {
  final file = File(filePath);
  final content = await file.readAsString();
  final data = json.decode(content);
  return List<Map<String, dynamic>>.from(data['transactions']);
}

// 월별 통계 계산
Map<int, int> calculateMonthlyAmounts(List<Map<String, dynamic>> transactions) {
  Map<int, int> monthlyAmounts = {};

  for (var transaction in transactions) {
    final month = int.parse(transaction["date"].split('-')[1]);
    monthlyAmounts[month] =
        (monthlyAmounts[month] ?? 0) + transaction["amount"] as int;
  }

  return monthlyAmounts;
}

void main() async {
  // JSON 파일 경로
  const filePath = '/mnt/data/korean_unique_transactions.json';

  // 거래 데이터 로드
  final transactions = await loadTransactionsFromFile(filePath);

  // 월별 통계 계산
  final monthlyAmounts = calculateMonthlyAmounts(transactions);

  // 더미 통계 생성
  final dummyStatistics = StatisticsSummary(
    nickname: '르탄이',
    period: PeriodRange(
      startYear: 2024,
      startMonth: 1,
      endYear: 2024,
      endMonth: 12,
    ),
    totalCount: transactions.length,
    sentCount: transactions.where((t) => t["type"] == "sent").length,
    receivedCount: transactions.where((t) => t["type"] == "received").length,
    totalAmount:
        transactions.fold(0, (sum, item) => sum + (item["amount"] as int)),
    sentAmount: transactions
        .where((t) => t["type"] == "sent")
        .fold(0, (sum, item) => sum + (item["amount"] as int)),
    receivedAmount: transactions
        .where((t) => t["type"] == "received")
        .fold(0, (sum, item) => sum + (item["amount"] as int)),
    monthlyAmounts: monthlyAmounts,
  );

  print('Dummy Statistics:');
  print(dummyStatistics);
}
