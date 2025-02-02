import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onjung_v1/data/%08shared/unified_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionProvider =
    ChangeNotifierProvider((ref) => TransactionProvider());

class TransactionProvider extends ChangeNotifier {
  List<UnifiedTransaction> _transactions = [];

  List<UnifiedTransaction> get transactions => _transactions;
  Future<void> initializeTransactions() async {
    try {
      // JSON 파일 로드
      final String jsonString = await rootBundle.loadString(
        'assets/dummy_transactions_personal.json',
      );

      // JSON 데이터를 Map으로 디코드
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // transactions 키에서 리스트 데이터를 추출
      final List<dynamic> transactionsData = jsonData['transactions'];

      // transactions 데이터를 UnifiedTransaction 리스트로 변환
      _transactions = transactionsData
          .map((item) => UnifiedTransaction.fromJson(item))
          .toList();

      // 로드된 거래 수 출력
      debugPrint('✅ Transactions loaded: ${_transactions.length}');
      for (var transaction in _transactions) {
        debugPrint('🧾 Transaction: ${transaction.toJson()}');
      }

      // 상태 변경 알림
      notifyListeners();
    } catch (e) {
      // 오류 발생 시 로그 출력
      debugPrint('❌ Error loading transactions: $e');
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
