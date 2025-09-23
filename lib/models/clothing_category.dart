import 'package:hive/hive.dart';

part 'clothing_category.g.dart';

@HiveType(typeId: 0)
enum ClothingCategory {
  @HiveField(0)
  underwear(maxWears: 1),
  
  @HiveField(1)
  tshirt(maxWears: 2),
  
  @HiveField(2)
  shirt(maxWears: 2),
  
  @HiveField(3)
  pants(maxWears: 3),
  
  @HiveField(4)
  dress(maxWears: 2),
  
  @HiveField(5)
  jacket(maxWears: 5),
  
  @HiveField(6)
  shoes(maxWears: 10),
  
  @HiveField(7)
  socks(maxWears: 1),
  
  @HiveField(8)
  others(maxWears: 3);

  const ClothingCategory({required this.maxWears});
  
  final int maxWears;
  
  String get displayName {
    switch (this) {
      case ClothingCategory.underwear:
        return 'Underwear';
      case ClothingCategory.tshirt:
        return 'T-Shirt';
      case ClothingCategory.shirt:
        return 'Shirt';
      case ClothingCategory.pants:
        return 'Pants';
      case ClothingCategory.dress:
        return 'Dress';
      case ClothingCategory.jacket:
        return 'Jacket';
      case ClothingCategory.shoes:
        return 'Shoes';
      case ClothingCategory.socks:
        return 'Socks';
      case ClothingCategory.others:
        return 'Others';
    }
  }
}