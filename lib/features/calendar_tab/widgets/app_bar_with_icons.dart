// widgets/app_bar_with_icons.dart
import 'package:flutter/material.dart';

class AppBarWithIcons extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('온정부'),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Implement search functionality
          },
        ),
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            // Implement notifications functionality
          },
        ),
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Implement menu functionality
          },
        ),
      ],
    );
  }
}
