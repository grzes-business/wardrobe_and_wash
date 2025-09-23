// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayClothingHash() => r'e9dd31c98e3400245ebbf06d7b0b4d1b4259934f';

/// Provider for today's clothing
///
/// Copied from [todayClothing].
@ProviderFor(todayClothing)
final todayClothingProvider = AutoDisposeProvider<List<Clothing>>.internal(
  todayClothing,
  name: r'todayClothingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayClothingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayClothingRef = AutoDisposeProviderRef<List<Clothing>>;
String _$dirtyClothingHash() => r'95de83dd5462ab05684ba92fe2b230cdea1d9748';

/// Provider for dirty clothing
///
/// Copied from [dirtyClothing].
@ProviderFor(dirtyClothing)
final dirtyClothingProvider = AutoDisposeProvider<List<Clothing>>.internal(
  dirtyClothing,
  name: r'dirtyClothingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dirtyClothingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DirtyClothingRef = AutoDisposeProviderRef<List<Clothing>>;
String _$usedClothingHash() => r'03dcd8fe3f240743da5e37e1a7b314757cf27ad9';

/// Provider for used clothing
///
/// Copied from [usedClothing].
@ProviderFor(usedClothing)
final usedClothingProvider = AutoDisposeProvider<List<Clothing>>.internal(
  usedClothing,
  name: r'usedClothingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$usedClothingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UsedClothingRef = AutoDisposeProviderRef<List<Clothing>>;
String _$clothingNotifierHash() => r'466d0a0f51843ceb84e6d7934d9392fc11fdccdb';

/// See also [ClothingNotifier].
@ProviderFor(ClothingNotifier)
final clothingNotifierProvider =
    NotifierProvider<ClothingNotifier, List<Clothing>>.internal(
  ClothingNotifier.new,
  name: r'clothingNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clothingNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ClothingNotifier = Notifier<List<Clothing>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
