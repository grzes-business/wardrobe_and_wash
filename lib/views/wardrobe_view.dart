import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/clothing_provider.dart';
import '../widgets/scaffold_with_bottom_navigation.dart';
import '../widgets/clothing_card.dart';

class WardrobeView extends HookConsumerWidget {
  const WardrobeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final clothingNotifier = ref.watch(clothingNotifierProvider.notifier);
    final allClothing = ref.watch(clothingNotifierProvider);

    final filteredClothing = useMemoized(() {
      if (searchQuery.value.isEmpty) {
        return allClothing;
      }
      return clothingNotifier.searchClothing(searchQuery.value);
    }, [allClothing, searchQuery.value]);

    return ScaffoldWithBottomNavigation(
      currentRoute: '/wardrobe',
      appBar: AppBar(
        title: const Text('My Wardrobe', style: TextStyle( fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search clothing...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          searchQuery.value = '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                searchQuery.value = value;
              },
            ),
          ),
          
          Expanded(
            child: filteredClothing.isEmpty
                ? _EmptyState(
                    hasSearch: searchQuery.value.isNotEmpty,
                    onAddClothing: () => context.push('/add-clothing'),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filteredClothing.length,
                      itemBuilder: (context, index) {
                        final clothing = filteredClothing[index];
                        return ClothingCard(clothing: clothing);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-clothing'),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasSearch;
  final VoidCallback onAddClothing;

  const _EmptyState({
    required this.hasSearch,
    required this.onAddClothing,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasSearch ? Icons.search_off : Icons.checkroom_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            hasSearch 
                ? 'No clothing found'
                : 'No clothing in your wardrobe',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            hasSearch
                ? 'Try searching with different keywords'
                : 'Add your first piece of clothing to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          if (!hasSearch) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAddClothing,
              icon: const Icon(Icons.add),
              label: const Text('Add Clothing'),
            ),
          ],
        ],
      ),
    );
  }
}