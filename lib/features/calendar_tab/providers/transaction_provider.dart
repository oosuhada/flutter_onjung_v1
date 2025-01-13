import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onjung_v1/data/shared/unified_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionProvider =
    ChangeNotifierProvider((ref) => TransactionProvider());

class TransactionProvider extends ChangeNotifier {
  List<UnifiedTransaction> _transactions = [];

  List<UnifiedTransaction> get transactions => _transactions;
  Future<void> initializeTransactions() async {
    try {
      // 개인 거래 데이터 로드
      final personalDataString = await rootBundle.loadString(
        'assets/dummy_transactions_personal.json',
      );
      final personalData =
          json.decode(personalDataString) as Map<String, dynamic>;
      final personalTransactions = (personalData['transactions'] as List)
          .map((item) => UnifiedTransaction.fromJson(item))
          .toList();

      // 그룹 거래 데이터 로드
      final groupDataString = await rootBundle.loadString(
        'assets/dummy_transactions_group.json',
      );
      final groupData = json.decode(groupDataString) as Map<String, dynamic>;
      final groupTransactions = <UnifiedTransaction>[];

      for (var community in (groupData['communities'] as List)) {
        for (var transaction in (community['transactions'] as List)) {
          groupTransactions.add(
            UnifiedTransaction.fromJson({
              'id': transaction['groupTransactionId'],
              'date': transaction['groupTransactionDate'],
              'amount': transaction['groupTransactionAmount'],
              'type': transaction['groupTransactionIsReceived']
                  ? 'received'
                  : 'sent',
              'counterpart': community['name'],
              'label': transaction['groupTransactionEventType'],
              'memo': transaction['groupTransactionMemo'],
            }),
          );
        }
      }

      // 데이터를 통합
      _transactions = [...personalTransactions, ...groupTransactions];

      debugPrint('✅ 총 로드된 거래 수: ${_transactions.length}');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ 거래 데이터 로드 실패: $e');
    }
  }

  List<UnifiedTransaction> getTransactionsForDay(DateTime day) {
    return _transactions
        .where((transaction) =>
            transaction.date.year == day.year &&
            transaction.date.month == day.month &&
            transaction.date.day == day.day)
        .toList();
  }

  List<UnifiedTransaction> getTransactionsForNickname(String nickname) {
    return _transactions
        .where((transaction) => transaction.counterpart == nickname)
        .toList();
  }

  void addTransaction(UnifiedTransaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }
}
