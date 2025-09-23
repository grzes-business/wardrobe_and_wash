import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/wash_plan_provider.dart';
import '../widgets/scaffold_with_bottom_navigation.dart';

class WashView extends HookConsumerWidget {
  const WashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWashPlans = ref.watch(activeWashPlansProvider);

    return ScaffoldWithBottomNavigation(
      currentRoute: '/wash',
      body: Column(
        children: [
          Expanded(
            child: activeWashPlans.isEmpty
                ? const _EmptyWashState()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wash Plans',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${activeWashPlans.length} active plan${activeWashPlans.length != 1 ? 's' : ''}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: activeWashPlans.length,
                            itemBuilder: (context, index) {
                              final washPlan = activeWashPlans[index];
                              return Card(
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.local_laundry_service),
                                  ),
                                  title: Text(washPlan.name),
                                  subtitle: Text(
                                    '${washPlan.clothingIds.length} item${washPlan.clothingIds.length != 1 ? 's' : ''}',
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () => context.push('/wash-details/${washPlan.id}'),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          
          // Custom wash button above bottom navigation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/wash-details/new'),
                icon: const Icon(Icons.add),
                label: const Text('Custom Wash'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWashState extends StatelessWidget {
  const _EmptyWashState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_laundry_service_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No wash plans',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first wash plan to\nkeep your clothes organized',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}