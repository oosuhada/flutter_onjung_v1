// screens/transaction_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/%08shared/unified_transaction.dart';

class TransactionDetailScreen extends StatelessWidget {
  final UnifiedTransaction transaction;

  const TransactionDetailScreen({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상세 정보'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.id, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text('￦${transaction.amount}',
                style: Theme.of(context).textTheme.headlineSmall),
            // Add more transaction details...
          ],
        ),
      ),
    );
  }
}
