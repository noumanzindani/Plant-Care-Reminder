/// A coarse geographic location — all the weather overlay needs to fetch a local forecast.
/// Pure value object; the `LocationPort` adapter (geolocator) produces it.
class GeoCoordinates {
  const GeoCoordinates({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}
