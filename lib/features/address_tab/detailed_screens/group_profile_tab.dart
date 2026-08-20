import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/address_tab/detailed_screens/member_history_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupProfileTab extends ConsumerWidget {
  final String groupId;

  const GroupProfileTab({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // firstWhereOrNull을 사용하여 null 안전성 확보
    final group = ref.watch(addressBookProvider).groups.firstWhere(
          (group) => group.groupId == groupId,
          orElse: () => throw Exception('Group not found: $groupId'),
        );

    return ListView(
      children: [
        ListTile(
          title: Text('그룹 이름'),
          subtitle: Text(group.groupName),
        ),
        ListTile(
          title: Text('멤버 수'),
          subtitle: Text('${group.groupMemberCount}명'),
        ),
        const Divider(),
        ListTile(
          title: const Text('멤버 목록'),
        ),
        ...group.groupMembers.map((member) => ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                  '${member.groupMemberName} ${member.groupMemberPhoneNumber}'),
              subtitle: Text('${member.groupMemberMemo ?? '메모 없음'}'),
              // isThreeLine: true, // 3줄 표시를 위해 추가
            )),
      ],
    );
  }
}
