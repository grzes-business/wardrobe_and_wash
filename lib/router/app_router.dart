import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../views/wardrobe_view.dart';
import '../views/today_view.dart';
import '../views/wash_view.dart';
import '../views/clothing_view.dart';
import '../views/add_clothing_view.dart';
import '../views/wash_details_view.dart';

final GoRouter router = GoRouter(
  initialLocation: '/wardrobe',
  routes: [

    GoRoute(
      path: '/wardrobe',
      name: 'wardrobe',
      pageBuilder: (context, state) => _buildMainPageWithNoSwipe(
        key: state.pageKey,
        child: const WardrobeView(),
      ),
    ),
    GoRoute(
      path: '/today',
      name: 'today',
      pageBuilder: (context, state) => _buildMainPageWithNoSwipe(
        key: state.pageKey,
        child: const TodayView(),
      ),
    ),
    GoRoute(
      path: '/wash',
      name: 'wash',
      pageBuilder: (context, state) => _buildMainPageWithNoSwipe(
        key: state.pageKey,
        child: const WashView(),
      ),
    ),
    

    GoRoute(
      path: '/clothing/:id',
      name: 'clothing_detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ClothingView(clothingId: id);
      },
    ),
    GoRoute(
      path: '/add-clothing',
      name: 'add_clothing',
      builder: (context, state) => const AddClothingView(),
    ),
    GoRoute(
      path: '/wash-details/:id',
      name: 'wash_details',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return WashDetailsView(washPlanId: id);
      },
    ),
    GoRoute(
      path: '/wash-details/new',
      name: 'new_wash_details',
      builder: (context, state) => const WashDetailsView(),
    ),
  ],
);
Page<void> _buildMainPageWithNoSwipe({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
  
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}