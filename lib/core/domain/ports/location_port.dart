import '../value_objects/geo_coordinates.dart';

/// Supplies the device's current coarse location.
///
/// Returns `null` when a location is unavailable — permission denied, services off, or no
/// fix — so callers (e.g. the weather adapter) can degrade gracefully rather than block.
/// Domain port: a geolocator adapter implements it in the infra layer.
abstract class LocationPort {
  Future<GeoCoordinates?> current();
}
