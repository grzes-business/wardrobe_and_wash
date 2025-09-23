import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import '../models/wash_plan.dart';
import '../services/hive_service.dart';

part 'wash_plan_provider.g.dart';

@Riverpod(keepAlive: true)
class WashPlanNotifier extends _$WashPlanNotifier {
  @override
  List<WashPlan> build() {
    return HiveService.washPlanBox.values.toList();
  }

  /// Get wash plan by ID
  WashPlan? getWashPlan(String id) {
    return HiveService.washPlanBox.values
        .where((plan) => plan.id == id)
        .firstOrNull;
  }

  /// Add new wash plan
  Future<void> addWashPlan(WashPlan washPlan) async {
    await HiveService.washPlanBox.put(washPlan.id, washPlan);
    state = HiveService.washPlanBox.values.toList();
  }

  /// Update existing wash plan
  Future<void> updateWashPlan(WashPlan washPlan) async {
    await washPlan.save();
    state = HiveService.washPlanBox.values.toList();
  }

  /// Remove wash plan
  Future<void> removeWashPlan(String id) async {
    await HiveService.washPlanBox.delete(id);
    state = HiveService.washPlanBox.values.toList();
  }

  /// Get all wash plans
  List<WashPlan> getAllWashPlans() {
    return state;
  }

  /// Get active (non-completed) wash plans
  List<WashPlan> getActiveWashPlans() {
    return state.where((plan) => !plan.isCompleted).toList();
  }

  /// Get completed wash plans
  List<WashPlan> getCompletedWashPlans() {
    return state.where((plan) => plan.isCompleted).toList();
  }

  /// Add clothing to wash plan
  Future<void> addClothingToWashPlan(String washPlanId, String clothingId) async {
    final washPlan = getWashPlan(washPlanId);
    if (washPlan != null) {
      washPlan.addClothing(clothingId);
      await updateWashPlan(washPlan);
    }
  }

  /// Remove clothing from wash plan
  Future<void> removeClothingFromWashPlan(String washPlanId, String clothingId) async {
    final washPlan = getWashPlan(washPlanId);
    if (washPlan != null) {
      washPlan.removeClothing(clothingId);
      await updateWashPlan(washPlan);
    }
  }

  /// Complete wash plan
  Future<void> completeWashPlan(String id) async {
    final washPlan = getWashPlan(id);
    if (washPlan != null) {
      washPlan.complete();
      await updateWashPlan(washPlan);
    }
  }
}

/// Provider for active wash plans
@riverpod
List<WashPlan> activeWashPlans(Ref ref) {
  final washPlans = ref.watch(washPlanNotifierProvider);
  return washPlans.where((plan) => !plan.isCompleted).toList();
}