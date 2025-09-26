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

  WashPlan? getWashPlan(String id) {
    return HiveService.washPlanBox.values
        .where((plan) => plan.id == id)
        .firstOrNull;
  }

  Future<void> addWashPlan(WashPlan washPlan) async {
    await HiveService.washPlanBox.put(washPlan.id, washPlan);
    state = HiveService.washPlanBox.values.toList();
  }

  Future<void> updateWashPlan(WashPlan washPlan) async {
    await washPlan.save();
    state = HiveService.washPlanBox.values.toList();
  }

  Future<void> removeWashPlan(String id) async {
    await HiveService.washPlanBox.delete(id);
    state = HiveService.washPlanBox.values.toList();
  }

  List<WashPlan> getAllWashPlans() {
    return state;
  }

  List<WashPlan> getActiveWashPlans() {
    return state.where((plan) => !plan.isCompleted).toList();
  }

  List<WashPlan> getCompletedWashPlans() {
    return state.where((plan) => plan.isCompleted).toList();
  }

  Future<void> addClothingToWashPlan(String washPlanId, String clothingId) async {
    final washPlan = getWashPlan(washPlanId);
    if (washPlan != null) {
      washPlan.addClothing(clothingId);
      await updateWashPlan(washPlan);
    }
  }

  Future<void> removeClothingFromWashPlan(String washPlanId, String clothingId) async {
    final washPlan = getWashPlan(washPlanId);
    if (washPlan != null) {
      washPlan.removeClothing(clothingId);
      await updateWashPlan(washPlan);
    }
  }

  Future<void> completeWashPlan(String id) async {
    final washPlan = getWashPlan(id);
    if (washPlan != null) {
      washPlan.complete();
      await updateWashPlan(washPlan);
    }
  }
}
@riverpod
List<WashPlan> activeWashPlans(Ref ref) {
  final washPlans = ref.watch(washPlanNotifierProvider);
  return washPlans.where((plan) => !plan.isCompleted).toList();
}