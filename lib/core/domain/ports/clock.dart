/// A source of the current time.
///
/// This exists so time-dependent domain logic (the cadence engine, the reconciler)
/// can be unit-tested deterministically by injecting a fake clock — including exotic
/// cases like DST spring-forward/fall-back and a user travelling across timezones —
/// with zero reliance on the real wall clock.
///
/// Pure Dart: no Flutter, no plugins. The concrete [SystemClock] lives in `core/infra`.
abstract interface class Clock {
  /// The current instant. Implementations should return a UTC-aware [DateTime]
  /// or a local one consistently; domain code treats the value as "now".
  DateTime now();
}
