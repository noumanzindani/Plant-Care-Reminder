// The real Open-Meteo-backed WeatherPort, verified with a hand-rolled fake
// HttpClientAdapter (canned JSON in, captured request out) and a fake LocationPort — no
// network, no geolocator, no new dependency. Open-Meteo is keyless.

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plant_care_reminder/core/data/weather/open_meteo_weather_adapter.dart';
import 'package:plant_care_reminder/core/domain/ports/location_port.dart';
import 'package:plant_care_reminder/core/domain/value_objects/geo_coordinates.dart';

/// Captures the request and returns a canned body (or a chosen HTTP status).
class _FakeHttp implements HttpClientAdapter {
  _FakeHttp(this.respond, {this.status = 200});

  final Map<String, dynamic> Function(RequestOptions options) respond;
  final int status;
  RequestOptions? lastOptions;
  var calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    calls++;
    return ResponseBody.fromString(
      jsonEncode(respond(options)),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _FakeLocation implements LocationPort {
  _FakeLocation(this._coords);

  final GeoCoordinates? _coords;

  @override
  Future<GeoCoordinates?> current() async => _coords;
}

({OpenMeteoWeatherAdapter adapter, _FakeHttp http}) build({
  required GeoCoordinates? location,
  Map<String, dynamic> Function(RequestOptions)? respond,
  int status = 200,
}) {
  final dio = Dio();
  final http = _FakeHttp(respond ?? (_) => const {}, status: status);
  dio.httpClientAdapter = http;
  final adapter = OpenMeteoWeatherAdapter(dio, _FakeLocation(location));
  return (adapter: adapter, http: http);
}

void main() {
  test('maps the Open-Meteo response into a forecast for the located coordinates', () async {
    final built = build(
      location: const GeoCoordinates(latitude: 40.7, longitude: -74.0),
      respond: (_) => {
        'daily': {
          'time': ['2026-07-03', '2026-07-04'],
          'precipitation_sum': [5.0, 7.0],
          'temperature_2m_max': [28.0, 31.0],
        },
        'hourly': {
          'time': ['2026-07-03T00:00', '2026-07-03T01:00', '2026-07-03T02:00'],
          'relative_humidity_2m': [60, 45, 70],
        },
      },
    );

    final forecast = await built.adapter.forecast();

    expect(forecast, isNotNull);
    expect(forecast!.expectedRainMm, 12.0); // 5 + 7
    expect(forecast.highTempC, 31.0); // max(28, 31)
    expect(forecast.humidityPct, 45.0); // driest hour: min(60, 45, 70)

    // The request contract Open-Meteo needs to return the fields we summarise.
    final q = built.http.lastOptions!.queryParameters;
    expect(q['latitude'], 40.7);
    expect(q['longitude'], -74.0);
    expect(q['daily'], 'precipitation_sum,temperature_2m_max');
    expect(q['hourly'], 'relative_humidity_2m');
    expect(q['forecast_days'], 2);
  });

  test('returns null and makes no request when the location is unavailable', () async {
    final built = build(location: null);

    final forecast = await built.adapter.forecast();

    expect(forecast, isNull);
    expect(built.http.calls, 0); // no point calling Open-Meteo without coordinates
  });

  test('returns null when the request fails (offline / server error)', () async {
    final built = build(
      location: const GeoCoordinates(latitude: 1, longitude: 2),
      status: 500,
      respond: (_) => {'error': true},
    );

    final forecast = await built.adapter.forecast();

    expect(forecast, isNull);
  });

  test('returns null on an unexpected response body', () async {
    final built = build(
      location: const GeoCoordinates(latitude: 1, longitude: 2),
      respond: (_) => {'unexpected': 'shape'}, // no daily/hourly keys
    );

    final forecast = await built.adapter.forecast();

    expect(forecast, isNull);
  });
}
