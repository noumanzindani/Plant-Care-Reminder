// Phase 1 widget tests: the home View renders the care queue for a given state. The
// queue provider is overridden with a timer-free `Stream.value` stub so the View test
// is hermetic (the real Drift stream is covered by care_repository_test.dart) and never
// leaves a pending timer that would crash teardown.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/app/app.dart';
import 'package:plant_care_reminder/app/providers.dart';
import 'package:plant_care_reminder/core/data/repositories/care_repository.dart';
import 'package:plant_care_reminder/core/domain/value_objects/enums.dart';

void main() {
  testWidgets('home shows the empty state when the care queue is empty', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          careQueueProvider.overrideWith((ref) => Stream.value(const <CareQueueItem>[])),
        ],
        child: const PlantCareApp(),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Plantner'), findsOneWidget);
    expect(find.text('No plants yet'), findsOneWidget);
    expect(find.text('Add plant'), findsOneWidget);
  });

  testWidgets('home lists a due care task', (tester) async {
    final items = [
      CareQueueItem(
        plantId: 'p1',
        scheduleId: 's1',
        nickname: 'Monstera',
        type: CareType.water,
        nextDueAt: DateTime.now(),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [careQueueProvider.overrideWith((ref) => Stream.value(items))],
        child: const PlantCareApp(),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Water Monstera'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
  });
}
