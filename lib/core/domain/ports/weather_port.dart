import '../value_objects/weather_forecast.dart';

/// Supplies the current forecast for the user's coarse location.
///
/// Returns `null` when a trustworthy forecast is unavailable — offline, location
/// permission denied, or the cache is too stale — in which case the caller falls back to
/// the plant's base cadence (the weather overlay is an enhancement, never a dependency of
/// the core reminder loop).
///
/// Domain port: an Open-Meteo adapter implements it in the data/infra layer, so the
/// domain core never depends on HTTP or any specific weather provider.
abstract class WeatherPort {
  Future<WeatherForecast?> forecast();
}
