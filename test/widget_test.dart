// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_wash/models/clothing_category.dart';

void main() {
  group('ClothingCategory', () {
    test('should have correct max wears for each category', () {
      expect(ClothingCategory.underwear.maxWears, 1);
      expect(ClothingCategory.socks.maxWears, 1);
      expect(ClothingCategory.tshirt.maxWears, 2);
      expect(ClothingCategory.shirt.maxWears, 2);
      expect(ClothingCategory.dress.maxWears, 2);
      expect(ClothingCategory.pants.maxWears, 3);
      expect(ClothingCategory.others.maxWears, 3);
      expect(ClothingCategory.jacket.maxWears, 5);
      expect(ClothingCategory.shoes.maxWears, 10);
    });

    test('should have correct display names', () {
      expect(ClothingCategory.underwear.displayName, 'Underwear');
      expect(ClothingCategory.tshirt.displayName, 'T-Shirt');
      expect(ClothingCategory.shirt.displayName, 'Shirt');
      expect(ClothingCategory.pants.displayName, 'Pants');
      expect(ClothingCategory.dress.displayName, 'Dress');
      expect(ClothingCategory.jacket.displayName, 'Jacket');
      expect(ClothingCategory.shoes.displayName, 'Shoes');
      expect(ClothingCategory.socks.displayName, 'Socks');
      expect(ClothingCategory.others.displayName, 'Others');
    });
  });
}
