import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/providers/event_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuestManagementScreen extends ConsumerWidget {
  final String eventId;

  const GuestManagementScreen({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(selectedEventProvider(eventId));

    return eventAsync.when(
      data: (event) => Scaffold(
        appBar: AppBar(
          title: const Text('초대 명단 관리'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    '${event.guestDetails.where((guest) => guest.isAttending).length}명',
                    '참석 예정',
                  ),
                  _buildStatCard(
                    '${event.guestDetails.where((guest) => guest.hasCompanion).length}명',
                    '동반인원 포함',
                  ),
                  _buildStatCard(
                    '${event.guestDetails.where((guest) => guest.needsMeal).length}명',
                    '식사 예정',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // 구성원 초대하기 동작 구현
              },
              child: const Text(
                '구성원 초대하기',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // 초대장 제작 추천 동작 구현
              },
              child: const Text('초대장 제작 추천'),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '초대장 내 부문 여부, 식사 여부, 차량 여부, 동행 인원 수\n미리 확인해서 동행 초대 명단 만든 후 업체에 전달',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '검색어를 입력하세요',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterChip('전체', true),
                const SizedBox(width: 8),
                _buildFilterChip('참석', false),
                const SizedBox(width: 8),
                _buildFilterChip('미참석', false),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: event.guestDetails.length,
                itemBuilder: (context, index) {
                  final guest = event.guestDetails[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      title: Text(guest.name),
                      subtitle: Text(
                        '연락처: ${guest.phoneNumber ?? "미입력"} | 관계: ${guest.relationToHost}',
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          if (guest.needsMeal)
                            _buildTag('식사', Colors.green[100]!),
                          if (guest.hasVehicleRegistered)
                            _buildTag('차량 등록', Colors.blue[100]!),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error loading event: $error')),
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        // 필터 선택 로직 구현
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.black,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

// // lib/features/my_onjung_tab/screens/guest_management_screen.dart
// import 'package:flutter/material.dart';

// class Guest {
//   final String name;
//   final String relation;
//   final bool isAttending;
//   final int amount;

//   Guest({
//     required this.name,
//     required this.relation,
//     required this.isAttending,
//     required this.amount,
//   });
// }

// class GuestManagementScreen extends StatefulWidget {
//   const GuestManagementScreen({Key? key}) : super(key: key);

//   @override
//   State<GuestManagementScreen> createState() => _GuestManagementScreenState();
// }

// class _GuestManagementScreenState extends State<GuestManagementScreen> {
//   final List<Guest> guests = [
//     Guest(name: '김민수', relation: '회사 동료', isAttending: true, amount: 50000),
//     Guest(name: '이지원', relation: '친구', isAttending: false, amount: 0),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('게스트 관리'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => _showAddGuestDialog(context),
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: guests.length,
//         itemBuilder: (context, index) {
//           final guest = guests[index];
//           return ListTile(
//             title: Text(guest.name),
//             subtitle: Text(guest.relation),
//             trailing: Text(
//               guest.isAttending ? '참석 - ${guest.amount.toString()}원' : '미정',
//             ),
//             onTap: () => _showEditGuestDialog(context, index),
//           );
//         },
//       ),
//     );
//   }

//   Future<void> _showAddGuestDialog(BuildContext context) async {
//     final TextEditingController nameController = TextEditingController();
//     final TextEditingController relationController = TextEditingController();

//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('게스트 추가'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: '이름'),
//             ),
//             TextField(
//               controller: relationController,
//               decoration: const InputDecoration(labelText: '관계'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('취소'),
//           ),
//           TextButton(
//             onPressed: () {
//               // Add guest logic here
//               Navigator.pop(context);
//             },
//             child: const Text('추가'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _showEditGuestDialog(BuildContext context, int index) async {
//     // Similar to add dialog but with pre-filled values
//   }
// }
