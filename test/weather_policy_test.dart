// Pure-Dart tests for the weather overlay — the "should this watering slide earlier or
// later given the forecast?" math. Runs under the default test binding (no widgets), with
// a real timezone database so the bounded clamp is exercised against real wall-clock dates.
//
// The policy is an overlay applied on read: it takes the cadence engine's base due instant
// and returns an adjusted one. It never mutates the schedule, and the result is always
// clamped to [baseDue - 2d, baseDue + 5d] so a wild forecast can't strand a plant.

import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:plant_care_reminder/core/domain/services/weather_policy.dart';

void main() {
  setUpAll(tz_data.initializeTimeZones);

  const policy = WeatherPolicy();

  test('a mild forecast leaves the due date unchanged', () {
    final ny = tz.getLocation('America/New_York');
    final baseDue = tz.TZDateTime(ny, 2026, 6, 8, 9, 0);

    final adjusted = policy.adjust(
      baseDue: baseDue,
      forecast: const WeatherForecast(
        expectedRainMm: 0,
        highTempC: 21,
        humidityPct: 55,
      ),
      outdoor: true,
    );

    expect(adjusted, baseDue);
  });

  test('outdoor: rain delays the watering (the sky is doing the job)', () {
    final ny = tz.getLocation('America/New_York');
    final baseDue = tz.TZDateTime(ny, 2026, 6, 8, 9, 0);

    final adjusted = policy.adjust(
      baseDue: baseDue,
      forecast: const WeatherForecast(
        expectedRainMm: 12, // over the 10mm threshold
        highTempC: 21,
        humidityPct: 55,
      ),
      outdoor: true,
    );

    // +3 days per 10mm of expected rain.
    expect(adjusted, tz.TZDateTime(ny, 2026, 6, 11, 9, 0));
  });

  test('indoor: rain is ignored (no rain reaches an indoor plant)', () {
    final ny = tz.getLocation('America/New_York');
    final baseDue = tz.TZDateTime(ny, 2026, 6, 8, 9, 0);

    final adjusted = policy.adjust(
      baseDue: baseDue,
      forecast: const WeatherForecast(
        expectedRainMm: 40, // pouring outside, but the plant lives indoors
        highTempC: 21,
        humidityPct: 55,
      ),
      outdoor: false,
    );

    expect(adjusted, baseDue);
  });

  test('heat: a hot day pulls the watering earlier (soil dries faster)', () {
    final ny = tz.getLocation('America/New_York');
    final baseDue = tz.TZDateTime(ny, 2026, 6, 8, 9, 0);

    final adjusted = policy.adjust(
      baseDue: baseDue,
      forecast: const WeatherForecast(
        expectedRainMm: 0,
        highTempC: 32, // at/above the 30C threshold
        humidityPct: 55,
      ),
      outdoor: true,
    );

    expect(adjusted, tz.TZDateTime(ny, 2026, 6, 7, 9, 0)); // -1 day
  });

  test('dry air: low humidity pulls the watering earlier', () {
    final ny = tz.getLocation('America/New_York');
    final baseDue = tz.TZDateTime(ny, 2026, 6, 8, 9, 0);

    final adjusted = policy.adjust(
      baseDue: baseDue,
      forecast: const WeatherForecast(
        expectedRainMm: 0,
        highTempC: 21,
        humidityPct: 25, // at/below the 30% threshold
      ),
      outdoor: true,
    );

    expect(adjusted, tz.TZDateTime(ny, 2026, 6, 7, 9, 0)); // -1 day
  });

  // Emergent from the heat + dry-air rules; pinned here as a regression guard.
  test('heat and dry air stack: hot AND dry pulls the watering two days earlier', () {
    final ny = tz.getLocation('America/New_York');
    final baseDue = tz.TZDateTime(ny, 2026, 6, 8, 9, 0);

    final adjusted = policy.adjust(
      baseDue: baseDue,
      forecast: const WeatherForecast(
        expectedRainMm: 0,
        highTempC: 33, // hot
        humidityPct: 20, // and dry
      ),
      outdoor: true,
    );

    expect(adjusted, tz.TZDateTime(ny, 2026, 6, 6, 9, 0)); // -2 days
  });

  test('a downpour cannot push the watering more than 5 days out (upper bound)', () {
    final ny = tz.getLocation('America/New_York');
    final baseDue = tz.TZDateTime(ny, 2026, 6, 8, 9, 0);

    final adjusted = policy.adjust(
      baseDue: baseDue,
      forecast: const WeatherForecast(
        expectedRainMm: 25, // (25 ~/ 10) * 3 = +6 days raw, must clamp to +5
        highTempC: 21,
        humidityPct: 55,
      ),
      outdoor: true,
    );

    expect(adjusted, tz.TZDateTime(ny, 2026, 6, 13, 9, 0)); // +5, not +6
  });
}
