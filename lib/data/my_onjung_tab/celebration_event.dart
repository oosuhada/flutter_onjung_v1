// lib/features/my_onjung_tab/models/celebration_event.dart
class CelebrationEvent {
  final String title;
  final DateTime date;
  final int amount;
  final String imageUrl;
  final int guestCount;

  CelebrationEvent({
    required this.title,
    required this.date,
    required this.amount,
    required this.imageUrl,
    required this.guestCount,
  });
}
