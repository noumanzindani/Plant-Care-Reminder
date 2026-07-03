import 'package:geolocator/geolocator.dart';

import '../../domain/ports/location_port.dart';
import '../../domain/value_objects/geo_coordinates.dart';

/// [LocationPort] backed by the `geolocator` plugin.
///
/// Coarse accuracy is deliberate — weather forecasts are city-scale, so [LocationAccuracy.low]
/// is enough and is cheaper on battery and permissions. Every failure path (services off,
/// permission denied/deniedForever, no fix, timeout, or any plugin error) collapses to
/// `null`, honoring the port contract so the reminder engine simply falls back to the base
/// cadence.
///
/// This is the untestable plugin edge: it wraps static platform-channel calls, so it is
/// analyze/build-verified. The behavior it feeds — Open-Meteo mapping, the overlay math,
/// and the TTL cache — is unit-tested against fakes elsewhere.
class GeolocatorLocationAdapter implements LocationPort {
  const GeolocatorLocationAdapter();

  @override
  Future<GeoCoordinates?> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return GeoCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      // Any plugin/permission/timeout failure -> no location -> base cadence.
      return null;
    }
  }
}
