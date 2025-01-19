// lib/features/my_onjung_tab/screens/guest_management_screen.dart
import 'package:flutter/material.dart';

class Guest {
  final String name;
  final String relation;
  final bool isAttending;
  final int amount;

  Guest({
    required this.name,
    required this.relation,
    required this.isAttending,
    required this.amount,
  });
}

class GuestManagementScreen extends StatefulWidget {
  const GuestManagementScreen({Key? key}) : super(key: key);

  @override
  State<GuestManagementScreen> createState() => _GuestManagementScreenState();
}

class _GuestManagementScreenState extends State<GuestManagementScreen> {
  final List<Guest> guests = [
    Guest(name: '김민수', relation: '회사 동료', isAttending: true, amount: 50000),
    Guest(name: '이지원', relation: '친구', isAttending: false, amount: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게스트 관리'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddGuestDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: guests.length,
        itemBuilder: (context, index) {
          final guest = guests[index];
          return ListTile(
            title: Text(guest.name),
            subtitle: Text(guest.relation),
            trailing: Text(
              guest.isAttending ? '참석 - ${guest.amount.toString()}원' : '미정',
            ),
            onTap: () => _showEditGuestDialog(context, index),
          );
        },
      ),
    );
  }

  Future<void> _showAddGuestDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController relationController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('게스트 추가'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: relationController,
              decoration: const InputDecoration(labelText: '관계'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              // Add guest logic here
              Navigator.pop(context);
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditGuestDialog(BuildContext context, int index) async {
    // Similar to add dialog but with pre-filled values
  }
}
