import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/ports/clock.dart';
import '../../infra/time/system_clock.dart';
import 'database.dart';
import 'daos/plants_dao.dart';

/// The single [AppDatabase] instance for the app's lifetime.
///
/// This is the composition root for persistence: every repository/DAO consumer reads
/// the DB through this provider, and tests override it with an in-memory database.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// DAO for the plant collection, derived from the database provider.
final plantsDaoProvider = Provider<PlantsDao>((ref) {
  return ref.watch(appDatabaseProvider).plantsDao;
});

/// The [Clock] abstraction, bound to the real [SystemClock] in production and
/// overridable with a fake in tests (for deterministic cadence/DST testing).
final clockProvider = Provider<Clock>((ref) => const SystemClock());
