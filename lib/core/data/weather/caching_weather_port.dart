import '../../domain/ports/clock.dart';
import '../../domain/ports/weather_port.dart';
import '../../domain/value_objects/weather_forecast.dart';

/// A time-to-live cache in front of another [WeatherPort].
///
/// The reconciler can run several times in quick succession (app resume, a care-log write,
/// a timezone change), and each run asks for the forecast. This wrapper ensures those runs
/// share one forecast instead of each hitting the network. A `null` result (forecast
/// unavailable) is never *served* from the cache — the read requires a non-null cached
/// forecast — so a failure is retried on the next reconcile rather than pinning the app to
/// base cadence for the whole TTL.
class CachingWeatherPort implements WeatherPort {
  CachingWeatherPort(
    this._inner,
    this._clock, {
    Duration ttl = const Duration(hours: 3),
  }) : _ttl = ttl;

  final WeatherPort _inner;
  final Clock _clock;
  final Duration _ttl;

  WeatherForecast? _cached;
  DateTime? _fetchedAt;

  @override
  Future<WeatherForecast?> forecast() async {
    final now = _clock.now();
    final fetchedAt = _fetchedAt;
    if (_cached != null && fetchedAt != null && now.difference(fetchedAt) < _ttl) {
      return _cached;
    }

    _cached = await _inner.forecast();
    _fetchedAt = now;
    return _cached;
  }
}
