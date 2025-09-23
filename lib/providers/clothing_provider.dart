import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import '../models/clothing.dart';
import '../services/hive_service.dart';

part 'clothing_provider.g.dart';

@Riverpod(keepAlive: true)
class ClothingNotifier extends _$ClothingNotifier {
  @override
  List<Clothing> build() {
    return HiveService.clothingBox.values.toList();
  }

  /// Get clothing by ID
  Clothing? getClothing(String id) {
    return HiveService.clothingBox.values
        .where((clothing) => clothing.id == id)
        .firstOrNull;
  }

  /// Add new clothing
  Future<void> addClothing(Clothing clothing) async {
    await HiveService.clothingBox.put(clothing.id, clothing);
    state = HiveService.clothingBox.values.toList();
  }

  /// Update existing clothing
  Future<void> updateClothing(Clothing clothing) async {
    await clothing.save();
    state = HiveService.clothingBox.values.toList();
  }

  /// Remove clothing
  Future<void> removeClothing(String id) async {
    await HiveService.clothingBox.delete(id);
    state = HiveService.clothingBox.values.toList();
  }

  /// Get all clothing
  List<Clothing> getAllClothing() {
    return state;
  }

  /// Search clothing by name
  List<Clothing> searchClothing(String query) {
    if (query.isEmpty) return state;
    return state
        .where((clothing) =>
            clothing.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Get clothing sorted by priority for wash selection
  List<Clothing> getClothingByWashPriority() {
    final sorted = List<Clothing>.from(state);
    sorted.sort((a, b) => b.washPriority.compareTo(a.washPriority));
    return sorted;
  }

  /// Add clothing to today set
  Future<void> addToToday(String id) async {
    final clothing = getClothing(id);
    if (clothing != null) {
      clothing.addToToday();
      await updateClothing(clothing);
    }
  }

  /// Remove clothing from today set
  Future<void> removeFromToday(String id) async {
    final clothing = getClothing(id);
    if (clothing != null) {
      clothing.removeFromToday();
      await updateClothing(clothing);
    }
  }

  /// Get clothing in today set
  List<Clothing> getTodayClothing() {
    return state.where((clothing) => clothing.isInTodaySet).toList();
  }

  /// Reset worn count for multiple clothing items (after wash)
  Future<void> resetWornCount(List<String> clothingIds) async {
    for (final id in clothingIds) {
      final clothing = getClothing(id);
      if (clothing != null) {
        clothing.resetWornCount();
        await updateClothing(clothing);
      }
    }
  }
}

/// Provider for today's clothing
@riverpod
List<Clothing> todayClothing(Ref ref) {
  final clothing = ref.watch(clothingNotifierProvider);
  return clothing.where((item) => item.isInTodaySet).toList();
}

/// Provider for dirty clothing
@riverpod
List<Clothing> dirtyClothing(Ref ref) {
  final clothing = ref.watch(clothingNotifierProvider);
  return clothing.where((item) => item.isDirty).toList();
}

/// Provider for used clothing
@riverpod
List<Clothing> usedClothing(Ref ref) {
  final clothing = ref.watch(clothingNotifierProvider);
  return clothing.where((item) => item.isUsed).toList();
}