// event_guide_page.dart
import 'package:flutter/material.dart';

class EventGuidePage extends StatelessWidget {
  const EventGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('경조사 길라잡이'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildGuideSection(
            title: '결혼식',
            content: '일반적으로 축의금은 5-10만원 선물이 적절합니다.',
          ),
          _buildGuideSection(
            title: '돌잔치',
            content: '일반적으로 3-5만원 선물이 적절합니다.',
          ),
          _buildGuideSection(
            title: '장례식',
            content: '일반적으로 조의금은 3-5만원 선물이 적절합니다.',
          ),
        ],
      ),
    );
  }

  Widget _buildGuideSection({required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
