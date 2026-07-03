import 'dart:math' as math;

import 'package:dio/dio.dart';

import '../../domain/ports/location_port.dart';
import '../../domain/ports/weather_port.dart';
import '../../domain/value_objects/weather_forecast.dart';

/// A [WeatherPort] backed by the free, keyless Open-Meteo forecast API.
///
/// Resolves the device's coarse location, asks Open-Meteo for a short lookahead, and
/// summarises the response into a [WeatherForecast] the pure `WeatherPolicy` can reason
/// about. Any failure — no location, network error, or an unexpected body — yields `null`
/// so the reminder engine falls back to the base cadence.
class OpenMeteoWeatherAdapter implements WeatherPort {
  OpenMeteoWeatherAdapter(this._dio, this._location);

  final Dio _dio;
  final LocationPort _location;

  static const _endpoint = 'https://api.open-meteo.com/v1/forecast';

  /// How many days ahead to summarise — rain that arrives within a couple of days is what
  /// changes today's watering decision.
  static const _forecastDays = 2;

  @override
  Future<WeatherForecast?> forecast() async {
    final coords = await _location.current();
    if (coords == null) return null;

    // A network error, non-2xx status, or an unexpected body all degrade to null so the
    // reminder engine simply uses the base cadence — weather is an enhancement, never a
    // dependency of the core loop.
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _endpoint,
        queryParameters: {
          'latitude': coords.latitude,
          'longitude': coords.longitude,
          'daily': 'precipitation_sum,temperature_2m_max',
          'hourly': 'relative_humidity_2m',
          'forecast_days': _forecastDays,
          'timezone': 'auto',
        },
      );

      final data = response.data!;
      final daily = data['daily'] as Map<String, dynamic>;
      final hourly = data['hourly'] as Map<String, dynamic>;

      final rain = _doubles(daily['precipitation_sum'])
          .fold<double>(0, (sum, mm) => sum + mm);
      final highTemp = _doubles(daily['temperature_2m_max'])
          .reduce((a, b) => math.max(a, b));
      // Driest expected hour: low humidity is what accelerates soil drying.
      final humidity = _doubles(hourly['relative_humidity_2m'])
          .reduce((a, b) => math.min(a, b));

      return WeatherForecast(
        expectedRainMm: rain,
        highTempC: highTemp,
        humidityPct: humidity,
      );
    } catch (_) {
      return null;
    }
  }

  Iterable<double> _doubles(dynamic list) =>
      (list as List).map((e) => (e as num).toDouble());
}
