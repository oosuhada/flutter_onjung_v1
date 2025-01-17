import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventExpense {
  String recipient = '';
  int amount = 0;
  String eventType = '';
  DateTime date = DateTime.now();
  String visitStatus = '';
  String gift = '';
  String memo = '';
  String contact = '';
}

class EventExpenseNotifier extends StateNotifier<EventExpense> {
  EventExpenseNotifier() : super(EventExpense());

  void updateAmount(int newAmount) {
    state = state..amount = newAmount;
  }

  void updateRecipient(String recipient) {
    state = state..recipient = recipient;
  }

  // 추가 업데이트 함수들...
}

final eventExpenseProvider =
    StateNotifierProvider<EventExpenseNotifier, EventExpense>(
        (ref) => EventExpenseNotifier());
