// group_list_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/%08shared/group.dart';
import 'package:flutter_onjung_v1/features/address_tab/detailed_screens/group_detail_screen.dart';
import 'package:flutter_onjung_v1/features/address_tab/detailed_screens/member_history_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupListSection extends ConsumerWidget {
  final String sortOption;

  const GroupListSection({
    Key? key,
    required this.sortOption,
  }) : super(key: key);

  void _sortGroups(List<SocialGroup> groups, String sortOption) {
    switch (sortOption) {
      case 'name':
        groups.sort((a, b) => a.groupName.compareTo(b.groupName));
        break;
      case 'date':
        groups.sort((a, b) => b.groupCreatedDate.compareTo(a.groupCreatedDate));
        break;
      case 'memberCount':
        groups.sort((a, b) => b.groupMemberCount.compareTo(a.groupMemberCount));
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressBook = ref.watch(addressBookProvider);
    debugPrint('🏗️ GroupListSection building...');
    debugPrint('📚 Total groups in addressBook: ${addressBook.groups.length}');

    if (!addressBook.isInitialized) {
      debugPrint('⏳ AddressBook not initialized yet');
      return const Center(child: CircularProgressIndicator());
    }
// 특정 닉네임에 속한 그룹 필터링
    final filteredGroups = addressBook.groups.where((group) {
      final hasMember = group.groupMembers.any((member) =>
          member.groupMemberName.trim().toLowerCase() ==
          addressBook.nickname.trim().toLowerCase());

      debugPrint(
          '🔍 Checking group ${group.groupName} - Has member: $hasMember');
      return hasMember;
    }).toList();

    debugPrint('🎯 Filtered groups count: ${filteredGroups.length}');

    if (filteredGroups.isEmpty) {
      debugPrint('⚠️ No groups found for user ${addressBook.nickname}');
      return const Center(
        child: Text('소속된 그룹이 없습니다.'),
      );
    }

    return ListView.separated(
      itemCount: filteredGroups.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final group = filteredGroups[index];
        final totalInteractions = group.recentGroupTransactions.length;
        final recentInteraction = group.recentGroupTransactions.isNotEmpty
            ? group.recentGroupTransactions.first.groupTransactionDate
                .toLocal()
                .toString()
                .split(' ')[0]
            : '없음';

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.group, color: Colors.grey),
          ),
          title: Text(
            group.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '멤버 ${group.groupMemberCount}명 • 총 ${totalInteractions}회 교류 • 최근 교류: $recentInteraction',
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupDetailScreen(
                  groupId: group.groupId,
                  transactions: group.recentGroupTransactions,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
