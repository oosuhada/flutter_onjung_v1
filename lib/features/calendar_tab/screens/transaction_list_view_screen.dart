import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/screens/transaction_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';
import '../widgets/transaction_item.dart';

class TransactionListViewScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider).transactions;

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionItem(
          transaction: transaction,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionDetailScreen(
                  transaction: transaction,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
