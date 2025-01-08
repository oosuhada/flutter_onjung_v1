// lib/features/my_onjung_tab/screens/event_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/data/%08my_onjung_tab/celebration_event.dart';

class EventDetailsScreen extends StatelessWidget {
  final CelebrationEvent event;

  const EventDetailsScreen({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(event.title),
          bottom: const TabBar(
            tabs: [
              Tab(text: '전체'),
              Tab(text: '참석'),
              Tab(text: '미참석'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGuestList(context, 'all'),
            _buildGuestList(context, 'attending'),
            _buildGuestList(context, 'not_attending'),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestList(BuildContext context, String filter) {
    return ListView.builder(
      itemCount: 10, // Replace with actual guest list count
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('게스트 ${index + 1}'),
          subtitle: Text('참석 여부: ${filter == "attending" ? "참석" : "미정"}'),
          trailing: Text('축의금: 50,000원'),
        );
      },
    );
  }
}
