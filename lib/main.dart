import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'services/hive_service.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive database
  await HiveService.init();
  
  // Check and reset today set if needed
  await HiveService.checkAndResetTodaySet();
  
  runApp(
    const ProviderScope(
      child: WardrobeWashApp(),
    ),
  );
}

class WardrobeWashApp extends StatelessWidget {
  const WardrobeWashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wardrobe & Wash',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
      // Disable the back button behavior on iOS that enables swipe gestures
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // Remove focus from any text fields when tapping outside
            FocusScope.of(context).unfocus();
          },
          child: child,
        );
      },
    );
  }
}
