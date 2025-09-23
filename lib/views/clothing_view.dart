import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../providers/clothing_provider.dart';
import '../models/clothing.dart';

class ClothingView extends HookConsumerWidget {
  final String clothingId;

  const ClothingView({
    super.key,
    required this.clothingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clothingNotifier = ref.watch(clothingNotifierProvider.notifier);
    final clothing = clothingNotifier.getClothing(clothingId);

    if (clothing == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Clothing Not Found'),
        ),
        body: const Center(
          child: Text('This clothing item could not be found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(clothing.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Photo section (1/3 of remaining space)
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: clothing.assetPath != null
                  ? Image.file(
                      File(clothing.assetPath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _PlaceholderImage(),
                    )
                  : const _PlaceholderImage(),
            ),
          ),
          
          // Details section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    clothing.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Category
                  Text(
                    clothing.category.displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Worn count
                  _InfoRow(
                    label: 'Worn Count',
                    value: '${clothing.wornCount} time${clothing.wornCount != 1 ? 's' : ''}',
                    color: _getWornCountColor(clothing),
                  ),
                  const SizedBox(height: 8),
                  
                  // Status
                  _InfoRow(
                    label: 'Status',
                    value: _getStatusText(clothing),
                    color: _getStatusColor(clothing),
                  ),
                  
                  if (clothing.lastWornAt != null) ...[
                    const SizedBox(height: 8),
                    _InfoRow(
                      label: 'Last Worn',
                      value: _formatDate(clothing.lastWornAt!),
                    ),
                  ],
                  
                  const Spacer(),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showDeleteDialog(context, clothingNotifier, clothing),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Remove'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: clothing.isInTodaySet
                              ? () async {
                                  await clothingNotifier.removeFromToday(clothing.id);
                                }
                              : () async {
                                  await clothingNotifier.addToToday(clothing.id);
                                },
                          icon: Icon(
                            clothing.isInTodaySet ? Icons.wb_sunny : Icons.wb_sunny_outlined,
                          ),
                          label: Text(
                            clothing.isInTodaySet ? 'Remove from Today' : 'Add for Today',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getWornCountColor(Clothing clothing) {
    if (clothing.isDirty) return Colors.red;
    if (clothing.isUsed) return Colors.orange;
    return Colors.green;
  }

  Color _getStatusColor(Clothing clothing) {
    if (clothing.isDirty) return Colors.red;
    if (clothing.isUsed) return Colors.orange;
    return Colors.green;
  }

  String _getStatusText(Clothing clothing) {
    if (clothing.isDirty) return 'Dirty';
    if (clothing.isUsed) return 'Used';
    return 'Clean';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return '${difference} days ago';
  }

  void _showDeleteDialog(BuildContext context, ClothingNotifier notifier, Clothing clothing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Clothing'),
        content: Text('Are you sure you want to remove "${clothing.name}" from your wardrobe?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await notifier.removeClothing(clothing.id);
              if (context.mounted) {
                context.pop(); // Close dialog
                context.pop(); // Go back to previous screen
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: const Icon(
        Icons.checkroom,
        size: 64,
        color: Colors.grey,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _InfoRow({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: color,
              ),
        ),
      ],
    );
  }
}