import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../core/data/repositories/care_repository.dart';
import '../../../core/domain/value_objects/enums.dart';

/// The home screen: the live "care queue" grouped into Overdue / Today / Upcoming.
/// Renders from a reactive Drift stream (via [careQueueProvider]) — completing a task
/// writes a log, triggers a reconcile, and the list recomputes itself.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(careQueueProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Journal',
            onPressed: () => context.push(Routes.journal),
          ),
        ],
      ),
      body: queue.when(
        data: (items) =>
            items.isEmpty ? const _EmptyState() : _CareQueueList(items: items),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Something went wrong: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.addPlant),
        icon: const Icon(Icons.add),
        label: const Text('Add plant'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('No plants yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Add your first plant and Plantner will remind you when to care for it.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _CareQueueList extends StatelessWidget {
  const _CareQueueList({required this.items});

  final List<CareQueueItem> items;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final overdue = <CareQueueItem>[];
    final dueToday = <CareQueueItem>[];
    final upcoming = <CareQueueItem>[];
    for (final item in items) {
      final due = item.nextDueAt;
      if (due == null || due.isBefore(today)) {
        overdue.add(item);
      } else if (due.isBefore(tomorrow)) {
        dueToday.add(item);
      } else {
        upcoming.add(item);
      }
    }

    return ListView(
      children: [
        ..._section(context, 'Overdue', overdue),
        ..._section(context, 'Today', dueToday),
        ..._section(context, 'Upcoming', upcoming),
        const SizedBox(height: 80), // room for the FAB
      ],
    );
  }

  List<Widget> _section(BuildContext context, String title, List<CareQueueItem> items) {
    if (items.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        child: Text(title, style: Theme.of(context).textTheme.titleSmall),
      ),
      for (final item in items) _CareTile(item: item),
    ];
  }
}

class _CareTile extends ConsumerWidget {
  const _CareTile({required this.item});

  final CareQueueItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () => context.push(Routes.plant(item.plantId)),
      leading: Icon(_iconFor(item.type), color: Theme.of(context).colorScheme.primary),
      title: Text('${_label(item.type)} ${item.nickname}'),
      subtitle: Text(_dueText(item.nextDueAt)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PopupMenuButton<Duration>(
            icon: const Icon(Icons.snooze),
            tooltip: 'Snooze',
            onSelected: (d) => _snooze(ref, d),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: Duration(hours: 1),
                child: Text('Snooze 1 hour'),
              ),
              PopupMenuItem(
                value: Duration(days: 1),
                child: Text('Snooze 1 day'),
              ),
            ],
          ),
          FilledButton.tonal(
            onPressed: () => _markDone(ref),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _markDone(WidgetRef ref) async {
    await ref.read(careRepositoryProvider).logCare(
          plantId: item.plantId,
          type: item.type,
          performedAt: DateTime.now(),
        );
    await ref.read(reconcileCoordinatorProvider).reconcile();
  }

  /// Defer this task by [delay] from now. Writes the snooze marker, then reconciles so
  /// the reminder engine re-projects the next-due date (and reschedules the OS alarm).
  Future<void> _snooze(WidgetRef ref, Duration delay) async {
    await ref.read(careRepositoryProvider).snooze(
          scheduleId: item.scheduleId,
          until: DateTime.now().add(delay),
        );
    await ref.read(reconcileCoordinatorProvider).reconcile();
  }

  String _dueText(DateTime? due) {
    if (due == null) return 'Scheduling…';
    final now = DateTime.now();
    final days = DateTime(due.year, due.month, due.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (days < 0) return 'Overdue by ${-days} day(s)';
    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    return 'Due in $days days';
  }

  String _label(CareType type) => switch (type) {
        CareType.water => 'Water',
        CareType.fertilize => 'Fertilize',
        CareType.mist => 'Mist',
        CareType.repot => 'Repot',
        CareType.rotate => 'Rotate',
        CareType.prune => 'Prune',
        CareType.clean => 'Clean',
        CareType.inspect => 'Inspect',
      };

  IconData _iconFor(CareType type) => switch (type) {
        CareType.water => Icons.water_drop,
        CareType.fertilize => Icons.grass,
        CareType.mist => Icons.dew_point,
        CareType.repot => Icons.yard,
        CareType.rotate => Icons.sync,
        CareType.prune => Icons.content_cut,
        CareType.clean => Icons.cleaning_services,
        CareType.inspect => Icons.search,
      };
}
