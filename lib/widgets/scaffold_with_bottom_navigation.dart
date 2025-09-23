import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

class ScaffoldWithBottomNavigation extends StatelessWidget {
  final Widget body;
  final String currentRoute;
  final AppBar? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const ScaffoldWithBottomNavigation({
    super.key,
    required this.body,
    required this.currentRoute,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: BottomNavigation(currentRoute: currentRoute),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}