import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../models/clothing.dart';

class ClothingCard extends StatelessWidget {
  final Clothing clothing;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ClothingCard({
    super.key,
    required this.clothing,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap ?? () => context.push('/clothing/${clothing.id}'),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                    child: clothing.assetPath != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                            child: Image.file(
                              File(clothing.assetPath!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const _PlaceholderImage(),
                            ),
                          )
                        : const _PlaceholderImage(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clothing.name,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        clothing.category.displayName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          _StatusChip(
                            label: 'Worn ${clothing.wornCount}x',
                            color: _getWornCountColor(clothing),
                          ),
                          if (clothing.isInTodaySet)
                            const _StatusChip(
                              label: 'Today',
                              color: Colors.blue,
                            ),
                          if (clothing.isDirty)
                            const _StatusChip(
                              label: 'Dirty',
                              color: Colors.red,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Positioned trailing widget (X button) in top-right corner
            if (trailing != null)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: trailing!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getWornCountColor(Clothing clothing) {
    if (clothing.isDirty) return Colors.red;
    if (clothing.isUsed) return Colors.orange;
    return Colors.green;
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(4),
        ),
      ),
      child: const Icon(
        Icons.checkroom,
        size: 48,
        color: Colors.grey,
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}