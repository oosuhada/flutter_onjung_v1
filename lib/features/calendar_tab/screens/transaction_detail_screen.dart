import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/shared/unified_transaction.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends StatelessWidget {
  final UnifiedTransaction transaction;

  const TransactionDetailScreen({Key? key, required this.transaction})
      : super(key: key);

  Widget _buildSegmentedButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '받음',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              '보냄',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Row(
            children: [
              Text(value, style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상세 정보'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              // Implement delete functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      transaction.counterpart ?? '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Amount
                    Text(
                      '${NumberFormat('#,###').format(transaction.amount)} 원',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    // Transaction Type
                    _buildSegmentedButton(),
                    SizedBox(height: 32),
                    // Details
                    _buildDetailRow('누구에게', transaction.counterpart ?? ''),
                    _buildDetailRow('경조사', transaction.relationDetail ?? ''),
                    _buildDetailRow('수단', transaction.method.toString()),
                    _buildDetailRow(
                      '날짜',
                      DateFormat('yyyy년 M월 d일').format(transaction.date),
                    ),
                    // Checkboxes
                    SwitchListTile(
                      title: Text('참석여부'),
                      value: false,
                      onChanged: (bool value) {
                        // Implement change
                      },
                    ),
                    SwitchListTile(
                      title: Text('화환'),
                      value: false,
                      onChanged: (bool value) {
                        // Implement change
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Save Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Implement save functionality
              },
              child: Text('저장'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
