import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/%08shared/widgets/bottom_navigation_bar.dart';
import 'package:flutter_onjung_v1/data/%08my_onjung_tab/celebration_event.dart';
import 'package:go_router/go_router.dart';

import '../widgets/celebration_card.dart';

class MyOnjungTabScreen extends StatelessWidget {
  final List<CelebrationEvent> events = [
    CelebrationEvent(
      title: '민수 & 예은',
      date: DateTime(2025, 1, 1),
      amount: 36350000,
      imageUrl: 'wedding_hall_image_url',
      guestCount: 156,
    ),
    // Add more sample events as needed
  ];

  MyOnjungTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 온정'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Implement notifications functionality
            },
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: events.length + 1, // +1 for the add new event card
        itemBuilder: (context, index) {
          if (index == events.length) {
            return Card(
              margin: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  // Navigate to create new event screen
                  context.push('/onjung/create');
                },
                child: const SizedBox(
                  height: 100,
                  child: Center(
                    child: Icon(
                      Icons.add_circle_outline,
                      size: 40,
                    ),
                  ),
                ),
              ),
            );
          }

          return CelebrationCard(
            event: events[index],
            onTap: () {
              // Navigate to event details screen
              context.push('/onjung/event/${index}');
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/address');
              break;
            case 2:
              context.go('/calendar');
              break;
            case 3:
              context.go('/myOnjung');
              break;
          }
        },
      ),
    );
  }
}
