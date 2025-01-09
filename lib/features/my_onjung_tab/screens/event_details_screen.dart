import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/providers/event_provider.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/screens/guest_management_screen.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/screens/visitor_log_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventDetailsScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsyncValue = ref.watch(selectedEventProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: eventAsyncValue.when(
          data: (event) => Text(event.title),
          loading: () => const Text('로딩중...'),
          error: (_, __) => const Text('오류 발생'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: eventAsyncValue.when(
        data: (event) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${event.guestCount}명 참여중',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuItem(
                '초대 명단',
                '모든 구성원의 초대 명단을 통합해보세요',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuestManagementScreen(
                        eventId: event.eventId,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildMenuItem(
                '축의 전자장부',
                '수기장부 이미지 또는 엑셀을 업로드하여\n언제 어디서나 쉽게 확인할 수 있는\n디지털 장부를 만들어보세요',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisitorLogScreen(
                        eventId: event.eventId,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSmallMenuItem(
                      '통계',
                      onTap: () {
                        // 통계 페이지로 이동
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSmallMenuItem(
                      '방명록',
                      onTap: () {
                        // 방명록 페이지로 이동
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('데이터 로드 실패: $error'),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, String subtitle,
      {required VoidCallback onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
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
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallMenuItem(String title, {required VoidCallback onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
