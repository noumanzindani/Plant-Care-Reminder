import '../../domain/value_objects/enums.dart';

/// One bundled catalog entry. Deterministic [id] slugs mean a re-seed (or a future remote
/// delta) upserts in place instead of duplicating. Watering intervals are conservative
/// average-indoor defaults — the app treats them as a starting point the user edits and
/// (Phase 5) weather adjusts, never a hard rule.
class SpeciesSeedRow {
  const SpeciesSeedRow({
    required this.id,
    required this.scientificName,
    required this.commonName,
    required this.wateringIntervalDays,
    this.fertilizeIntervalDays,
    this.family,
    this.light,
    this.toxicToPets,
  });

  final String id;
  final String scientificName;
  final String commonName;
  final int wateringIntervalDays;
  final int? fertilizeIntervalDays;
  final String? family;
  final LightLevel? light;
  final bool? toxicToPets;
}

/// Bump when [kSpeciesSeed] changes so [CatalogSeeder] re-applies it on next launch.
const int kCatalogSeedVersion = 1;

/// A small starter catalog of common houseplants shipped in the app binary — enough to
/// make species search and smart defaults useful fully offline, before any backend.
const List<SpeciesSeedRow> kSpeciesSeed = [
  SpeciesSeedRow(
    id: 'monstera-deliciosa',
    scientificName: 'Monstera deliciosa',
    commonName: 'Swiss cheese plant',
    wateringIntervalDays: 7,
    fertilizeIntervalDays: 30,
    family: 'Araceae',
    light: LightLevel.medium,
    toxicToPets: true,
  ),
  SpeciesSeedRow(
    id: 'dracaena-trifasciata',
    scientificName: 'Dracaena trifasciata',
    commonName: 'Snake plant',
    wateringIntervalDays: 14,
    fertilizeIntervalDays: 60,
    family: 'Asparagaceae',
    light: LightLevel.low,
    toxicToPets: true,
  ),
  SpeciesSeedRow(
    id: 'epipremnum-aureum',
    scientificName: 'Epipremnum aureum',
    commonName: 'Golden pothos',
    wateringIntervalDays: 7,
    fertilizeIntervalDays: 30,
    family: 'Araceae',
    light: LightLevel.low,
    toxicToPets: true,
  ),
  SpeciesSeedRow(
    id: 'zamioculcas-zamiifolia',
    scientificName: 'Zamioculcas zamiifolia',
    commonName: 'ZZ plant',
    wateringIntervalDays: 14,
    fertilizeIntervalDays: 60,
    family: 'Araceae',
    light: LightLevel.low,
    toxicToPets: true,
  ),
  SpeciesSeedRow(
    id: 'spathiphyllum-wallisii',
    scientificName: 'Spathiphyllum wallisii',
    commonName: 'Peace lily',
    wateringIntervalDays: 5,
    fertilizeIntervalDays: 30,
    family: 'Araceae',
    light: LightLevel.low,
    toxicToPets: true,
  ),
  SpeciesSeedRow(
    id: 'chlorophytum-comosum',
    scientificName: 'Chlorophytum comosum',
    commonName: 'Spider plant',
    wateringIntervalDays: 7,
    fertilizeIntervalDays: 30,
    family: 'Asparagaceae',
    light: LightLevel.medium,
    toxicToPets: false,
  ),
  SpeciesSeedRow(
    id: 'ficus-lyrata',
    scientificName: 'Ficus lyrata',
    commonName: 'Fiddle leaf fig',
    wateringIntervalDays: 7,
    fertilizeIntervalDays: 30,
    family: 'Moraceae',
    light: LightLevel.bright,
    toxicToPets: true,
  ),
  SpeciesSeedRow(
    id: 'ficus-elastica',
    scientificName: 'Ficus elastica',
    commonName: 'Rubber plant',
    wateringIntervalDays: 7,
    fertilizeIntervalDays: 30,
    family: 'Moraceae',
    light: LightLevel.medium,
    toxicToPets: true,
  ),
  SpeciesSeedRow(
    id: 'aloe-vera',
    scientificName: 'Aloe barbadensis miller',
    commonName: 'Aloe vera',
    wateringIntervalDays: 14,
    fertilizeIntervalDays: 60,
    family: 'Asphodelaceae',
    light: LightLevel.bright,
    toxicToPets: true,
  ),
  SpeciesSeedRow(
    id: 'crassula-ovata',
    scientificName: 'Crassula ovata',
    commonName: 'Jade plant',
    wateringIntervalDays: 14,
    fertilizeIntervalDays: 60,
    family: 'Crassulaceae',
    light: LightLevel.bright,
    toxicToPets: true,
  ),
  SpeciesSeedRow(
    id: 'nephrolepis-exaltata',
    scientificName: 'Nephrolepis exaltata',
    commonName: 'Boston fern',
    wateringIntervalDays: 4,
    fertilizeIntervalDays: 30,
    family: 'Nephrolepidaceae',
    light: LightLevel.medium,
    toxicToPets: false,
  ),
  SpeciesSeedRow(
    id: 'pilea-peperomioides',
    scientificName: 'Pilea peperomioides',
    commonName: 'Chinese money plant',
    wateringIntervalDays: 7,
    fertilizeIntervalDays: 30,
    family: 'Urticaceae',
    light: LightLevel.medium,
    toxicToPets: false,
  ),
  SpeciesSeedRow(
    id: 'philodendron-hederaceum',
    scientificName: 'Philodendron hederaceum',
    commonName: 'Heartleaf philodendron',
    wateringIntervalDays: 7,
    fertilizeIntervalDays: 30,
    family: 'Araceae',
    light: LightLevel.medium,
    toxicToPets: true,
  ),
  SpeciesSeedRow(
    id: 'hedera-helix',
    scientificName: 'Hedera helix',
    commonName: 'English ivy',
    wateringIntervalDays: 5,
    fertilizeIntervalDays: 30,
    family: 'Araliaceae',
    light: LightLevel.medium,
    toxicToPets: true,
  ),
  SpeciesSeedRow(
    id: 'calathea-orbifolia',
    scientificName: 'Goeppertia orbifolia',
    commonName: 'Calathea orbifolia',
    wateringIntervalDays: 5,
    fertilizeIntervalDays: 30,
    family: 'Marantaceae',
    light: LightLevel.medium,
    toxicToPets: false,
  ),
  SpeciesSeedRow(
    id: 'phalaenopsis',
    scientificName: 'Phalaenopsis spp.',
    commonName: 'Moth orchid',
    wateringIntervalDays: 7,
    fertilizeIntervalDays: 14,
    family: 'Orchidaceae',
    light: LightLevel.medium,
    toxicToPets: false,
  ),
  SpeciesSeedRow(
    id: 'dypsis-lutescens',
    scientificName: 'Dypsis lutescens',
    commonName: 'Areca palm',
    wateringIntervalDays: 5,
    fertilizeIntervalDays: 30,
    family: 'Arecaceae',
    light: LightLevel.medium,
    toxicToPets: false,
  ),
  SpeciesSeedRow(
    id: 'saintpaulia-ionantha',
    scientificName: 'Saintpaulia ionantha',
    commonName: 'African violet',
    wateringIntervalDays: 5,
    fertilizeIntervalDays: 14,
    family: 'Gesneriaceae',
    light: LightLevel.medium,
    toxicToPets: false,
  ),
];
