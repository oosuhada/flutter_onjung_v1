import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_onjung_v1/data/%08shared/member.dart';
import 'package:go_router/go_router.dart';

class PersonalListSection extends StatefulWidget {
  final String sortOption;

  const PersonalListSection({
    Key? key,
    required this.sortOption,
  }) : super(key: key);

  @override
  PersonalListSectionState createState() => PersonalListSectionState();
}

class PersonalListSectionState extends State<PersonalListSection> {
  List<dynamic> _personalData = [];

  @override
  void initState() {
    super.initState();
    _loadPersonalData();
  }

// personal_list_section.dart 수정
  void _loadPersonalData() async {
    try {
      final String jsonString = await rootBundle
          .loadString('assets/dummy_transactions_personal.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> allTransactions = jsonData['transactions'];

      final Map<String, List<dynamic>> groupedTransactions = {};
      // List로 변환하여 순서 보장
      final List<String> counterpartsList = [];

      for (var transaction in allTransactions) {
        final counterpart = transaction['counterpart'];
        if (!groupedTransactions.containsKey(counterpart)) {
          groupedTransactions[counterpart] = [];
          counterpartsList.add(counterpart); // List에 추가
        }
        groupedTransactions[counterpart]!.add(transaction);
      }

      final List<Map<String, dynamic>> processedData =
          groupedTransactions.entries.map((entry) {
        final firstTransaction = entry.value.first;
        final counterpartId = entry.value.first['id']; // 고유 ID 사용

        return {
          'counterpartId': counterpartId, // counterpartId로 변경
          'counterpart': entry.key,
          'relation': firstTransaction['relation'],
          'relation_detail': firstTransaction['relation_detail'],
          'date': entry.value.map((t) => t['date']).reduce(
              (a, b) => DateTime.parse(a).isAfter(DateTime.parse(b)) ? a : b),
          'transactions': entry.value,
          'registered_date': firstTransaction['date'],
        };
      }).toList();

      setState(() {
        _personalData = processedData;
        _sortPersonalData();
      });

      // 디버그용 - 생성된 데이터 확인
      for (var data in processedData) {
        debugPrint('Counterpart: ${data['counterpart']}, ID: ${data['id']}');
      }
    } catch (e) {
      debugPrint('Error loading personal data: $e');
    }
  }

  Map<String, int> calculateTransactionCounts(List<dynamic> transactions) {
    int sent = 0;
    int received = 0;

    for (var transaction in transactions) {
      if (transaction['type'] == 'sent') {
        sent++;
      } else if (transaction['type'] == 'received') {
        received++;
      }
    }

    return {
      'total': transactions.length,
      'sent': sent,
      'received': received,
    };
  }

  void _sortPersonalData() {
    setState(() {
      if (widget.sortOption == 'name') {
        _personalData.sort((a, b) =>
            (a['counterpart'] ?? '').compareTo(b['counterpart'] ?? ''));
      } else if (widget.sortOption == 'date') {
        _personalData.sort((a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
      }
    });
  }

  @override
  void didUpdateWidget(PersonalListSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sortOption != widget.sortOption) {
      _sortPersonalData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _personalData.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final data = _personalData[index];
        final transactions = data['transactions'] as List? ?? [];
        final counts = calculateTransactionCounts(transactions);

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.grey),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // 수직 방향 정렬
            children: [
              Text(
                data['counterpart'] ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data['relation'] ?? '기타',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '총 ${counts['total']}회',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '보냄 ${counts['sent']}회',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '받음 ${counts['received']}회',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '최근 교류: ${data['date'] ?? 'Unknown'}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          isThreeLine: true,
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            final counterpartId = data['counterpartId'] as String; // 고유 ID
            final transactions = data['transactions'] as List;

            // GoRouter를 사용해 AppRoute enum으로 경로 지정
            context.push(
              AppRoute.addressMemberDetail.path, // AppRoute enum 활용
              extra: {
                'counterpartId': counterpartId,
                'transactions': transactions,
              },
            );
          },
        );
      },
    );
  }

  Relationship stringToRelationship(String relation) {
    switch (relation) {
      case '가족':
        return Relationship.family;
      case '친구':
        return Relationship.friend;
      case '동료':
        return Relationship.coworker;
      default:
        return Relationship.other;
    }
  }
}
