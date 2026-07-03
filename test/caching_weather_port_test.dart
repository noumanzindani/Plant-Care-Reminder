// A TTL cache in front of a WeatherPort, so repeated reconciles within a short window
// reuse one forecast instead of hammering Open-Meteo. Pure Dart, driven by an injected
// Clock — no real time, no network.

import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/data/weather/caching_weather_port.dart';
import 'package:plant_care_reminder/core/domain/ports/clock.dart';
import 'package:plant_care_reminder/core/domain/ports/weather_port.dart';
import 'package:plant_care_reminder/core/domain/value_objects/weather_forecast.dart';

const _forecastA =
    WeatherForecast(expectedRainMm: 3, highTempC: 24, humidityPct: 50);
const _forecastB =
    WeatherForecast(expectedRainMm: 9, highTempC: 31, humidityPct: 28);

/// Returns each scripted response in turn (repeating the last), counting calls.
class _FakeInner implements WeatherPort {
  _FakeInner(this._script);

  final List<WeatherForecast?> _script;
  var calls = 0;

  @override
  Future<WeatherForecast?> forecast() async {
    final index = calls < _script.length ? calls : _script.length - 1;
    calls++;
    return _script[index];
  }
}

class _FakeClock implements Clock {
  _FakeClock(this._now);

  DateTime _now;

  void advance(Duration d) => _now = _now.add(d);

  @override
  DateTime now() => _now;
}

void main() {
  test('serves a cached forecast within the TTL without re-fetching', () async {
    final inner = _FakeInner([_forecastA]);
    final clock = _FakeClock(DateTime.utc(2026, 7, 3, 12));
    final port = CachingWeatherPort(inner, clock, ttl: const Duration(hours: 3));

    final first = await port.forecast();
    clock.advance(const Duration(hours: 1)); // still within the 3h TTL
    final second = await port.forecast();

    expect(first, _forecastA);
    expect(second, _forecastA);
    expect(inner.calls, 1); // second call served from cache
  });

  test('re-fetches once the TTL has expired', () async {
    final inner = _FakeInner([_forecastA, _forecastB]);
    final clock = _FakeClock(DateTime.utc(2026, 7, 3, 12));
    final port = CachingWeatherPort(inner, clock, ttl: const Duration(hours: 3));

    await port.forecast(); // caches A at 12:00
    clock.advance(const Duration(hours: 4)); // past the 3h TTL
    final second = await port.forecast();

    expect(second, _forecastB);
    expect(inner.calls, 2);
  });

  test('does not cache a null result — keeps retrying until a forecast arrives', () async {
    final inner = _FakeInner([null, _forecastA]);
    final clock = _FakeClock(DateTime.utc(2026, 7, 3, 12));
    final port = CachingWeatherPort(inner, clock, ttl: const Duration(hours: 3));

    final first = await port.forecast(); // null (unavailable)
    final second = await port.forecast(); // clock unchanged, but null wasn't cached

    expect(first, isNull);
    expect(second, _forecastA);
    expect(inner.calls, 2);
  });
}
