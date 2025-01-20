import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/screens/create_event_details_screen.dart';
import 'package:go_router/go_router.dart';

class CreateEventTypeScreen extends StatelessWidget {
  const CreateEventTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('경조사 추가'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '어떤 경조사인가요?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildEventTypeButton(
              context: context,
              title: '결혼식',
              onTap: () => _navigateToEventDetails(context, '결혼식'),
            ),
            _buildEventTypeButton(
              context: context,
              title: '장례식',
              onTap: () => _navigateToEventDetails(context, '장례식'),
            ),
            _buildEventTypeButton(
              context: context,
              title: '돌잔치',
              onTap: () => _navigateToEventDetails(context, '돌잔치'),
            ),
            _buildEventTypeButton(
              context: context,
              title: '기타(직접입력)',
              onTap: () => _navigateToEventDetails(context, '기타'),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '예시: 환갑, 칠순 잔치',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTypeButton({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEventDetails(BuildContext context, String eventType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEventDetailsScreen(eventType: eventType),
      ),
    );
  }
}
