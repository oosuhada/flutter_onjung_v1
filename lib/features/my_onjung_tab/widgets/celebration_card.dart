import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/my_onjung_tab/event.dart';
import 'package:intl/intl.dart';

class CelebrationCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const CelebrationCard({
    Key? key,
    required this.event,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,###');

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                event.imageUrl.isNotEmpty
                    ? event.imageUrl
                    : 'assets/default_event_image.png',
                height: 110, // 이미지 높이 조정
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint(
                      'Error loading image: ${event.imageUrl}, Error: $error');
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image,
                          size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18, // 타이틀 크기 축소
                        ),
                    overflow: TextOverflow.ellipsis, // 한 줄 넘어가면 ...으로 표시
                    maxLines: 2,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '날짜: ${event.date.toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '금액: ${currencyFormat.format(event.totalAmount)}원',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '참석자: ${event.guestCount}명',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
