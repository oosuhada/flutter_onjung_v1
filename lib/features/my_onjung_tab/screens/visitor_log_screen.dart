import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/providers/event_provider.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/widgets/visitor_log_drawer_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisitorLogScreen extends ConsumerWidget {
  final String eventId;

  const VisitorLogScreen({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(selectedEventProvider(eventId));
    final searchController = TextEditingController();
    final searchQueryProvider = StateProvider<String>((ref) => '');

    return eventAsync.when(
      data: (event) {
        // Watch the search query
        final searchQuery = ref.watch(searchQueryProvider);

        // Filter guests based on search query
        final filteredGuests = event.guestDetails.where((guest) {
          return guest.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('방문록'),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VisitorLogDrawerMenuScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: '이름으로 검색',
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
              Expanded(
                child: ListView.builder(
                  itemCount: filteredGuests.length,
                  itemBuilder: (context, index) {
                    final guest = filteredGuests[index];
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
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error loading event: $error')),
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
