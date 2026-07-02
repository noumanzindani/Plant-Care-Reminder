import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/data/repositories/care_repository.dart';
import '../../../core/domain/value_objects/enums.dart';
import '../../../shared/care_type_display.dart';

/// The care journal: a reverse-chronological history of every logged care action,
/// grouped by day. Renders from the reactive [journalProvider] Drift stream, so a newly
/// completed task appears here the moment it is logged.
class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journal = ref.watch(journalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: journal.when(
        data: (entries) =>
            entries.isEmpty ? const _EmptyJournal() : _JournalList(entries: entries),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Something went wrong: $e')),
      ),
    );
  }
}

class _EmptyJournal extends StatelessWidget {
  const _EmptyJournal();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('No care logged yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'When you mark a task done, it will show up here as a record of your plant care.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _JournalList extends StatelessWidget {
  const _JournalList({required this.entries});

  final List<JournalEntry> entries;

  @override
  Widget build(BuildContext context) {
    // Entries arrive newest-first; walk them and emit a header whenever the day changes.
    final children = <Widget>[];
    DateTime? lastDay;
    for (final entry in entries) {
      final local = entry.performedAt.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      if (day != lastDay) {
        children.add(_DayHeader(day: day));
        lastDay = day;
      }
      children.add(_JournalTile(entry: entry));
    }
    children.add(const SizedBox(height: 24));

    return ListView(children: children);
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(_dayLabel(day), style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _JournalTile extends StatelessWidget {
  const _JournalTile({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skipped = entry.source == CareLogSource.skipped;
    final action = skipped
        ? 'Skipped ${careVerb(entry.type).toLowerCase()}'
        : carePastVerb(entry.type);

    return ListTile(
      leading: Icon(
        careTypeIcon(entry.type),
        color: skipped ? theme.disabledColor : theme.colorScheme.primary,
      ),
      title: Text('$action ${entry.nickname}'),
      subtitle: Text(_timeLabel(entry.performedAt.toLocal())),
      trailing: entry.note == null || entry.note!.isEmpty
          ? null
          : Icon(Icons.sticky_note_2_outlined, size: 18, color: theme.hintColor),
    );
  }
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _dayLabel(DateTime day) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return '${_months[day.month - 1]} ${day.day}, ${day.year}';
}

String _timeLabel(DateTime t) {
  final hour12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final minute = t.minute.toString().padLeft(2, '0');
  final meridiem = t.hour < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $meridiem';
}
