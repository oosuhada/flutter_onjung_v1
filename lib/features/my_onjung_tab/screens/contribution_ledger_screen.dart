// lib/features/my_onjung_tab/screens/contribution_ledger_screen.dart
import 'package:flutter/material.dart';

class Contribution {
  final String guestName;
  final int amount;
  final DateTime date;
  final String paymentMethod;

  Contribution({
    required this.guestName,
    required this.amount,
    required this.date,
    required this.paymentMethod,
  });
}

class ContributionLedgerScreen extends StatelessWidget {
  final List<Contribution> contributions = [
    Contribution(
      guestName: '김민수',
      amount: 50000,
      date: DateTime.now(),
      paymentMethod: '계좌이체',
    ),
    // Add more sample contributions
  ];

  ContributionLedgerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalAmount = contributions.fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('축의금 장부'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('총 축의금'),
                Text(
                  '${totalAmount.toString()}원',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contributions.length,
              itemBuilder: (context, index) {
                final contribution = contributions[index];
                return ListTile(
                  title: Text(contribution.guestName),
                  subtitle: Text(
                    '${contribution.date.toString().split(' ')[0]} - ${contribution.paymentMethod}',
                  ),
                  trailing: Text('${contribution.amount.toString()}원'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show add contribution dialog
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
