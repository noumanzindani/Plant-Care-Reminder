/// A minimal weather summary the care policy reasons about. Pure value object with no
/// Flutter/HTTP dependencies — the `WeatherPort` adapter (Open-Meteo) maps its response
/// into this, so the domain never knows about the provider's JSON schema. The lookahead
/// window (how far ahead the rain/temperature is summarised) is the adapter's concern.
class WeatherForecast {
  const WeatherForecast({
    required this.expectedRainMm,
    required this.highTempC,
    required this.humidityPct,
  });

  /// Total expected rainfall over the lookahead window, in millimetres.
  final double expectedRainMm;

  /// Forecast daily high temperature, in degrees Celsius.
  final double highTempC;

  /// Forecast relative humidity as a percentage (0..100).
  final double humidityPct;
}
