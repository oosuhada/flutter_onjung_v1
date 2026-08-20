import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onjung_v1/data/my_onjung_tab/event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 특정 이벤트를 조회하는 새로운 provider 생성
final selectedEventProvider = Provider.family<AsyncValue<Event>, String>(
  (ref, eventId) {
    final eventsAsyncValue = ref.watch(eventProvider);

    return eventsAsyncValue.when(
      data: (events) {
        final event = events.firstWhere(
          (event) => event.eventId == eventId,
          orElse: () => throw Exception('Event not found'),
        );
        return AsyncValue.data(event);
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
    );
  },
);

final eventProvider = FutureProvider<List<Event>>((ref) async {
  try {
    debugPrint('JSON 파일 로드 시작: assets/dummy_events.json');

    // JSON 파일 읽기
    final String response =
        await rootBundle.loadString('assets/dummy_events.json');
    debugPrint('JSON 파일 로드 성공: $response');

    // JSON 파싱
    final List<dynamic> data = json.decode(response);
    debugPrint('JSON 데이터 파싱 성공: $data');

    // JSON을 Event 객체로 변환
    final events = data.map((eventJson) {
      debugPrint('Event 변환 중: $eventJson');
      return Event.fromJson(eventJson);
    }).toList();
    debugPrint('Event 변환 완료: $events');

    return events;
  } catch (e, stackTrace) {
    debugPrint('JSON 파일 로드 또는 변환 실패: $e');
    debugPrint('스택 트레이스: $stackTrace');
    rethrow;
  }
});
