import 'package:timezone/timezone.dart' as tz;

import '../value_objects/weather_forecast.dart';

// Re-exported so existing importers of this file keep resolving [WeatherForecast]; new
// callers (e.g. the WeatherPort) import the value object directly.
export '../value_objects/weather_forecast.dart';

/// Shifts a care task's base due instant earlier or later based on the forecast, so
/// watering tracks real conditions rather than a fixed calendar. This is an overlay
/// applied *on read*: it never mutates the schedule, and the caller only invokes it for
/// `weatherSensitive` schedules.
///
/// Pure and deterministic — given the same inputs it always returns the same instant.
class WeatherPolicy {
  const WeatherPolicy();

  // --- "Balanced" sensitivity preset ---------------------------------------------------
  // These six numbers ARE the policy's character (see the sensitivity decision). Retuning
  // to a more conservative or more responsive profile is a change to these alone; the math
  // and tests below are preset-agnostic.
  static const int _rainStepMm = 10; // every full 10mm of expected rain...
  static const int _rainDelayDays = 3; // ...delays an outdoor watering this many days.
  static const int _hotThresholdC = 30; // high temp at/above this pulls watering earlier.
  static const int _dryThresholdPct = 30; // humidity at/below this pulls watering earlier.
  static const int _maxDelayDays = 5; // safety bound: never push watering more than this...
  static const int _maxAdvanceDays = 2; // ...nor pull it earlier than this.

  /// The weather-adjusted due instant. Returns [baseDue] unchanged when the forecast
  /// warrants no change.
  tz.TZDateTime adjust({
    required tz.TZDateTime baseDue,
    required WeatherForecast forecast,
    required bool outdoor,
  }) {
    var shiftDays = 0;

    // Rain only reaches outdoor plants; delay the watering because the sky is doing the job.
    if (outdoor) {
      shiftDays += (forecast.expectedRainMm ~/ _rainStepMm) * _rainDelayDays;
    }

    // A hot day dries the soil faster, so bring the watering forward.
    if (forecast.highTempC >= _hotThresholdC) {
      shiftDays -= 1;
    }

    // Dry air wicks moisture out of the soil too — pull the watering forward as well.
    if (forecast.humidityPct <= _dryThresholdPct) {
      shiftDays -= 1;
    }

    // Safety bound so a wild forecast can never strand a plant. The upper bound is reachable
    // via heavy rain; the lower bound is a forward guard — today's factors only ever total
    // -2, exactly the floor.
    shiftDays = shiftDays.clamp(-_maxAdvanceDays, _maxDelayDays).toInt();

    return _shiftDays(baseDue, shiftDays);
  }

  /// Move [due] by [days] calendar days, preserving its wall-clock time. Uses the
  /// [tz.TZDateTime] constructor so month rollover and DST are handled by the timezone
  /// database rather than by adding a raw 24h*n Duration (which drifts across DST).
  tz.TZDateTime _shiftDays(tz.TZDateTime due, int days) {
    if (days == 0) return due;
    return tz.TZDateTime(
      due.location,
      due.year,
      due.month,
      due.day + days,
      due.hour,
      due.minute,
    );
  }
}
