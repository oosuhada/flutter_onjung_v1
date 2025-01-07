import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/%08shared/unified_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionProvider =
    ChangeNotifierProvider((ref) => TransactionProvider());

class TransactionProvider extends ChangeNotifier {
  List<UnifiedTransaction> _transactions = [];

  List<UnifiedTransaction> get transactions => _transactions;

  List<UnifiedTransaction> getTransactionsForDay(DateTime day) {
    return _transactions
        .where((transaction) =>
            transaction.date.year == day.year &&
            transaction.date.month == day.month &&
            transaction.date.day == day.day)
        .toList();
  }

  void addTransaction(UnifiedTransaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }
}
