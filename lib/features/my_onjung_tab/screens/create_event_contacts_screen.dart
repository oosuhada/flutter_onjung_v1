import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateEventContactsScreen extends StatefulWidget {
  final Map<String, dynamic> eventDetails;

  const CreateEventContactsScreen({
    Key? key,
    required this.eventDetails,
  }) : super(key: key);

  @override
  State<CreateEventContactsScreen> createState() =>
      _CreateEventContactsScreenState();
}

class _CreateEventContactsScreenState extends State<CreateEventContactsScreen> {
  List<Contact> contacts = [];
  List<Contact> selectedContacts = [];
  bool isLoading = true;
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoadContacts();
  }

  Future<void> _checkPermissionAndLoadContacts() async {
    final status = await Permission.contacts.status;
    if (status.isGranted) {
      _loadContacts();
    } else {
      setState(() {
        isLoading = false;
        hasPermission = false;
      });
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.contacts.request();
    if (status.isGranted) {
      setState(() {
        hasPermission = true;
      });
      _loadContacts();
    }
  }

  Future<void> _loadContacts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final Iterable<Contact> fetchedContacts =
          await ContactsService.getContacts();
      setState(() {
        contacts = fetchedContacts.toList();
        isLoading = false;
        hasPermission = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('연락처를 불러오는데 실패했습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('경조사 추가'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '초대할 인원을 파악해보세요',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '현재 선택 인원: ${selectedContacts.length}명',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildContactsList(),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildContactsList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!hasPermission) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('연락처 접근 권한이 필요합니다.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _requestPermission,
              child: const Text('권한 요청하기'),
            ),
          ],
        ),
      );
    }

    if (contacts.isEmpty) {
      return const Center(
        child: Text('연락처가 없습니다.'),
      );
    }

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final isSelected = selectedContacts.contains(contact);

        return CheckboxListTile(
          title: Text(contact.displayName ?? '이름 없음'),
          subtitle: Text(
            contact.phones?.isNotEmpty == true
                ? contact.phones!.first.value!
                : '번호 없음',
          ),
          value: isSelected,
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                selectedContacts.add(contact);
              } else {
                selectedContacts.remove(contact);
              }
            });
          },
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: selectedContacts.isNotEmpty
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateEventContactsScreen(
                        eventDetails: {
                          'eventType': widget.eventDetails['eventType'],
                          'eventName': widget.eventDetails['eventName'],
                          'eventDate': widget.eventDetails['eventDate'],
                        },
                      ),
                    ),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('완료'),
        ),
      ),
    );
  }
}
