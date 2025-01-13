import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/address_tab/detailed_screens/member_history_tab.dart';
import 'package:flutter_onjung_v1/features/address_tab/main_screen_components/personal_header_section.dart';
import 'package:flutter_onjung_v1/features/address_tab/main_screen_components/personal_list_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalTab extends ConsumerStatefulWidget {
  const PersonalTab({Key? key}) : super(key: key);

  @override
  ConsumerState<PersonalTab> createState() => _PersonalTabState();
}

class _PersonalTabState extends ConsumerState<PersonalTab> {
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
        PersonalHeaderSection(
          nickname: addressBook.nickname,
          totalContacts: addressBook.members.length,
          sortOption: _sortOption,
          onSortChanged: _onSortChanged,
        ),
        Expanded(
          child: PersonalListSection(sortOption: _sortOption),
        ),
      ],
    );
  }
}
