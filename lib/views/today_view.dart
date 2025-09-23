import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/clothing_provider.dart';
import '../widgets/scaffold_with_bottom_navigation.dart';
import '../widgets/clothing_card.dart';

class TodayView extends HookConsumerWidget {
  const TodayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayClothing = ref.watch(todayClothingProvider);
    final clothingNotifier = ref.watch(clothingNotifierProvider.notifier);

    return ScaffoldWithBottomNavigation(
      currentRoute: '/today',
      body: todayClothing.isEmpty
          ? const _EmptyTodayState()
          : Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Outfit',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${todayClothing.length} item${todayClothing.length != 1 ? 's' : ''} selected',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: todayClothing.length,
                      itemBuilder: (context, index) {
                        final clothing = todayClothing[index];
                        return ClothingCard(
                          clothing: clothing,
                          trailing: IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () async {
                              await clothingNotifier.removeFromToday(clothing.id);
                            },
                            tooltip: 'Remove from today',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _EmptyTodayState extends StatelessWidget {
  const _EmptyTodayState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wb_sunny_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No clothes selected for today',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Go to your wardrobe and mark clothes\nyou\'re wearing today',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}