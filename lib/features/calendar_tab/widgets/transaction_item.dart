import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/%08shared/unified_transaction.dart';

class TransactionItem extends StatelessWidget {
  final UnifiedTransaction transaction;
  final VoidCallback? onTap;

  const TransactionItem({
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        child: Icon(Icons.attach_money),
      ),
      title: Text(transaction.label), // title을 label로 변경
      subtitle:
          Text(transaction.method.toReadableString()), // category 대신 결제 방법 표시
      trailing: Text(
        '￦${transaction.amount.toStringAsFixed(0)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: transaction.amount < 0 ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}
