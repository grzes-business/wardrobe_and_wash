import 'package:hive/hive.dart';
import 'clothing_category.dart';

part 'clothing.g.dart';

@HiveType(typeId: 1)
class Clothing extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? assetPath; // Path to the image asset

  @HiveField(3)
  ClothingCategory category;

  @HiveField(4)
  int wornCount;

  @HiveField(5)
  int previousWornCount; // For restoration when removed from today

  @HiveField(6)
  bool isInTodaySet;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? lastWornAt;

  Clothing({
    required this.id,
    required this.name,
    this.assetPath,
    required this.category,
    this.wornCount = 0,
    this.previousWornCount = 0,
    this.isInTodaySet = false,
    required this.createdAt,
    this.lastWornAt,
  });

  /// Check if the clothing is dirty based on worn count and category
  bool get isDirty => wornCount >= category.maxWears;

  /// Check if the clothing is used (worn at least once)
  bool get isUsed => wornCount > 0;

  /// Priority for wash selection (higher priority = more urgent to wash)
  int get washPriority {
    if (isDirty) return 100 + wornCount;
    if (isUsed) return 50 + wornCount;
    return wornCount;
  }

  /// Add to today set and increment worn count
  void addToToday() {
    if (!isInTodaySet) {
      previousWornCount = wornCount;
      wornCount++;
      isInTodaySet = true;
      lastWornAt = DateTime.now();
    }
  }

  /// Remove from today set and restore previous worn count
  void removeFromToday() {
    if (isInTodaySet) {
      wornCount = previousWornCount;
      isInTodaySet = false;
      // Note: We don't reset lastWornAt as it might be useful for history
    }
  }

  /// Reset worn count (used when washing is completed)
  void resetWornCount() {
    wornCount = 0;
    previousWornCount = 0;
    isInTodaySet = false;
  }

  Clothing copyWith({
    String? id,
    String? name,
    String? assetPath,
    ClothingCategory? category,
    int? wornCount,
    int? previousWornCount,
    bool? isInTodaySet,
    DateTime? createdAt,
    DateTime? lastWornAt,
  }) {
    return Clothing(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      category: category ?? this.category,
      wornCount: wornCount ?? this.wornCount,
      previousWornCount: previousWornCount ?? this.previousWornCount,
      isInTodaySet: isInTodaySet ?? this.isInTodaySet,
      createdAt: createdAt ?? this.createdAt,
      lastWornAt: lastWornAt ?? this.lastWornAt,
    );
  }

  @override
  String toString() {
    return 'Clothing(id: $id, name: $name, category: $category, wornCount: $wornCount, isDirty: $isDirty)';
  }
}