import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/address_tab/detailed_screens/member_history_tab.dart';
import 'package:flutter_onjung_v1/features/address_tab/main_screen_components/group_header_section.dart';
import 'package:flutter_onjung_v1/features/address_tab/main_screen_components/group_list_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupTab extends ConsumerStatefulWidget {
  const GroupTab({Key? key}) : super(key: key);

  @override
  ConsumerState<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends ConsumerState<GroupTab> {
  String _sortOption = 'name';

  void _onSortChanged(String sortOption) {
    setState(() {
      _sortOption = sortOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressBook = ref.watch(addressBookProvider);

    return Column(
      children: [
        GroupHeaderSection(
          nickname: addressBook.nickname,
          totalGroups:
              addressBook.getTotalGroupsForNickname(addressBook.nickname),
          sortOption: _sortOption,
          onSortChanged: _onSortChanged,
        ),
        Expanded(
          child: GroupListSection(sortOption: _sortOption),
        ),
      ],
    );
  }
}
