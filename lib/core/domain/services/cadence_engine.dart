import 'package:timezone/timezone.dart' as tz;

import '../value_objects/enums.dart';

/// The pure inputs the [CadenceEngine] needs to compute a next-due instant.
///
/// This is a value object with no Flutter/Drift dependencies so the engine can be
/// unit-tested exhaustively. A repository maps a Drift `CareSchedule` row + its latest
/// matching `CareLog` into one of these.
class CadenceRequest {
  const CadenceRequest({
    required this.baseIntervalDays,
    required this.anchor,
    required this.timeOfDayMinutes,
    required this.tzId,
    required this.createdAt,
    this.lastPerformedAt,
    this.seasonalMultipliers = const {},
    this.southernHemisphere = false,
  });

  /// Base cadence in days, before any seasonal adjustment.
  final int baseIntervalDays;

  /// How the next date is anchored — see [AnchorMode].
  final AnchorMode anchor;

  /// Local wall-clock time of day for the reminder, as minutes since midnight.
  final int timeOfDayMinutes;

  /// IANA timezone id the schedule's wall-clock time is expressed in.
  final String tzId;

  /// When the schedule was created — the anchor for `fixedCalendar` and the fallback
  /// anchor for `fromLastDone` when the task has never been performed.
  final DateTime createdAt;

  /// When the task was last actually performed (from the latest matching care log);
  /// null if never.
  final DateTime? lastPerformedAt;

  /// Optional per-[Season] multipliers applied to [baseIntervalDays].
  final Map<Season, double> seasonalMultipliers;

  /// Whether the plant's location is in the southern hemisphere (flips the month→season
  /// mapping — a July winter reminder in Sydney vs a July summer one in New York).
  final bool southernHemisphere;
}

/// Computes when a care task is next due. Pure and deterministic: given the same
/// [CadenceRequest] and `now`, it always returns the same instant — which is what makes
/// the reminder engine testable across DST boundaries and traveller scenarios.
class CadenceEngine {
  const CadenceEngine();

  /// The next due instant for [request], as of [now].
  tz.TZDateTime nextDue(CadenceRequest request, tz.TZDateTime now) {
    final location = tz.getLocation(request.tzId);

    switch (request.anchor) {
      case AnchorMode.fromLastDone:
        // Anchor to when the task was actually performed (or creation if never),
        // then advance one (season-adjusted) interval. Late completion pushes the
        // chain forward.
        final anchor =
            tz.TZDateTime.from(request.lastPerformedAt ?? request.createdAt, location);
        return _addDaysAtTime(
          location,
          anchor,
          _effectiveInterval(request, anchor),
          request.timeOfDayMinutes,
        );

      case AnchorMode.fixedCalendar:
        // Fixed grid from creation, independent of completion. Return the first grid
        // slot at/after now (a passed-but-undone slot is handled by the overdue query,
        // not by scheduling it in the past). Each step is season-adjusted by the season
        // at that step.
        final start = tz.TZDateTime.from(request.createdAt, location);
        var due = _atTimeOfDay(location, start, request.timeOfDayMinutes);
        while (due.isBefore(now)) {
          due = _addDaysAtTime(
            location,
            due,
            _effectiveInterval(request, due),
            request.timeOfDayMinutes,
          );
        }
        return due;
    }
  }

  /// The interval in days after applying the season multiplier for [at]'s season.
  int _effectiveInterval(CadenceRequest request, tz.TZDateTime at) {
    final season = _seasonOf(at.month, request.southernHemisphere);
    final multiplier = request.seasonalMultipliers[season] ?? 1.0;
    return (request.baseIntervalDays * multiplier).round();
  }

  /// Meteorological season for a month. Northern-hemisphere mapping by default; the
  /// southern hemisphere is the opposite season (6 months offset).
  Season _seasonOf(int month, bool southernHemisphere) {
    final northern = switch (month) {
      12 || 1 || 2 => Season.winter,
      3 || 4 || 5 => Season.spring,
      6 || 7 || 8 => Season.summer,
      _ => Season.autumn, // 9, 10, 11
    };
    if (!southernHemisphere) return northern;
    return switch (northern) {
      Season.winter => Season.summer,
      Season.summer => Season.winter,
      Season.spring => Season.autumn,
      Season.autumn => Season.spring,
    };
  }

  /// Add [days] calendar days to [from] and pin to [minutesSinceMidnight] wall-clock,
  /// via the [tz.TZDateTime] constructor so month rollover and DST are handled by the
  /// timezone database rather than by adding a raw 24h*n [Duration] (which drifts across
  /// DST transitions).
  tz.TZDateTime _addDaysAtTime(
    tz.Location location,
    tz.TZDateTime from,
    int days,
    int minutesSinceMidnight,
  ) {
    return tz.TZDateTime(
      location,
      from.year,
      from.month,
      from.day + days,
      minutesSinceMidnight ~/ 60,
      minutesSinceMidnight % 60,
    );
  }

  /// Build a [tz.TZDateTime] on the calendar date of [date] at [minutesSinceMidnight]
  /// wall-clock time in [location].
  tz.TZDateTime _atTimeOfDay(
    tz.Location location,
    tz.TZDateTime date,
    int minutesSinceMidnight,
  ) {
    return tz.TZDateTime(
      location,
      date.year,
      date.month,
      date.day,
      minutesSinceMidnight ~/ 60,
      minutesSinceMidnight % 60,
    );
  }
}
