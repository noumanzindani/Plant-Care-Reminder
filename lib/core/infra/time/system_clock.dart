import '../../domain/ports/clock.dart';

/// The production [Clock]: the real device wall clock.
///
/// Kept trivially thin so that every non-test code path uses the same instant
/// source, and tests can swap in a fake without touching production logic.
class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}
