import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/%08shared/member.dart';
import 'package:flutter_onjung_v1/features/address_tab/detailed_screens/member_history_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemberProfileTab extends ConsumerWidget {
  final String counterpartId;

  const MemberProfileTab({
    Key? key,
    required this.counterpartId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AddressBookProvider에서 데이터 가져오기
    final addressBook = ref.watch(addressBookProvider);

    // 해당 counterpartId에 대한 정보를 가져오기
    final member = addressBook.members.firstWhere(
      (member) => member.id == counterpartId,
      orElse: () => Member(
        id: counterpartId,
        name: '알 수 없음',
        registeredDate: DateTime.now(),
        relationship: Relationship.other,
        relationDetail: '',
        transactions: [],
      ),
    );

    return ListView(
      children: [
        const SizedBox(height: 16),
        _buildSection(
          title: '기본 정보',
          children: [
            _buildInfoRow('이름', member.name),
            _buildInfoRow('관계', _getRelationshipString(member.relationship)),
            _buildInfoRow('상세 관계', member.relationDetail ?? '정보 없음'),
            _buildInfoRow(
              '등록 날짜',
              '${member.registeredDate.year}년 ${member.registeredDate.month}월 ${member.registeredDate.day}일',
            ),
          ],
        ),
        _buildSection(
          title: '거래 내역',
          children: member.transactions.map((transaction) {
            return _buildInfoRow(
              transaction.label,
              '${transaction.amount}원 (${transaction.type == "sent" ? "보냄" : "받음"})',
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRelationshipString(Relationship relationship) {
    switch (relationship) {
      case Relationship.family:
        return '가족';
      case Relationship.friend:
        return '친구';
      case Relationship.coworker:
        return '동료';
      default:
        return '기타';
    }
  }
}
