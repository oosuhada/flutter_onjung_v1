// widgets/transaction_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/%08shared/unified_transaction.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/widgets/transaction_item.dart';

class TransactionDrawer extends StatelessWidget {
  final List<UnifiedTransaction> transactions;

  const TransactionDrawer({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) =>
                  TransactionItem(transaction: transactions[index]),
            ),
          ),
        ],
      ),
    );
  }
}
