// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wash_plan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeWashPlansHash() => r'bf5893eefb94dad4dd178f1f0deaf7df8c48985a';

/// Provider for active wash plans
///
/// Copied from [activeWashPlans].
@ProviderFor(activeWashPlans)
final activeWashPlansProvider = AutoDisposeProvider<List<WashPlan>>.internal(
  activeWashPlans,
  name: r'activeWashPlansProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeWashPlansHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveWashPlansRef = AutoDisposeProviderRef<List<WashPlan>>;
String _$washPlanNotifierHash() => r'2acd042135270972ce2d5fd589fbe35386c65d7c';

/// See also [WashPlanNotifier].
@ProviderFor(WashPlanNotifier)
final washPlanNotifierProvider =
    NotifierProvider<WashPlanNotifier, List<WashPlan>>.internal(
  WashPlanNotifier.new,
  name: r'washPlanNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$washPlanNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WashPlanNotifier = Notifier<List<WashPlan>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
