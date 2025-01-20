// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CreateEventScreen extends StatefulWidget {
//   const CreateEventScreen({Key? key}) : super(key: key);

//   @override
//   State<CreateEventScreen> createState() => _CreateEventScreenState();
// }

// class _CreateEventScreenState extends State<CreateEventScreen> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime selectedDate = DateTime.now();
//   List<Contact> contacts = [];
//   List<Contact> selectedContacts = [];

//   @override
//   void initState() {
//     super.initState();
//     _requestContactsPermission();
//   }

//   Future<void> _requestContactsPermission() async {
//     final status = await Permission.contacts.request();
//     if (status.isGranted) {
//       _loadContacts();
//     } else {
//       // 권한이 거부된 경우 처리
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('연락처 접근 권한이 필요합니다.')),
//       );
//     }
//   }

//   Future<void> _loadContacts() async {
//     try {
//       final Iterable<Contact> fetchedContacts =
//           await ContactsService.getContacts();
//       setState(() {
//         contacts = fetchedContacts.toList();
//       });
//     } catch (e) {
//       print('연락처 로드 실패: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('새 경조사 추가'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: '경조사 이름',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '경조사 이름을 입력해주세요';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               ListTile(
//                 title: Text('날짜: ${selectedDate.toString().split(' ')[0]}'),
//                 trailing: const Icon(Icons.calendar_today),
//                 onTap: () => _selectDate(context),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 '초대할 인원을 선택하세요:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               contacts.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: contacts.length,
//                       itemBuilder: (context, index) {
//                         final contact = contacts[index];
//                         final isSelected = selectedContacts.contains(contact);

//                         return CheckboxListTile(
//                           title: Text(contact.displayName ?? '이름 없음'),
//                           subtitle: Text(contact.phones?.isNotEmpty == true
//                               ? contact.phones!.first.value!
//                               : '번호 없음'),
//                           value: isSelected,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               if (value == true) {
//                                 selectedContacts.add(contact);
//                               } else {
//                                 selectedContacts.remove(contact);
//                               }
//                             });
//                           },
//                         );
//                       },
//                     ),
//               const SizedBox(height: 32),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       // 저장 로직
//                       print(
//                           '선택된 연락처: ${selectedContacts.map((e) => e.displayName).toList()}');
//                       context.pop();
//                     }
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     child: Text('저장하기'),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }
// }
