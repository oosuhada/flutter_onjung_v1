// lib/providers/address_book_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_onjung_v1/data/address_book_tab/group.dart';
import 'package:flutter_onjung_v1/data/address_book_tab/member.dart';

class AddressBookProvider with ChangeNotifier {
  List<Member> _members = [];
  List<Group> _groups = [];

  List<Member> get members => [..._members];
  List<Group> get groups => [..._groups];

  void addMember(Member member) {
    _members.add(member);
    notifyListeners();
  }

  void addGroup(Group group) {
    _groups.add(group);
    notifyListeners();
  }
}
