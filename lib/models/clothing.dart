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
  String? assetPath;

  @HiveField(3)
  ClothingCategory category;

  @HiveField(4)
  int wornCount;

  @HiveField(5)
  int previousWornCount;

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

  bool get isDirty => wornCount >= category.maxWears;

  bool get isUsed => wornCount > 0;

  int get washPriority {
    if (isDirty) return 100 + wornCount;
    if (isUsed) return 50 + wornCount;
    return wornCount;
  }

  void addToToday() {
    if (!isInTodaySet) {
      previousWornCount = wornCount;
      wornCount++;
      isInTodaySet = true;
      lastWornAt = DateTime.now();
    }
  }

  void removeFromToday() {
    if (isInTodaySet) {
      wornCount = previousWornCount;
      isInTodaySet = false;
    }
  }

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