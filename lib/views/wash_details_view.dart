import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/clothing_provider.dart';
import '../providers/wash_plan_provider.dart';
import '../models/wash_plan.dart';
import '../models/clothing.dart';

class WashDetailsView extends HookConsumerWidget {
  final String? washPlanId;

  const WashDetailsView({
    super.key,
    this.washPlanId,
  });

  bool get isNewWashPlan => washPlanId == null || washPlanId == 'new';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final washPlanNotifier = ref.watch(washPlanNotifierProvider.notifier);
    final clothingNotifier = ref.watch(clothingNotifierProvider.notifier);
    final allClothing = ref.watch(clothingNotifierProvider);
    
    final washPlan = isNewWashPlan 
        ? null 
        : washPlanNotifier.getWashPlan(washPlanId!);
    
    final selectedClothingIds = useState<Set<String>>(
      washPlan?.clothingIds.toSet() ?? <String>{},
    );
    
    final washPlanName = useState(washPlan?.name ?? '');

    final selectedClothing = useMemoized(() {
      return allClothing
          .where((clothing) => selectedClothingIds.value.contains(clothing.id))
          .toList();
    }, [allClothing, selectedClothingIds.value]);

    return Scaffold(
      appBar: AppBar(
        title: Text(washPlan?.name ?? 'New Wash Plan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          if (isNewWashPlan) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Wash Plan Name',
                  border: OutlineInputBorder(),
                  hintText: 'Enter wash plan name',
                ),
                onChanged: (value) => washPlanName.value = value,
                textCapitalization: TextCapitalization.words,
              ),
            ),
          ],
          
          Expanded(
            child: selectedClothing.isEmpty
                ? const _EmptySelectionState()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Clothes',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${selectedClothing.length} item${selectedClothing.length != 1 ? 's' : ''} selected',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: selectedClothing.length,
                            itemBuilder: (context, index) {
                              final clothing = selectedClothing[index];
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    child: clothing.assetPath != null
                                        ? ClipOval(
                                            child: Image.asset(
                                              clothing.assetPath!,
                                              fit: BoxFit.cover,
                                              width: 40,
                                              height: 40,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  const Icon(Icons.checkroom),
                                            ),
                                          )
                                        : const Icon(Icons.checkroom),
                                  ),
                                  title: Text(clothing.name),
                                  subtitle: Text(clothing.category.displayName),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      selectedClothingIds.value = Set.from(selectedClothingIds.value)
                                        ..remove(clothing.id);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showClothingSelector(
                      context,
                      allClothing,
                      selectedClothingIds.value,
                      (newSelection) {
                        selectedClothingIds.value = newSelection;
                      },
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: selectedClothing.isEmpty ||
                            (isNewWashPlan && washPlanName.value.trim().isEmpty)
                        ? null
                        : () => _completeWashPlan(
                              context,
                              washPlanNotifier,
                              clothingNotifier,
                              washPlan,
                              selectedClothingIds.value.toList(),
                              washPlanName.value.trim(),
                            ),
                    icon: const Icon(Icons.check),
                    label: const Text('Complete'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClothingSelector(
    BuildContext context,
    List<Clothing> allClothing,
    Set<String> selectedIds,
    Function(Set<String>) onSelectionChanged,
  ) {
    final sortedClothing = List<Clothing>.from(allClothing);
    sortedClothing.sort((a, b) => b.washPriority.compareTo(a.washPriority));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ClothingSelectorSheet(
        sortedClothing: sortedClothing,
        selectedIds: selectedIds,
        onSelectionChanged: onSelectionChanged,
      ),
    );
  }

  Future<void> _completeWashPlan(
    BuildContext context,
    WashPlanNotifier washPlanNotifier,
    ClothingNotifier clothingNotifier,
    WashPlan? existingWashPlan,
    List<String> clothingIds,
    String name,
  ) async {
    try {
      if (isNewWashPlan) {
        final newWashPlan = WashPlan(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          clothingIds: clothingIds,
          createdAt: DateTime.now(),
        );
        await washPlanNotifier.addWashPlan(newWashPlan);
      } else {
        await washPlanNotifier.completeWashPlan(existingWashPlan!.id);
        await clothingNotifier.resetWornCount(clothingIds);
      }
      
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _EmptySelectionState extends StatelessWidget {
  const _EmptySelectionState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_laundry_service_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No clothes selected',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add clothes to this wash plan\nusing the Add button below',
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

class _ClothingSelectorSheet extends HookWidget {
  final List<Clothing> sortedClothing;
  final Set<String> selectedIds;
  final Function(Set<String>) onSelectionChanged;

  const _ClothingSelectorSheet({
    required this.sortedClothing,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentSelection = useState<Set<String>>(selectedIds);

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Select Clothes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: sortedClothing.length,
                itemBuilder: (context, index) {
                  final clothing = sortedClothing[index];
                  final isSelected = currentSelection.value.contains(clothing.id);
                  
                  return Card(
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (value) {
                        final newSelection = Set<String>.from(currentSelection.value);
                        if (value == true) {
                          newSelection.add(clothing.id);
                        } else {
                          newSelection.remove(clothing.id);
                        }
                        currentSelection.value = newSelection;
                        onSelectionChanged(newSelection);
                      },
                      secondary: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: clothing.assetPath != null
                            ? ClipOval(
                                child: Image.file(
                                  File(clothing.assetPath!),
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.checkroom),
                                ),
                              )
                            : const Icon(Icons.checkroom),
                      ),
                      title: Text(clothing.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(clothing.category.displayName),
                          if (clothing.isDirty || clothing.isUsed)
                            Text(
                              clothing.isDirty ? 'Dirty' : 'Used',
                              style: TextStyle(
                                color: clothing.isDirty ? Colors.red : Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
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