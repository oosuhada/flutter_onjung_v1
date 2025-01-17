import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatisticsMessageHelper {
  final List<Map<String, dynamic>> _transactions = [];
  final Map<String, String> _userProfiles = {};
  final List<String> ageGroups = ['20대', '30대', '40대', '50대', '60대'];
  final List<String> relations = ['가족', '친구', '지인', '직장 동료'];
  final List<String> labels = ['결혼식', '생일', '장례식', '환갑', '집들이', '돌잔치'];

  Future<void> loadData({
    required String transactionFilePath,
    required String userProfileFilePath,
  }) async {
    try {
      final transactionString =
          await rootBundle.loadString(transactionFilePath);
      final transactionData = json.decode(transactionString) as List;

      for (var userData in transactionData) {
        if (userData['transactions'] != null) {
          final transactions = userData['transactions'] as List;
          _transactions.addAll(transactions.cast<Map<String, dynamic>>());
        }
      }

      final userProfileString =
          await rootBundle.loadString(userProfileFilePath);
      final profiles = json.decode(userProfileString) as List;

      for (var profile in profiles) {
        _userProfiles[profile['nickname']] = profile['age_group'];
      }

      debugPrint('Loaded transactions: ${_transactions.length}');
      debugPrint('Loaded profiles: ${_userProfiles.length}');
    } catch (e) {
      debugPrint('데이터 로드 중 오류 발생: $e');
      rethrow;
    }
  }

  List<String> generateMessages({
    String? ageGroup,
    String? relation,
    String? label,
  }) {
    try {
      final filteredData = _transactions.where((transaction) {
        final counterpartProfile = _userProfiles[transaction['counterpart']];

        final matchesAgeGroup =
            ageGroup == null || counterpartProfile == ageGroup;
        final matchesRelation =
            relation == null || transaction['relation'] == relation;
        final matchesLabel = label == null || transaction['label'] == label;

        return matchesAgeGroup && matchesRelation && matchesLabel;
      }).toList();

      debugPrint('Filtered data count: ${filteredData.length}');

      if (filteredData.isEmpty) {
        return [];
      }

      final totalAmount = filteredData.fold<int>(
        0,
        (sum, transaction) => sum + (transaction['amount'] as int),
      );
      final averageAmount = (totalAmount / filteredData.length).round();

      final formattedAmount = _formatCurrency(averageAmount);
      return [
        '${ageGroup ?? "전체 연령대"}는 ${relation ?? "모든 관계"}의 ${label ?? "모든 경조사"}에 평균 $formattedAmount를 보내고 있어요.'
      ];
    } catch (e) {
      debugPrint('메시지 생성 중 오류 발생: $e');
      return [];
    }
  }

  List<String> filterMessages() {
    final List<String> allMessages = [];

    // 각 연령대에 대해 메시지를 생성
    for (var ageGroup in ageGroups) {
      for (var relation in [null, ...relations]) {
        for (var label in [null, ...labels]) {
          final messages = generateMessages(
            ageGroup: ageGroup,
            relation: relation,
            label: label,
          );

          if (messages.isNotEmpty) {
            allMessages.addAll(messages);
          }
        }
      }
    }

    // 전체 데이터(연령대 필터링 없음)에 대한 메시지 추가
    for (var relation in [null, ...relations]) {
      for (var label in [null, ...labels]) {
        final messages = generateMessages(
          relation: relation,
          label: label,
        );

        if (messages.isNotEmpty) {
          allMessages.addAll(messages);
        }
      }
    }

    debugPrint('Filtered messages count: ${allMessages.length}');
    return allMessages;
  }

  String getRandomMessage() {
    final filteredMessages = filterMessages();

    if (filteredMessages.isEmpty) {
      return '생성된 메시지가 없습니다.';
    }

    final randomIndex = Random().nextInt(filteredMessages.length);
    return filteredMessages[randomIndex];
  }

  String _formatCurrency(int amount) {
    return '${amount.toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')}원';
  }
}
