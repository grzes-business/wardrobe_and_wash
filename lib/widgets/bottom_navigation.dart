import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigation extends StatelessWidget {
  final String currentRoute;

  const BottomNavigation({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(),
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.wb_sunny),
          label: 'Today',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.checkroom),
          label: 'Wardrobe',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_laundry_service),
          label: 'Wash',
        ),
      ],
    );
  }

  int _getCurrentIndex() {
    switch (currentRoute) {
      case '/today':
        return 0;
      case '/wardrobe':
        return 1;
      case '/wash':
        return 2;
      default:
        return 1; // Default to wardrobe
    }
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/today');
        break;
      case 1:
        context.go('/wardrobe');
        break;
      case 2:
        context.go('/wash');
        break;
    }
  }
}