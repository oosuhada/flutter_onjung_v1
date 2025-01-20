// providers/calendar_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/%08shared/unified_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

final calendarProvider = ChangeNotifierProvider((ref) => CalendarProvider());

class CalendarProvider extends ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final Map<DateTime, List<UnifiedTransaction>> _events = {};
  String? _nickname = '르탄이';
  String? get nickname => _nickname;

  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  CalendarFormat get calendarFormat => _calendarFormat;

  void setNickname(String nickname) {
    if (_nickname != nickname) {
      _nickname = nickname;
      notifyListeners();
    }
  }

  MonthlyStats getMonthlyStats() {
    debugPrint('📊 월간 통계 계산 시작');
    debugPrint('📅 기준 월: ${_focusedDay.year}년 ${_focusedDay.month}월');

    // 닉네임이 null인 경우 빈 통계 반환
    if (_nickname == null) {
      debugPrint('⚠️ 닉네임이 null입니다. 빈 통계 반환');
      return MonthlyStats(
        sentCount: 0,
        receivedCount: 0,
        sentAmount: 0,
        receivedAmount: 0,
      );
    }

    // 현재 선택된 월의 모든 거래 필터링
    final currentMonthTransactions = _events.entries
        .where((entry) =>
            entry.key.year == _focusedDay.year &&
            entry.key.month == _focusedDay.month)
        .expand((entry) => entry.value)
        .toList();

    debugPrint('📈 이번 달 총 거래 수: ${currentMonthTransactions.length}');
    for (var transaction in currentMonthTransactions) {
      debugPrint('  🧾 거래: ${transaction.toJson()}');
    }

    // 보낸 거래와 받은 거래를 각각 필터링
    final sentTransactions = currentMonthTransactions
        .where((transaction) => transaction.type == 'sent')
        .toList();
    final receivedTransactions = currentMonthTransactions
        .where((transaction) => transaction.type == 'received')
        .toList();

    // 각 거래 수를 로그로 출력
    debugPrint('🔍 보낸 거래: ${sentTransactions.length}건');
    debugPrint('🔍 받은 거래: ${receivedTransactions.length}건');

    // 보낸 금액과 받은 금액 합계 계산
    final sentAmount = sentTransactions.fold(0, (sum, t) => sum + t.amount);
    final receivedAmount =
        receivedTransactions.fold(0, (sum, t) => sum + t.amount);

    // 금액 통계를 로그로 출력
    debugPrint('💰 금액 통계:');
    debugPrint('  - 보낸 금액: $sentAmount');
    debugPrint('  - 받은 금액: $receivedAmount');

    // 월간 통계 반환
    return MonthlyStats(
      sentCount: sentTransactions.length,
      receivedCount: receivedTransactions.length,
      sentAmount: sentAmount,
      receivedAmount: receivedAmount,
    );
  }

  List<DailyTransactionCount> getDailyTransactionCounts(DateTime date) {
    if (_nickname == null) {
      return [];
    }

    final transactions = _events[date] ?? []; // counterpart 체크 제거
    final sentCount = transactions.where((t) => t.type == 'sent').length;
    final receivedCount =
        transactions.where((t) => t.type == 'received').length;

    return [
      if (sentCount > 0) DailyTransactionCount(count: sentCount, type: 'sent'),
      if (receivedCount > 0)
        DailyTransactionCount(count: receivedCount, type: 'received'),
    ];
  }

  void updateEvents(List<UnifiedTransaction> transactions) {
    debugPrint('🔄 updateEvents 시작');

    // 거래 데이터를 날짜별로 그룹화
    final newEvents = <DateTime, List<UnifiedTransaction>>{};
    for (var transaction in transactions) {
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );

      if (!newEvents.containsKey(date)) {
        newEvents[date] = [];
      }
      newEvents[date]!.add(transaction);
    }

    // 디버그 출력: 새로운 이벤트 데이터
    debugPrint('🔄 새 이벤트 데이터:');
    newEvents.forEach((key, value) {
      debugPrint('📅 $key: ${value.length}건');
    });

    // 데이터를 강제로 덮어쓰기
    _events.clear();
    _events.addAll(newEvents);

    debugPrint('✅ 이벤트 데이터가 업데이트되었습니다: ${_events.length}개의 날짜');
    notifyListeners();
  }

  // focusedDay 업데이트 시 월 단위로 설정
  void updateFocusedDay(DateTime newFocusedDay) {
    // 새로운 날짜 설정
    _focusedDay =
        DateTime(newFocusedDay.year, newFocusedDay.month, newFocusedDay.day);

    debugPrint('📅 포커스 날짜 변경됨: $_focusedDay');

    // 포커스 날짜 변경 시 이벤트 데이터 업데이트
    _updateMonthEvents();
    notifyListeners();
  }

  void _updateMonthEvents() {
    if (_nickname == null) {
      debugPrint('⚠️ 닉네임이 null이므로 이벤트를 로드할 수 없습니다.');
      return;
    }

    debugPrint(
        '🔄 현재 포커스된 월 데이터를 로드합니다: ${_focusedDay.year}-${_focusedDay.month}');

    // 현재 월과 일치하는 이벤트 필터링
    final filteredEvents = <DateTime, List<UnifiedTransaction>>{};
    for (final entry in _events.entries) {
      final date = entry.key;

      // 포커스된 월과 동일한 데이터만 필터링
      if (date.year == _focusedDay.year && date.month == _focusedDay.month) {
        filteredEvents[date] = entry.value;
      }
    }

    // 기존 데이터와 필터링된 데이터 비교 후 업데이트
    if (_events.length != filteredEvents.length ||
        !_mapEquals(_events, filteredEvents)) {
      _events
        ..clear()
        ..addAll(filteredEvents);
      debugPrint('✅ 이벤트 데이터가 업데이트되었습니다. (${_events.length}일)');
    } else {
      debugPrint('⏭️ 기존 데이터와 동일합니다. 업데이트하지 않습니다.');
    }
  }

  // Map 비교 메서드 추가
  bool _mapEquals(Map<DateTime, List<UnifiedTransaction>> a,
      Map<DateTime, List<UnifiedTransaction>> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || !_listEquals(a[key], b[key])) {
        return false;
      }
    }
    return true;
  }

  bool _listEquals(List<UnifiedTransaction>? a, List<UnifiedTransaction>? b) {
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (_selectedDay != selectedDay || _focusedDay != focusedDay) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;

      // 로그 추가 (디버깅)
      debugPrint('Selected day: $_selectedDay, Focused day: $_focusedDay');

      notifyListeners(); // 안전한 호출
    }
  }

  void onFormatChanged(CalendarFormat format) {
    _calendarFormat = format;

    // 추가: 변경된 캘린더 형식을 사용한 작업 처리 로직
    debugPrint('Calendar format changed: $_calendarFormat');

    notifyListeners();
  }
}

class MonthlyStats {
  final int sentCount;
  final int receivedCount;
  final int sentAmount; // double -> int로 변경
  final int receivedAmount; // double -> int로 변경

  MonthlyStats({
    required this.sentCount,
    required this.receivedCount,
    required this.sentAmount,
    required this.receivedAmount,
  });
}

class DailyTransactionCount {
  final int count;
  final String type;

  DailyTransactionCount({
    required this.count,
    required this.type,
  });
  // 표시용 텍스트 getter 추가
  String get displayText => type == 'sent' ? '보냄' : '받음';
}
