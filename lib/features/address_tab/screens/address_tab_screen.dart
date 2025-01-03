// lib/features/address_tab/screens/address_tab_screen.dart
import 'package:flutter/material.dart';

class AddressTabScreen extends StatelessWidget {
  const AddressTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주소록'),
      ),
      body: const Center(
        child: Text('주소록 화면'),
      ),
    );
  }
}
