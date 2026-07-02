import '../value_objects/enums.dart';

/// A species' default care cadences — the "smart defaults" the add-plant flow uses to
/// pre-fill a schedule when a user picks a species from the catalog.
class CareDefaults {
  const CareDefaults({
    required this.wateringIntervalDays,
    this.fertilizeIntervalDays,
  });

  final int wateringIntervalDays;
  final int? fertilizeIntervalDays;
}

/// A lightweight catalog search hit (what a search list renders).
class SpeciesSummary {
  const SpeciesSummary({
    required this.id,
    required this.scientificName,
    required this.commonName,
  });

  final String id;
  final String scientificName;
  final String commonName;
}

/// A full catalog record for one species.
class SpeciesDetail {
  const SpeciesDetail({
    required this.id,
    required this.scientificName,
    required this.commonName,
    required this.care,
    this.family,
    this.light,
    this.toxicToPets,
  });

  final String id;
  final String scientificName;
  final String commonName;
  final CareDefaults care;
  final String? family;
  final LightLevel? light;
  final bool? toxicToPets;
}

/// The catalog seam. The core never knows whether species come from a bundled seed, the
/// local Drift cache, or a remote Perenual-backed API — only this interface. This is what
/// keeps the offline seed and the future remote catalog interchangeable.
abstract class SpeciesCatalogPort {
  /// Search species by common or scientific name. An empty [query] returns a small
  /// default set (so the picker is useful before the user types).
  Future<List<SpeciesSummary>> search(String query, {int limit = 20});

  /// Full detail for one species [id], or null if it is not in the catalog.
  Future<SpeciesDetail?> getById(String id);
}
