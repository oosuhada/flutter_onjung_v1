import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_onjung_v1/data/shared/unified_transaction.dart';

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

// First, let's create an enum for the statistics type
enum StatisticsType { personal, group, combined }

class StatisticsSummary {
  final String nickname;
  final PeriodRange period;
  final int totalCount;
  final int sentCount;
  final int receivedCount;
  final int totalAmount;
  final int sentAmount;
  final int receivedAmount;
  final List<UnifiedTransaction> transactions;
  final Map<String, int> monthlyAmounts;
  final StatisticsType type;

  const StatisticsSummary({
    required this.nickname,
    required this.period,
    required this.totalCount,
    required this.sentCount,
    required this.receivedCount,
    required this.totalAmount,
    required this.sentAmount,
    required this.receivedAmount,
    required this.transactions,
    required this.monthlyAmounts,
    this.type = StatisticsType.combined, // Default value added
  });

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
      transactions: (json['transactions'] as List?)
              ?.map((t) => UnifiedTransaction.fromJson(t))
              .toList() ??
          [],
      monthlyAmounts: Map<String, int>.from(json['monthlyAmounts']),
      type: json['type'] != null
          ? StatisticsType.values.firstWhere(
              (e) => e.name == json['type'],
              orElse: () => StatisticsType.combined,
            )
          : StatisticsType.combined,
    );
  }

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
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'monthlyAmounts': monthlyAmounts,
      'type': type.name,
    };
  }
}

// 거래 데이터 로드 함수
Future<List<Map<String, dynamic>>> loadTransactionsFromFile(
  String filePath,
  StatisticsType type,
) async {
  try {
    final content = await rootBundle.loadString(filePath);
    final data = json.decode(content) as Map<String, dynamic>;

    if (type == StatisticsType.personal) {
      return (data['transactions'] as List?)
              ?.map((transaction) => Map<String, dynamic>.from(transaction))
              .toList() ??
          [];
    } else if (type == StatisticsType.group) {
      List<Map<String, dynamic>> allGroupTransactions = [];
      final communities = data['communities'] as List? ?? [];
      for (var community in communities) {
        final transactions =
            (community['transactions'] as List? ?? []).map((transaction) {
          return {
            'id': transaction['groupTransactionId'],
            'date': transaction['groupTransactionDate'].split('T')[0], // 날짜만 추출
            'amount': transaction['groupTransactionAmount'],
            'type':
                transaction['groupTransactionIsReceived'] ? 'received' : 'sent',
            'counterpart': community['name'] ?? 'unknown',
            'label': transaction['groupTransactionEventType'],
            'memo': transaction['groupTransactionMemo'],
          };
        }).toList();
        allGroupTransactions.addAll(transactions.cast<Map<String, dynamic>>());
      }
      return allGroupTransactions;
    }

    return [];
  } catch (e) {
    print('Error loading transactions from $filePath: $e');
    return [];
  }
}

Map<String, int> calculateMonthlyAmounts(
    List<Map<String, dynamic>> transactions) {
  Map<String, int> monthlyAmounts = {};
  for (var transaction in transactions) {
    final dateParts = transaction["date"].split('-');
    final key = "${dateParts[0]}-${dateParts[1]}";
    monthlyAmounts[key] =
        (monthlyAmounts[key] ?? 0) + (transaction["amount"] as int);
  }
  return monthlyAmounts;
}

Future<StatisticsSummary> generateStatisticsSummary({
  required PeriodRange period,
  required StatisticsType type,
}) async {
  List<Map<String, dynamic>> transactions = [];

  try {
    switch (type) {
      case StatisticsType.personal:
        transactions = await loadTransactionsFromFile(
          'assets/dummy_transactions_personal.json',
          StatisticsType.personal,
        );
        break;
      case StatisticsType.group:
        transactions = await loadTransactionsFromFile(
          'assets/dummy_transactions_group.json',
          StatisticsType.group,
        );
        break;
      case StatisticsType.combined:
        final personalTransactions = await loadTransactionsFromFile(
          'assets/dummy_transactions_personal.json',
          StatisticsType.personal,
        );
        final groupTransactions = await loadTransactionsFromFile(
          'assets/dummy_transactions_group.json',
          StatisticsType.group,
        );
        transactions = [...personalTransactions, ...groupTransactions];
        break;
    }

    final filteredTransactions = transactions.where((t) {
      final dateParts = t["date"].split('-').map(int.parse).toList();
      final transactionDate = DateTime(dateParts[0], dateParts[1]);
      return !transactionDate
              .isBefore(DateTime(period.startYear, period.startMonth)) &&
          !transactionDate.isAfter(DateTime(period.endYear, period.endMonth));
    }).toList();

    print('Filtered ${type.name} data count: ${filteredTransactions.length}');

    final unifiedTransactions = filteredTransactions
        .map((t) => UnifiedTransaction.fromJson(t))
        .toList();
    final monthlyAmounts = calculateMonthlyAmounts(filteredTransactions);

    return StatisticsSummary(
      nickname: '르탄이',
      period: period,
      totalCount: filteredTransactions.length,
      sentCount: filteredTransactions.where((t) => t["type"] == "sent").length,
      receivedCount:
          filteredTransactions.where((t) => t["type"] == "received").length,
      totalAmount: filteredTransactions.fold(
        0,
        (sum, t) => sum + (t["amount"] as int),
      ),
      sentAmount: filteredTransactions
          .where((t) => t["type"] == "sent")
          .fold(0, (sum, t) => sum + (t["amount"] as int)),
      receivedAmount: filteredTransactions
          .where((t) => t["type"] == "received")
          .fold(0, (sum, t) => sum + (t["amount"] as int)),
      transactions: unifiedTransactions,
      monthlyAmounts: monthlyAmounts,
      type: type,
    );
  } catch (e) {
    print('Error generating statistics: $e');
    rethrow;
  }
}
