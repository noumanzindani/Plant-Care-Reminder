// Widget test for the Journal View: renders the journal for a given provider state.
// Kept in its own file (never mixed with pure Drift-stream tests) because
// TestWidgetsFlutterBinding's fake clock would stall a real Drift stream. The provider
// is overridden with a timer-free `Stream.value` stub so the View test is hermetic.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/app/providers.dart';
import 'package:plant_care_reminder/core/data/repositories/care_repository.dart';
import 'package:plant_care_reminder/core/domain/value_objects/enums.dart';
import 'package:plant_care_reminder/features/journal/presentation/journal_screen.dart';

void main() {
  testWidgets('journal shows the empty state when there are no logs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalProvider.overrideWith((ref) => Stream.value(const <JournalEntry>[])),
        ],
        child: const MaterialApp(home: JournalScreen()),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('No care logged yet'), findsOneWidget);
  });

  testWidgets('journal lists a logged action under a day header', (tester) async {
    final entries = [
      JournalEntry(
        logId: 'l1',
        plantId: 'p1',
        nickname: 'Monstera',
        type: CareType.water,
        performedAt: DateTime.now(),
        source: CareLogSource.manual,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [journalProvider.overrideWith((ref) => Stream.value(entries))],
        child: const MaterialApp(home: JournalScreen()),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Watered Monstera'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
  });
}
