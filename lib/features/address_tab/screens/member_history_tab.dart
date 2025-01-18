// member_history_tab.dart
import 'package:flutter/material.dart';

class MemberHistoryTab extends StatelessWidget {
  const MemberHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // 추후 데이터 연동
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    Text('상세내역', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Row(
                children: [
                  const Text('경조 | 인졸'),
                  const Spacer(),
                  Text('50,000원',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              subtitle: Row(
                children: [
                  Text('2025.01.10', style: TextStyle(color: Colors.grey[600])),
                  const Spacer(),
                  Icon(Icons.arrow_forward, color: Colors.grey[400], size: 16),
                ],
              ),
            ),
            const Divider(height: 1),
          ],
        );
      },
    );
  }
}
