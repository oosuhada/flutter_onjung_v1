// lib/features/onjung_tab/screens/onjung_tab_screen.dart
import 'package:flutter/material.dart';

class OnjungTabScreen extends StatelessWidget {
  const OnjungTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('온정'),
      ),
      body: const Center(
        child: Text('온정 화면'),
      ),
    );
  }
}
