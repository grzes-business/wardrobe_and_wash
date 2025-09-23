import 'package:hive/hive.dart';

part 'wash_plan.g.dart';

@HiveType(typeId: 2)
class WashPlan extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> clothingIds; // References to clothing IDs

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  DateTime? completedAt;

  WashPlan({
    required this.id,
    required this.name,
    required this.clothingIds,
    required this.createdAt,
    this.isCompleted = false,
    this.completedAt,
  });

  /// Add clothing to wash plan
  void addClothing(String clothingId) {
    if (!clothingIds.contains(clothingId)) {
      clothingIds.add(clothingId);
    }
  }

  /// Remove clothing from wash plan
  void removeClothing(String clothingId) {
    clothingIds.remove(clothingId);
  }

  /// Mark wash plan as completed
  void complete() {
    isCompleted = true;
    completedAt = DateTime.now();
  }

  WashPlan copyWith({
    String? id,
    String? name,
    List<String>? clothingIds,
    DateTime? createdAt,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return WashPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      clothingIds: clothingIds ?? List.from(this.clothingIds),
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() {
    return 'WashPlan(id: $id, name: $name, clothingCount: ${clothingIds.length}, isCompleted: $isCompleted)';
  }
}