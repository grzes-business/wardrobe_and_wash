import 'package:hive_flutter/hive_flutter.dart';
import '../models/clothing.dart';
import '../models/clothing_category.dart';
import '../models/wash_plan.dart';

class HiveService {
  static const String clothingBoxName = 'clothing';
  static const String washPlanBoxName = 'wash_plans';
  static const String settingsBoxName = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(ClothingCategoryAdapter());
    Hive.registerAdapter(ClothingAdapter());
    Hive.registerAdapter(WashPlanAdapter());
    
    // Open boxes
    await Hive.openBox<Clothing>(clothingBoxName);
    await Hive.openBox<WashPlan>(washPlanBoxName);
    await Hive.openBox(settingsBoxName);
  }

  static Box<Clothing> get clothingBox => Hive.box<Clothing>(clothingBoxName);
  static Box<WashPlan> get washPlanBox => Hive.box<WashPlan>(washPlanBoxName);
  static Box get settingsBox => Hive.box(settingsBoxName);

  /// Reset today set at midnight
  static Future<void> resetTodaySet() async {
    final clothingBox = HiveService.clothingBox;
    final clothes = clothingBox.values.where((clothing) => clothing.isInTodaySet);
    
    for (final clothing in clothes) {
      clothing.removeFromToday();
      await clothing.save();
    }
  }

  /// Check if today set needs to be reset
  static Future<void> checkAndResetTodaySet() async {
    final settingsBox = HiveService.settingsBox;
    final lastResetDate = settingsBox.get('lastTodayReset');
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month}-${today.day}';
    
    if (lastResetDate != todayString) {
      await resetTodaySet();
      await settingsBox.put('lastTodayReset', todayString);
    }
  }

  static Future<void> dispose() async {
    await Hive.close();
  }
}