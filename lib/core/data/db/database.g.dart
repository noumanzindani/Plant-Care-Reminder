// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SpeciesTable extends Species with TableInfo<$SpeciesTable, SpeciesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scientificNameMeta = const VerificationMeta(
    'scientificName',
  );
  @override
  late final GeneratedColumn<String> scientificName = GeneratedColumn<String>(
    'scientific_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commonNameMeta = const VerificationMeta(
    'commonName',
  );
  @override
  late final GeneratedColumn<String> commonName = GeneratedColumn<String>(
    'common_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyMeta = const VerificationMeta('family');
  @override
  late final GeneratedColumn<String> family = GeneratedColumn<String>(
    'family',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wateringIntervalDaysMeta =
      const VerificationMeta('wateringIntervalDays');
  @override
  late final GeneratedColumn<int> wateringIntervalDays = GeneratedColumn<int>(
    'watering_interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fertilizeIntervalDaysMeta =
      const VerificationMeta('fertilizeIntervalDays');
  @override
  late final GeneratedColumn<int> fertilizeIntervalDays = GeneratedColumn<int>(
    'fertilize_interval_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LightLevel?, String> lightLevel =
      GeneratedColumn<String>(
        'light_level',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<LightLevel?>($SpeciesTable.$converterlightLeveln);
  static const VerificationMeta _toxicToPetsMeta = const VerificationMeta(
    'toxicToPets',
  );
  @override
  late final GeneratedColumn<bool> toxicToPets = GeneratedColumn<bool>(
    'toxic_to_pets',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("toxic_to_pets" IN (0, 1))',
    ),
  );
  static const VerificationMeta _catalogVersionMeta = const VerificationMeta(
    'catalogVersion',
  );
  @override
  late final GeneratedColumn<int> catalogVersion = GeneratedColumn<int>(
    'catalog_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scientificName,
    commonName,
    family,
    wateringIntervalDays,
    fertilizeIntervalDays,
    lightLevel,
    toxicToPets,
    catalogVersion,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'species';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpeciesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('scientific_name')) {
      context.handle(
        _scientificNameMeta,
        scientificName.isAcceptableOrUnknown(
          data['scientific_name']!,
          _scientificNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scientificNameMeta);
    }
    if (data.containsKey('common_name')) {
      context.handle(
        _commonNameMeta,
        commonName.isAcceptableOrUnknown(data['common_name']!, _commonNameMeta),
      );
    } else if (isInserting) {
      context.missing(_commonNameMeta);
    }
    if (data.containsKey('family')) {
      context.handle(
        _familyMeta,
        family.isAcceptableOrUnknown(data['family']!, _familyMeta),
      );
    }
    if (data.containsKey('watering_interval_days')) {
      context.handle(
        _wateringIntervalDaysMeta,
        wateringIntervalDays.isAcceptableOrUnknown(
          data['watering_interval_days']!,
          _wateringIntervalDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wateringIntervalDaysMeta);
    }
    if (data.containsKey('fertilize_interval_days')) {
      context.handle(
        _fertilizeIntervalDaysMeta,
        fertilizeIntervalDays.isAcceptableOrUnknown(
          data['fertilize_interval_days']!,
          _fertilizeIntervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('toxic_to_pets')) {
      context.handle(
        _toxicToPetsMeta,
        toxicToPets.isAcceptableOrUnknown(
          data['toxic_to_pets']!,
          _toxicToPetsMeta,
        ),
      );
    }
    if (data.containsKey('catalog_version')) {
      context.handle(
        _catalogVersionMeta,
        catalogVersion.isAcceptableOrUnknown(
          data['catalog_version']!,
          _catalogVersionMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeciesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeciesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      scientificName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scientific_name'],
      )!,
      commonName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}common_name'],
      )!,
      family: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family'],
      ),
      wateringIntervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}watering_interval_days'],
      )!,
      fertilizeIntervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fertilize_interval_days'],
      ),
      lightLevel: $SpeciesTable.$converterlightLeveln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}light_level'],
        ),
      ),
      toxicToPets: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}toxic_to_pets'],
      ),
      catalogVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}catalog_version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SpeciesTable createAlias(String alias) {
    return $SpeciesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LightLevel, String, String> $converterlightLevel =
      const EnumNameConverter<LightLevel>(LightLevel.values);
  static JsonTypeConverter2<LightLevel?, String?, String?>
  $converterlightLeveln = JsonTypeConverter2.asNullable($converterlightLevel);
}

class SpeciesRow extends DataClass implements Insertable<SpeciesRow> {
  final String id;
  final String scientificName;
  final String commonName;
  final String? family;
  final int wateringIntervalDays;
  final int? fertilizeIntervalDays;
  final LightLevel? lightLevel;
  final bool? toxicToPets;
  final int catalogVersion;
  final DateTime updatedAt;
  const SpeciesRow({
    required this.id,
    required this.scientificName,
    required this.commonName,
    this.family,
    required this.wateringIntervalDays,
    this.fertilizeIntervalDays,
    this.lightLevel,
    this.toxicToPets,
    required this.catalogVersion,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['scientific_name'] = Variable<String>(scientificName);
    map['common_name'] = Variable<String>(commonName);
    if (!nullToAbsent || family != null) {
      map['family'] = Variable<String>(family);
    }
    map['watering_interval_days'] = Variable<int>(wateringIntervalDays);
    if (!nullToAbsent || fertilizeIntervalDays != null) {
      map['fertilize_interval_days'] = Variable<int>(fertilizeIntervalDays);
    }
    if (!nullToAbsent || lightLevel != null) {
      map['light_level'] = Variable<String>(
        $SpeciesTable.$converterlightLeveln.toSql(lightLevel),
      );
    }
    if (!nullToAbsent || toxicToPets != null) {
      map['toxic_to_pets'] = Variable<bool>(toxicToPets);
    }
    map['catalog_version'] = Variable<int>(catalogVersion);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SpeciesCompanion toCompanion(bool nullToAbsent) {
    return SpeciesCompanion(
      id: Value(id),
      scientificName: Value(scientificName),
      commonName: Value(commonName),
      family: family == null && nullToAbsent
          ? const Value.absent()
          : Value(family),
      wateringIntervalDays: Value(wateringIntervalDays),
      fertilizeIntervalDays: fertilizeIntervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(fertilizeIntervalDays),
      lightLevel: lightLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(lightLevel),
      toxicToPets: toxicToPets == null && nullToAbsent
          ? const Value.absent()
          : Value(toxicToPets),
      catalogVersion: Value(catalogVersion),
      updatedAt: Value(updatedAt),
    );
  }

  factory SpeciesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeciesRow(
      id: serializer.fromJson<String>(json['id']),
      scientificName: serializer.fromJson<String>(json['scientificName']),
      commonName: serializer.fromJson<String>(json['commonName']),
      family: serializer.fromJson<String?>(json['family']),
      wateringIntervalDays: serializer.fromJson<int>(
        json['wateringIntervalDays'],
      ),
      fertilizeIntervalDays: serializer.fromJson<int?>(
        json['fertilizeIntervalDays'],
      ),
      lightLevel: $SpeciesTable.$converterlightLeveln.fromJson(
        serializer.fromJson<String?>(json['lightLevel']),
      ),
      toxicToPets: serializer.fromJson<bool?>(json['toxicToPets']),
      catalogVersion: serializer.fromJson<int>(json['catalogVersion']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scientificName': serializer.toJson<String>(scientificName),
      'commonName': serializer.toJson<String>(commonName),
      'family': serializer.toJson<String?>(family),
      'wateringIntervalDays': serializer.toJson<int>(wateringIntervalDays),
      'fertilizeIntervalDays': serializer.toJson<int?>(fertilizeIntervalDays),
      'lightLevel': serializer.toJson<String?>(
        $SpeciesTable.$converterlightLeveln.toJson(lightLevel),
      ),
      'toxicToPets': serializer.toJson<bool?>(toxicToPets),
      'catalogVersion': serializer.toJson<int>(catalogVersion),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SpeciesRow copyWith({
    String? id,
    String? scientificName,
    String? commonName,
    Value<String?> family = const Value.absent(),
    int? wateringIntervalDays,
    Value<int?> fertilizeIntervalDays = const Value.absent(),
    Value<LightLevel?> lightLevel = const Value.absent(),
    Value<bool?> toxicToPets = const Value.absent(),
    int? catalogVersion,
    DateTime? updatedAt,
  }) => SpeciesRow(
    id: id ?? this.id,
    scientificName: scientificName ?? this.scientificName,
    commonName: commonName ?? this.commonName,
    family: family.present ? family.value : this.family,
    wateringIntervalDays: wateringIntervalDays ?? this.wateringIntervalDays,
    fertilizeIntervalDays: fertilizeIntervalDays.present
        ? fertilizeIntervalDays.value
        : this.fertilizeIntervalDays,
    lightLevel: lightLevel.present ? lightLevel.value : this.lightLevel,
    toxicToPets: toxicToPets.present ? toxicToPets.value : this.toxicToPets,
    catalogVersion: catalogVersion ?? this.catalogVersion,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SpeciesRow copyWithCompanion(SpeciesCompanion data) {
    return SpeciesRow(
      id: data.id.present ? data.id.value : this.id,
      scientificName: data.scientificName.present
          ? data.scientificName.value
          : this.scientificName,
      commonName: data.commonName.present
          ? data.commonName.value
          : this.commonName,
      family: data.family.present ? data.family.value : this.family,
      wateringIntervalDays: data.wateringIntervalDays.present
          ? data.wateringIntervalDays.value
          : this.wateringIntervalDays,
      fertilizeIntervalDays: data.fertilizeIntervalDays.present
          ? data.fertilizeIntervalDays.value
          : this.fertilizeIntervalDays,
      lightLevel: data.lightLevel.present
          ? data.lightLevel.value
          : this.lightLevel,
      toxicToPets: data.toxicToPets.present
          ? data.toxicToPets.value
          : this.toxicToPets,
      catalogVersion: data.catalogVersion.present
          ? data.catalogVersion.value
          : this.catalogVersion,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesRow(')
          ..write('id: $id, ')
          ..write('scientificName: $scientificName, ')
          ..write('commonName: $commonName, ')
          ..write('family: $family, ')
          ..write('wateringIntervalDays: $wateringIntervalDays, ')
          ..write('fertilizeIntervalDays: $fertilizeIntervalDays, ')
          ..write('lightLevel: $lightLevel, ')
          ..write('toxicToPets: $toxicToPets, ')
          ..write('catalogVersion: $catalogVersion, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scientificName,
    commonName,
    family,
    wateringIntervalDays,
    fertilizeIntervalDays,
    lightLevel,
    toxicToPets,
    catalogVersion,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeciesRow &&
          other.id == this.id &&
          other.scientificName == this.scientificName &&
          other.commonName == this.commonName &&
          other.family == this.family &&
          other.wateringIntervalDays == this.wateringIntervalDays &&
          other.fertilizeIntervalDays == this.fertilizeIntervalDays &&
          other.lightLevel == this.lightLevel &&
          other.toxicToPets == this.toxicToPets &&
          other.catalogVersion == this.catalogVersion &&
          other.updatedAt == this.updatedAt);
}

class SpeciesCompanion extends UpdateCompanion<SpeciesRow> {
  final Value<String> id;
  final Value<String> scientificName;
  final Value<String> commonName;
  final Value<String?> family;
  final Value<int> wateringIntervalDays;
  final Value<int?> fertilizeIntervalDays;
  final Value<LightLevel?> lightLevel;
  final Value<bool?> toxicToPets;
  final Value<int> catalogVersion;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SpeciesCompanion({
    this.id = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.commonName = const Value.absent(),
    this.family = const Value.absent(),
    this.wateringIntervalDays = const Value.absent(),
    this.fertilizeIntervalDays = const Value.absent(),
    this.lightLevel = const Value.absent(),
    this.toxicToPets = const Value.absent(),
    this.catalogVersion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpeciesCompanion.insert({
    required String id,
    required String scientificName,
    required String commonName,
    this.family = const Value.absent(),
    required int wateringIntervalDays,
    this.fertilizeIntervalDays = const Value.absent(),
    this.lightLevel = const Value.absent(),
    this.toxicToPets = const Value.absent(),
    this.catalogVersion = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       scientificName = Value(scientificName),
       commonName = Value(commonName),
       wateringIntervalDays = Value(wateringIntervalDays),
       updatedAt = Value(updatedAt);
  static Insertable<SpeciesRow> custom({
    Expression<String>? id,
    Expression<String>? scientificName,
    Expression<String>? commonName,
    Expression<String>? family,
    Expression<int>? wateringIntervalDays,
    Expression<int>? fertilizeIntervalDays,
    Expression<String>? lightLevel,
    Expression<bool>? toxicToPets,
    Expression<int>? catalogVersion,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scientificName != null) 'scientific_name': scientificName,
      if (commonName != null) 'common_name': commonName,
      if (family != null) 'family': family,
      if (wateringIntervalDays != null)
        'watering_interval_days': wateringIntervalDays,
      if (fertilizeIntervalDays != null)
        'fertilize_interval_days': fertilizeIntervalDays,
      if (lightLevel != null) 'light_level': lightLevel,
      if (toxicToPets != null) 'toxic_to_pets': toxicToPets,
      if (catalogVersion != null) 'catalog_version': catalogVersion,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpeciesCompanion copyWith({
    Value<String>? id,
    Value<String>? scientificName,
    Value<String>? commonName,
    Value<String?>? family,
    Value<int>? wateringIntervalDays,
    Value<int?>? fertilizeIntervalDays,
    Value<LightLevel?>? lightLevel,
    Value<bool?>? toxicToPets,
    Value<int>? catalogVersion,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SpeciesCompanion(
      id: id ?? this.id,
      scientificName: scientificName ?? this.scientificName,
      commonName: commonName ?? this.commonName,
      family: family ?? this.family,
      wateringIntervalDays: wateringIntervalDays ?? this.wateringIntervalDays,
      fertilizeIntervalDays:
          fertilizeIntervalDays ?? this.fertilizeIntervalDays,
      lightLevel: lightLevel ?? this.lightLevel,
      toxicToPets: toxicToPets ?? this.toxicToPets,
      catalogVersion: catalogVersion ?? this.catalogVersion,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scientificName.present) {
      map['scientific_name'] = Variable<String>(scientificName.value);
    }
    if (commonName.present) {
      map['common_name'] = Variable<String>(commonName.value);
    }
    if (family.present) {
      map['family'] = Variable<String>(family.value);
    }
    if (wateringIntervalDays.present) {
      map['watering_interval_days'] = Variable<int>(wateringIntervalDays.value);
    }
    if (fertilizeIntervalDays.present) {
      map['fertilize_interval_days'] = Variable<int>(
        fertilizeIntervalDays.value,
      );
    }
    if (lightLevel.present) {
      map['light_level'] = Variable<String>(
        $SpeciesTable.$converterlightLeveln.toSql(lightLevel.value),
      );
    }
    if (toxicToPets.present) {
      map['toxic_to_pets'] = Variable<bool>(toxicToPets.value);
    }
    if (catalogVersion.present) {
      map['catalog_version'] = Variable<int>(catalogVersion.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesCompanion(')
          ..write('id: $id, ')
          ..write('scientificName: $scientificName, ')
          ..write('commonName: $commonName, ')
          ..write('family: $family, ')
          ..write('wateringIntervalDays: $wateringIntervalDays, ')
          ..write('fertilizeIntervalDays: $fertilizeIntervalDays, ')
          ..write('lightLevel: $lightLevel, ')
          ..write('toxicToPets: $toxicToPets, ')
          ..write('catalogVersion: $catalogVersion, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoomsTable extends Rooms with TableInfo<$RoomsTable, Room> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WindowOrientation?, String>
  orientation = GeneratedColumn<String>(
    'orientation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<WindowOrientation?>($RoomsTable.$converterorientationn);
  static const VerificationMeta _outdoorMeta = const VerificationMeta(
    'outdoor',
  );
  @override
  late final GeneratedColumn<bool> outdoor = GeneratedColumn<bool>(
    'outdoor',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("outdoor" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> sync =
      GeneratedColumn<String>(
        'sync',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('localOnly'),
      ).withConverter<SyncState>($RoomsTable.$convertersync);
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    orientation,
    outdoor,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    sync,
    serverRev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Room> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('outdoor')) {
      context.handle(
        _outdoorMeta,
        outdoor.isAcceptableOrUnknown(data['outdoor']!, _outdoorMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Room map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Room(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      orientation: $RoomsTable.$converterorientationn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}orientation'],
        ),
      ),
      outdoor: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}outdoor'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      sync: $RoomsTable.$convertersync.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync'],
        )!,
      ),
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      ),
    );
  }

  @override
  $RoomsTable createAlias(String alias) {
    return $RoomsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WindowOrientation, String, String>
  $converterorientation = const EnumNameConverter<WindowOrientation>(
    WindowOrientation.values,
  );
  static JsonTypeConverter2<WindowOrientation?, String?, String?>
  $converterorientationn = JsonTypeConverter2.asNullable($converterorientation);
  static JsonTypeConverter2<SyncState, String, String> $convertersync =
      const EnumNameConverter<SyncState>(SyncState.values);
}

class Room extends DataClass implements Insertable<Room> {
  final String id;
  final String name;
  final WindowOrientation? orientation;
  final bool outdoor;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncState sync;

  /// The server revision this row was last synced at (the `rev` watermark). Null until
  /// the row has been accepted by the backend; sourced as `base_rev` on the next push.
  final int? serverRev;
  const Room({
    required this.id,
    required this.name,
    this.orientation,
    required this.outdoor,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.sync,
    this.serverRev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || orientation != null) {
      map['orientation'] = Variable<String>(
        $RoomsTable.$converterorientationn.toSql(orientation),
      );
    }
    map['outdoor'] = Variable<bool>(outdoor);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['sync'] = Variable<String>($RoomsTable.$convertersync.toSql(sync));
    }
    if (!nullToAbsent || serverRev != null) {
      map['server_rev'] = Variable<int>(serverRev);
    }
    return map;
  }

  RoomsCompanion toCompanion(bool nullToAbsent) {
    return RoomsCompanion(
      id: Value(id),
      name: Value(name),
      orientation: orientation == null && nullToAbsent
          ? const Value.absent()
          : Value(orientation),
      outdoor: Value(outdoor),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      sync: Value(sync),
      serverRev: serverRev == null && nullToAbsent
          ? const Value.absent()
          : Value(serverRev),
    );
  }

  factory Room.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Room(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      orientation: $RoomsTable.$converterorientationn.fromJson(
        serializer.fromJson<String?>(json['orientation']),
      ),
      outdoor: serializer.fromJson<bool>(json['outdoor']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      sync: $RoomsTable.$convertersync.fromJson(
        serializer.fromJson<String>(json['sync']),
      ),
      serverRev: serializer.fromJson<int?>(json['serverRev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'orientation': serializer.toJson<String?>(
        $RoomsTable.$converterorientationn.toJson(orientation),
      ),
      'outdoor': serializer.toJson<bool>(outdoor),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'sync': serializer.toJson<String>(
        $RoomsTable.$convertersync.toJson(sync),
      ),
      'serverRev': serializer.toJson<int?>(serverRev),
    };
  }

  Room copyWith({
    String? id,
    String? name,
    Value<WindowOrientation?> orientation = const Value.absent(),
    bool? outdoor,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    SyncState? sync,
    Value<int?> serverRev = const Value.absent(),
  }) => Room(
    id: id ?? this.id,
    name: name ?? this.name,
    orientation: orientation.present ? orientation.value : this.orientation,
    outdoor: outdoor ?? this.outdoor,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    sync: sync ?? this.sync,
    serverRev: serverRev.present ? serverRev.value : this.serverRev,
  );
  Room copyWithCompanion(RoomsCompanion data) {
    return Room(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      orientation: data.orientation.present
          ? data.orientation.value
          : this.orientation,
      outdoor: data.outdoor.present ? data.outdoor.value : this.outdoor,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      sync: data.sync.present ? data.sync.value : this.sync,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Room(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('orientation: $orientation, ')
          ..write('outdoor: $outdoor, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('sync: $sync, ')
          ..write('serverRev: $serverRev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    orientation,
    outdoor,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    sync,
    serverRev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Room &&
          other.id == this.id &&
          other.name == this.name &&
          other.orientation == this.orientation &&
          other.outdoor == this.outdoor &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.sync == this.sync &&
          other.serverRev == this.serverRev);
}

class RoomsCompanion extends UpdateCompanion<Room> {
  final Value<String> id;
  final Value<String> name;
  final Value<WindowOrientation?> orientation;
  final Value<bool> outdoor;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<SyncState> sync;
  final Value<int?> serverRev;
  final Value<int> rowid;
  const RoomsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.orientation = const Value.absent(),
    this.outdoor = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.sync = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomsCompanion.insert({
    required String id,
    required String name,
    this.orientation = const Value.absent(),
    this.outdoor = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.sync = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Room> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? orientation,
    Expression<bool>? outdoor,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? sync,
    Expression<int>? serverRev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (orientation != null) 'orientation': orientation,
      if (outdoor != null) 'outdoor': outdoor,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (sync != null) 'sync': sync,
      if (serverRev != null) 'server_rev': serverRev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<WindowOrientation?>? orientation,
    Value<bool>? outdoor,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<SyncState>? sync,
    Value<int?>? serverRev,
    Value<int>? rowid,
  }) {
    return RoomsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      orientation: orientation ?? this.orientation,
      outdoor: outdoor ?? this.outdoor,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      sync: sync ?? this.sync,
      serverRev: serverRev ?? this.serverRev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (orientation.present) {
      map['orientation'] = Variable<String>(
        $RoomsTable.$converterorientationn.toSql(orientation.value),
      );
    }
    if (outdoor.present) {
      map['outdoor'] = Variable<bool>(outdoor.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (sync.present) {
      map['sync'] = Variable<String>(
        $RoomsTable.$convertersync.toSql(sync.value),
      );
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('orientation: $orientation, ')
          ..write('outdoor: $outdoor, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('sync: $sync, ')
          ..write('serverRev: $serverRev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPlantsTable extends UserPlants
    with TableInfo<$UserPlantsTable, UserPlant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPlantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speciesIdMeta = const VerificationMeta(
    'speciesId',
  );
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
    'species_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _acquiredAtMeta = const VerificationMeta(
    'acquiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> acquiredAt = GeneratedColumn<DateTime>(
    'acquired_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PlantStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('active'),
      ).withConverter<PlantStatus>($UserPlantsTable.$converterstatus);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> sync =
      GeneratedColumn<String>(
        'sync',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('localOnly'),
      ).withConverter<SyncState>($UserPlantsTable.$convertersync);
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    speciesId,
    roomId,
    nickname,
    photoPath,
    acquiredAt,
    status,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    sync,
    serverRev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_plants';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPlant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('species_id')) {
      context.handle(
        _speciesIdMeta,
        speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta),
      );
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('acquired_at')) {
      context.handle(
        _acquiredAtMeta,
        acquiredAt.isAcceptableOrUnknown(data['acquired_at']!, _acquiredAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPlant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPlant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      speciesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species_id'],
      ),
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_id'],
      ),
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      acquiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}acquired_at'],
      ),
      status: $UserPlantsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      sync: $UserPlantsTable.$convertersync.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync'],
        )!,
      ),
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      ),
    );
  }

  @override
  $UserPlantsTable createAlias(String alias) {
    return $UserPlantsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PlantStatus, String, String> $converterstatus =
      const EnumNameConverter<PlantStatus>(PlantStatus.values);
  static JsonTypeConverter2<SyncState, String, String> $convertersync =
      const EnumNameConverter<SyncState>(SyncState.values);
}

class UserPlant extends DataClass implements Insertable<UserPlant> {
  final String id;
  final String? speciesId;
  final String? roomId;
  final String nickname;
  final String? photoPath;
  final DateTime? acquiredAt;
  final PlantStatus status;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncState sync;

  /// The server revision this row was last synced at (the `rev` watermark). Null until
  /// the row has been accepted by the backend; sourced as `base_rev` on the next push.
  final int? serverRev;
  const UserPlant({
    required this.id,
    this.speciesId,
    this.roomId,
    required this.nickname,
    this.photoPath,
    this.acquiredAt,
    required this.status,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.sync,
    this.serverRev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || speciesId != null) {
      map['species_id'] = Variable<String>(speciesId);
    }
    if (!nullToAbsent || roomId != null) {
      map['room_id'] = Variable<String>(roomId);
    }
    map['nickname'] = Variable<String>(nickname);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || acquiredAt != null) {
      map['acquired_at'] = Variable<DateTime>(acquiredAt);
    }
    {
      map['status'] = Variable<String>(
        $UserPlantsTable.$converterstatus.toSql(status),
      );
    }
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['sync'] = Variable<String>(
        $UserPlantsTable.$convertersync.toSql(sync),
      );
    }
    if (!nullToAbsent || serverRev != null) {
      map['server_rev'] = Variable<int>(serverRev);
    }
    return map;
  }

  UserPlantsCompanion toCompanion(bool nullToAbsent) {
    return UserPlantsCompanion(
      id: Value(id),
      speciesId: speciesId == null && nullToAbsent
          ? const Value.absent()
          : Value(speciesId),
      roomId: roomId == null && nullToAbsent
          ? const Value.absent()
          : Value(roomId),
      nickname: Value(nickname),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      acquiredAt: acquiredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acquiredAt),
      status: Value(status),
      version: Value(version),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      sync: Value(sync),
      serverRev: serverRev == null && nullToAbsent
          ? const Value.absent()
          : Value(serverRev),
    );
  }

  factory UserPlant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPlant(
      id: serializer.fromJson<String>(json['id']),
      speciesId: serializer.fromJson<String?>(json['speciesId']),
      roomId: serializer.fromJson<String?>(json['roomId']),
      nickname: serializer.fromJson<String>(json['nickname']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      acquiredAt: serializer.fromJson<DateTime?>(json['acquiredAt']),
      status: $UserPlantsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      sync: $UserPlantsTable.$convertersync.fromJson(
        serializer.fromJson<String>(json['sync']),
      ),
      serverRev: serializer.fromJson<int?>(json['serverRev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'speciesId': serializer.toJson<String?>(speciesId),
      'roomId': serializer.toJson<String?>(roomId),
      'nickname': serializer.toJson<String>(nickname),
      'photoPath': serializer.toJson<String?>(photoPath),
      'acquiredAt': serializer.toJson<DateTime?>(acquiredAt),
      'status': serializer.toJson<String>(
        $UserPlantsTable.$converterstatus.toJson(status),
      ),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'sync': serializer.toJson<String>(
        $UserPlantsTable.$convertersync.toJson(sync),
      ),
      'serverRev': serializer.toJson<int?>(serverRev),
    };
  }

  UserPlant copyWith({
    String? id,
    Value<String?> speciesId = const Value.absent(),
    Value<String?> roomId = const Value.absent(),
    String? nickname,
    Value<String?> photoPath = const Value.absent(),
    Value<DateTime?> acquiredAt = const Value.absent(),
    PlantStatus? status,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    SyncState? sync,
    Value<int?> serverRev = const Value.absent(),
  }) => UserPlant(
    id: id ?? this.id,
    speciesId: speciesId.present ? speciesId.value : this.speciesId,
    roomId: roomId.present ? roomId.value : this.roomId,
    nickname: nickname ?? this.nickname,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    acquiredAt: acquiredAt.present ? acquiredAt.value : this.acquiredAt,
    status: status ?? this.status,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    sync: sync ?? this.sync,
    serverRev: serverRev.present ? serverRev.value : this.serverRev,
  );
  UserPlant copyWithCompanion(UserPlantsCompanion data) {
    return UserPlant(
      id: data.id.present ? data.id.value : this.id,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      acquiredAt: data.acquiredAt.present
          ? data.acquiredAt.value
          : this.acquiredAt,
      status: data.status.present ? data.status.value : this.status,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      sync: data.sync.present ? data.sync.value : this.sync,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPlant(')
          ..write('id: $id, ')
          ..write('speciesId: $speciesId, ')
          ..write('roomId: $roomId, ')
          ..write('nickname: $nickname, ')
          ..write('photoPath: $photoPath, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('sync: $sync, ')
          ..write('serverRev: $serverRev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    speciesId,
    roomId,
    nickname,
    photoPath,
    acquiredAt,
    status,
    version,
    createdAt,
    updatedAt,
    deletedAt,
    sync,
    serverRev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPlant &&
          other.id == this.id &&
          other.speciesId == this.speciesId &&
          other.roomId == this.roomId &&
          other.nickname == this.nickname &&
          other.photoPath == this.photoPath &&
          other.acquiredAt == this.acquiredAt &&
          other.status == this.status &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.sync == this.sync &&
          other.serverRev == this.serverRev);
}

class UserPlantsCompanion extends UpdateCompanion<UserPlant> {
  final Value<String> id;
  final Value<String?> speciesId;
  final Value<String?> roomId;
  final Value<String> nickname;
  final Value<String?> photoPath;
  final Value<DateTime?> acquiredAt;
  final Value<PlantStatus> status;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<SyncState> sync;
  final Value<int?> serverRev;
  final Value<int> rowid;
  const UserPlantsCompanion({
    this.id = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.roomId = const Value.absent(),
    this.nickname = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.acquiredAt = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.sync = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPlantsCompanion.insert({
    required String id,
    this.speciesId = const Value.absent(),
    this.roomId = const Value.absent(),
    required String nickname,
    this.photoPath = const Value.absent(),
    this.acquiredAt = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.sync = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nickname = Value(nickname),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserPlant> custom({
    Expression<String>? id,
    Expression<String>? speciesId,
    Expression<String>? roomId,
    Expression<String>? nickname,
    Expression<String>? photoPath,
    Expression<DateTime>? acquiredAt,
    Expression<String>? status,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? sync,
    Expression<int>? serverRev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (speciesId != null) 'species_id': speciesId,
      if (roomId != null) 'room_id': roomId,
      if (nickname != null) 'nickname': nickname,
      if (photoPath != null) 'photo_path': photoPath,
      if (acquiredAt != null) 'acquired_at': acquiredAt,
      if (status != null) 'status': status,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (sync != null) 'sync': sync,
      if (serverRev != null) 'server_rev': serverRev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPlantsCompanion copyWith({
    Value<String>? id,
    Value<String?>? speciesId,
    Value<String?>? roomId,
    Value<String>? nickname,
    Value<String?>? photoPath,
    Value<DateTime?>? acquiredAt,
    Value<PlantStatus>? status,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<SyncState>? sync,
    Value<int?>? serverRev,
    Value<int>? rowid,
  }) {
    return UserPlantsCompanion(
      id: id ?? this.id,
      speciesId: speciesId ?? this.speciesId,
      roomId: roomId ?? this.roomId,
      nickname: nickname ?? this.nickname,
      photoPath: photoPath ?? this.photoPath,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      status: status ?? this.status,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      sync: sync ?? this.sync,
      serverRev: serverRev ?? this.serverRev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (acquiredAt.present) {
      map['acquired_at'] = Variable<DateTime>(acquiredAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $UserPlantsTable.$converterstatus.toSql(status.value),
      );
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (sync.present) {
      map['sync'] = Variable<String>(
        $UserPlantsTable.$convertersync.toSql(sync.value),
      );
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPlantsCompanion(')
          ..write('id: $id, ')
          ..write('speciesId: $speciesId, ')
          ..write('roomId: $roomId, ')
          ..write('nickname: $nickname, ')
          ..write('photoPath: $photoPath, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('sync: $sync, ')
          ..write('serverRev: $serverRev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CareSchedulesTable extends CareSchedules
    with TableInfo<$CareSchedulesTable, CareSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userPlantIdMeta = const VerificationMeta(
    'userPlantId',
  );
  @override
  late final GeneratedColumn<String> userPlantId = GeneratedColumn<String>(
    'user_plant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CareType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CareType>($CareSchedulesTable.$convertertype);
  static const VerificationMeta _baseIntervalDaysMeta = const VerificationMeta(
    'baseIntervalDays',
  );
  @override
  late final GeneratedColumn<int> baseIntervalDays = GeneratedColumn<int>(
    'base_interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AnchorMode, String> anchor =
      GeneratedColumn<String>(
        'anchor',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('fromLastDone'),
      ).withConverter<AnchorMode>($CareSchedulesTable.$converteranchor);
  static const VerificationMeta _timeOfDayMinutesMeta = const VerificationMeta(
    'timeOfDayMinutes',
  );
  @override
  late final GeneratedColumn<int> timeOfDayMinutes = GeneratedColumn<int>(
    'time_of_day_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(540),
  );
  static const VerificationMeta _tzIdMeta = const VerificationMeta('tzId');
  @override
  late final GeneratedColumn<String> tzId = GeneratedColumn<String>(
    'tz_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seasonalMulMeta = const VerificationMeta(
    'seasonalMul',
  );
  @override
  late final GeneratedColumn<String> seasonalMul = GeneratedColumn<String>(
    'seasonal_mul',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherSensitiveMeta = const VerificationMeta(
    'weatherSensitive',
  );
  @override
  late final GeneratedColumn<bool> weatherSensitive = GeneratedColumn<bool>(
    'weather_sensitive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("weather_sensitive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _nextDueAtMeta = const VerificationMeta(
    'nextDueAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextDueAt = GeneratedColumn<DateTime>(
    'next_due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _snoozedUntilMeta = const VerificationMeta(
    'snoozedUntil',
  );
  @override
  late final GeneratedColumn<DateTime> snoozedUntil = GeneratedColumn<DateTime>(
    'snoozed_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> sync =
      GeneratedColumn<String>(
        'sync',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('localOnly'),
      ).withConverter<SyncState>($CareSchedulesTable.$convertersync);
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userPlantId,
    type,
    baseIntervalDays,
    anchor,
    timeOfDayMinutes,
    tzId,
    seasonalMul,
    weatherSensitive,
    active,
    nextDueAt,
    snoozedUntil,
    createdAt,
    updatedAt,
    sync,
    serverRev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<CareSchedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_plant_id')) {
      context.handle(
        _userPlantIdMeta,
        userPlantId.isAcceptableOrUnknown(
          data['user_plant_id']!,
          _userPlantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userPlantIdMeta);
    }
    if (data.containsKey('base_interval_days')) {
      context.handle(
        _baseIntervalDaysMeta,
        baseIntervalDays.isAcceptableOrUnknown(
          data['base_interval_days']!,
          _baseIntervalDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baseIntervalDaysMeta);
    }
    if (data.containsKey('time_of_day_minutes')) {
      context.handle(
        _timeOfDayMinutesMeta,
        timeOfDayMinutes.isAcceptableOrUnknown(
          data['time_of_day_minutes']!,
          _timeOfDayMinutesMeta,
        ),
      );
    }
    if (data.containsKey('tz_id')) {
      context.handle(
        _tzIdMeta,
        tzId.isAcceptableOrUnknown(data['tz_id']!, _tzIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tzIdMeta);
    }
    if (data.containsKey('seasonal_mul')) {
      context.handle(
        _seasonalMulMeta,
        seasonalMul.isAcceptableOrUnknown(
          data['seasonal_mul']!,
          _seasonalMulMeta,
        ),
      );
    }
    if (data.containsKey('weather_sensitive')) {
      context.handle(
        _weatherSensitiveMeta,
        weatherSensitive.isAcceptableOrUnknown(
          data['weather_sensitive']!,
          _weatherSensitiveMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('next_due_at')) {
      context.handle(
        _nextDueAtMeta,
        nextDueAt.isAcceptableOrUnknown(data['next_due_at']!, _nextDueAtMeta),
      );
    }
    if (data.containsKey('snoozed_until')) {
      context.handle(
        _snoozedUntilMeta,
        snoozedUntil.isAcceptableOrUnknown(
          data['snoozed_until']!,
          _snoozedUntilMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareSchedule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userPlantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_plant_id'],
      )!,
      type: $CareSchedulesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      baseIntervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_interval_days'],
      )!,
      anchor: $CareSchedulesTable.$converteranchor.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}anchor'],
        )!,
      ),
      timeOfDayMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_of_day_minutes'],
      )!,
      tzId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tz_id'],
      )!,
      seasonalMul: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seasonal_mul'],
      ),
      weatherSensitive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}weather_sensitive'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      nextDueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_due_at'],
      ),
      snoozedUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}snoozed_until'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      sync: $CareSchedulesTable.$convertersync.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync'],
        )!,
      ),
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      ),
    );
  }

  @override
  $CareSchedulesTable createAlias(String alias) {
    return $CareSchedulesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CareType, String, String> $convertertype =
      const EnumNameConverter<CareType>(CareType.values);
  static JsonTypeConverter2<AnchorMode, String, String> $converteranchor =
      const EnumNameConverter<AnchorMode>(AnchorMode.values);
  static JsonTypeConverter2<SyncState, String, String> $convertersync =
      const EnumNameConverter<SyncState>(SyncState.values);
}

class CareSchedule extends DataClass implements Insertable<CareSchedule> {
  final String id;
  final String userPlantId;
  final CareType type;
  final int baseIntervalDays;
  final AnchorMode anchor;
  final int timeOfDayMinutes;
  final String tzId;
  final String? seasonalMul;
  final bool weatherSensitive;
  final bool active;
  final DateTime? nextDueAt;

  /// A user-requested "remind me later" marker. When set and *later* than the cadence's
  /// natural due date, the reminder engine fires at this instant instead. Logging the
  /// care afterward pushes the natural due date past it, which supersedes the snooze —
  /// so it needs no explicit clearing.
  final DateTime? snoozedUntil;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncState sync;

  /// The server revision this row was last synced at (the `rev` watermark). Null until
  /// the row has been accepted by the backend; sourced as `base_rev` on the next push.
  final int? serverRev;
  const CareSchedule({
    required this.id,
    required this.userPlantId,
    required this.type,
    required this.baseIntervalDays,
    required this.anchor,
    required this.timeOfDayMinutes,
    required this.tzId,
    this.seasonalMul,
    required this.weatherSensitive,
    required this.active,
    this.nextDueAt,
    this.snoozedUntil,
    required this.createdAt,
    required this.updatedAt,
    required this.sync,
    this.serverRev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_plant_id'] = Variable<String>(userPlantId);
    {
      map['type'] = Variable<String>(
        $CareSchedulesTable.$convertertype.toSql(type),
      );
    }
    map['base_interval_days'] = Variable<int>(baseIntervalDays);
    {
      map['anchor'] = Variable<String>(
        $CareSchedulesTable.$converteranchor.toSql(anchor),
      );
    }
    map['time_of_day_minutes'] = Variable<int>(timeOfDayMinutes);
    map['tz_id'] = Variable<String>(tzId);
    if (!nullToAbsent || seasonalMul != null) {
      map['seasonal_mul'] = Variable<String>(seasonalMul);
    }
    map['weather_sensitive'] = Variable<bool>(weatherSensitive);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || nextDueAt != null) {
      map['next_due_at'] = Variable<DateTime>(nextDueAt);
    }
    if (!nullToAbsent || snoozedUntil != null) {
      map['snoozed_until'] = Variable<DateTime>(snoozedUntil);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync'] = Variable<String>(
        $CareSchedulesTable.$convertersync.toSql(sync),
      );
    }
    if (!nullToAbsent || serverRev != null) {
      map['server_rev'] = Variable<int>(serverRev);
    }
    return map;
  }

  CareSchedulesCompanion toCompanion(bool nullToAbsent) {
    return CareSchedulesCompanion(
      id: Value(id),
      userPlantId: Value(userPlantId),
      type: Value(type),
      baseIntervalDays: Value(baseIntervalDays),
      anchor: Value(anchor),
      timeOfDayMinutes: Value(timeOfDayMinutes),
      tzId: Value(tzId),
      seasonalMul: seasonalMul == null && nullToAbsent
          ? const Value.absent()
          : Value(seasonalMul),
      weatherSensitive: Value(weatherSensitive),
      active: Value(active),
      nextDueAt: nextDueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDueAt),
      snoozedUntil: snoozedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozedUntil),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sync: Value(sync),
      serverRev: serverRev == null && nullToAbsent
          ? const Value.absent()
          : Value(serverRev),
    );
  }

  factory CareSchedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareSchedule(
      id: serializer.fromJson<String>(json['id']),
      userPlantId: serializer.fromJson<String>(json['userPlantId']),
      type: $CareSchedulesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      baseIntervalDays: serializer.fromJson<int>(json['baseIntervalDays']),
      anchor: $CareSchedulesTable.$converteranchor.fromJson(
        serializer.fromJson<String>(json['anchor']),
      ),
      timeOfDayMinutes: serializer.fromJson<int>(json['timeOfDayMinutes']),
      tzId: serializer.fromJson<String>(json['tzId']),
      seasonalMul: serializer.fromJson<String?>(json['seasonalMul']),
      weatherSensitive: serializer.fromJson<bool>(json['weatherSensitive']),
      active: serializer.fromJson<bool>(json['active']),
      nextDueAt: serializer.fromJson<DateTime?>(json['nextDueAt']),
      snoozedUntil: serializer.fromJson<DateTime?>(json['snoozedUntil']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sync: $CareSchedulesTable.$convertersync.fromJson(
        serializer.fromJson<String>(json['sync']),
      ),
      serverRev: serializer.fromJson<int?>(json['serverRev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userPlantId': serializer.toJson<String>(userPlantId),
      'type': serializer.toJson<String>(
        $CareSchedulesTable.$convertertype.toJson(type),
      ),
      'baseIntervalDays': serializer.toJson<int>(baseIntervalDays),
      'anchor': serializer.toJson<String>(
        $CareSchedulesTable.$converteranchor.toJson(anchor),
      ),
      'timeOfDayMinutes': serializer.toJson<int>(timeOfDayMinutes),
      'tzId': serializer.toJson<String>(tzId),
      'seasonalMul': serializer.toJson<String?>(seasonalMul),
      'weatherSensitive': serializer.toJson<bool>(weatherSensitive),
      'active': serializer.toJson<bool>(active),
      'nextDueAt': serializer.toJson<DateTime?>(nextDueAt),
      'snoozedUntil': serializer.toJson<DateTime?>(snoozedUntil),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sync': serializer.toJson<String>(
        $CareSchedulesTable.$convertersync.toJson(sync),
      ),
      'serverRev': serializer.toJson<int?>(serverRev),
    };
  }

  CareSchedule copyWith({
    String? id,
    String? userPlantId,
    CareType? type,
    int? baseIntervalDays,
    AnchorMode? anchor,
    int? timeOfDayMinutes,
    String? tzId,
    Value<String?> seasonalMul = const Value.absent(),
    bool? weatherSensitive,
    bool? active,
    Value<DateTime?> nextDueAt = const Value.absent(),
    Value<DateTime?> snoozedUntil = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncState? sync,
    Value<int?> serverRev = const Value.absent(),
  }) => CareSchedule(
    id: id ?? this.id,
    userPlantId: userPlantId ?? this.userPlantId,
    type: type ?? this.type,
    baseIntervalDays: baseIntervalDays ?? this.baseIntervalDays,
    anchor: anchor ?? this.anchor,
    timeOfDayMinutes: timeOfDayMinutes ?? this.timeOfDayMinutes,
    tzId: tzId ?? this.tzId,
    seasonalMul: seasonalMul.present ? seasonalMul.value : this.seasonalMul,
    weatherSensitive: weatherSensitive ?? this.weatherSensitive,
    active: active ?? this.active,
    nextDueAt: nextDueAt.present ? nextDueAt.value : this.nextDueAt,
    snoozedUntil: snoozedUntil.present ? snoozedUntil.value : this.snoozedUntil,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sync: sync ?? this.sync,
    serverRev: serverRev.present ? serverRev.value : this.serverRev,
  );
  CareSchedule copyWithCompanion(CareSchedulesCompanion data) {
    return CareSchedule(
      id: data.id.present ? data.id.value : this.id,
      userPlantId: data.userPlantId.present
          ? data.userPlantId.value
          : this.userPlantId,
      type: data.type.present ? data.type.value : this.type,
      baseIntervalDays: data.baseIntervalDays.present
          ? data.baseIntervalDays.value
          : this.baseIntervalDays,
      anchor: data.anchor.present ? data.anchor.value : this.anchor,
      timeOfDayMinutes: data.timeOfDayMinutes.present
          ? data.timeOfDayMinutes.value
          : this.timeOfDayMinutes,
      tzId: data.tzId.present ? data.tzId.value : this.tzId,
      seasonalMul: data.seasonalMul.present
          ? data.seasonalMul.value
          : this.seasonalMul,
      weatherSensitive: data.weatherSensitive.present
          ? data.weatherSensitive.value
          : this.weatherSensitive,
      active: data.active.present ? data.active.value : this.active,
      nextDueAt: data.nextDueAt.present ? data.nextDueAt.value : this.nextDueAt,
      snoozedUntil: data.snoozedUntil.present
          ? data.snoozedUntil.value
          : this.snoozedUntil,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sync: data.sync.present ? data.sync.value : this.sync,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CareSchedule(')
          ..write('id: $id, ')
          ..write('userPlantId: $userPlantId, ')
          ..write('type: $type, ')
          ..write('baseIntervalDays: $baseIntervalDays, ')
          ..write('anchor: $anchor, ')
          ..write('timeOfDayMinutes: $timeOfDayMinutes, ')
          ..write('tzId: $tzId, ')
          ..write('seasonalMul: $seasonalMul, ')
          ..write('weatherSensitive: $weatherSensitive, ')
          ..write('active: $active, ')
          ..write('nextDueAt: $nextDueAt, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sync: $sync, ')
          ..write('serverRev: $serverRev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userPlantId,
    type,
    baseIntervalDays,
    anchor,
    timeOfDayMinutes,
    tzId,
    seasonalMul,
    weatherSensitive,
    active,
    nextDueAt,
    snoozedUntil,
    createdAt,
    updatedAt,
    sync,
    serverRev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareSchedule &&
          other.id == this.id &&
          other.userPlantId == this.userPlantId &&
          other.type == this.type &&
          other.baseIntervalDays == this.baseIntervalDays &&
          other.anchor == this.anchor &&
          other.timeOfDayMinutes == this.timeOfDayMinutes &&
          other.tzId == this.tzId &&
          other.seasonalMul == this.seasonalMul &&
          other.weatherSensitive == this.weatherSensitive &&
          other.active == this.active &&
          other.nextDueAt == this.nextDueAt &&
          other.snoozedUntil == this.snoozedUntil &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sync == this.sync &&
          other.serverRev == this.serverRev);
}

class CareSchedulesCompanion extends UpdateCompanion<CareSchedule> {
  final Value<String> id;
  final Value<String> userPlantId;
  final Value<CareType> type;
  final Value<int> baseIntervalDays;
  final Value<AnchorMode> anchor;
  final Value<int> timeOfDayMinutes;
  final Value<String> tzId;
  final Value<String?> seasonalMul;
  final Value<bool> weatherSensitive;
  final Value<bool> active;
  final Value<DateTime?> nextDueAt;
  final Value<DateTime?> snoozedUntil;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncState> sync;
  final Value<int?> serverRev;
  final Value<int> rowid;
  const CareSchedulesCompanion({
    this.id = const Value.absent(),
    this.userPlantId = const Value.absent(),
    this.type = const Value.absent(),
    this.baseIntervalDays = const Value.absent(),
    this.anchor = const Value.absent(),
    this.timeOfDayMinutes = const Value.absent(),
    this.tzId = const Value.absent(),
    this.seasonalMul = const Value.absent(),
    this.weatherSensitive = const Value.absent(),
    this.active = const Value.absent(),
    this.nextDueAt = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sync = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CareSchedulesCompanion.insert({
    required String id,
    required String userPlantId,
    required CareType type,
    required int baseIntervalDays,
    this.anchor = const Value.absent(),
    this.timeOfDayMinutes = const Value.absent(),
    required String tzId,
    this.seasonalMul = const Value.absent(),
    this.weatherSensitive = const Value.absent(),
    this.active = const Value.absent(),
    this.nextDueAt = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.sync = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userPlantId = Value(userPlantId),
       type = Value(type),
       baseIntervalDays = Value(baseIntervalDays),
       tzId = Value(tzId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CareSchedule> custom({
    Expression<String>? id,
    Expression<String>? userPlantId,
    Expression<String>? type,
    Expression<int>? baseIntervalDays,
    Expression<String>? anchor,
    Expression<int>? timeOfDayMinutes,
    Expression<String>? tzId,
    Expression<String>? seasonalMul,
    Expression<bool>? weatherSensitive,
    Expression<bool>? active,
    Expression<DateTime>? nextDueAt,
    Expression<DateTime>? snoozedUntil,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? sync,
    Expression<int>? serverRev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userPlantId != null) 'user_plant_id': userPlantId,
      if (type != null) 'type': type,
      if (baseIntervalDays != null) 'base_interval_days': baseIntervalDays,
      if (anchor != null) 'anchor': anchor,
      if (timeOfDayMinutes != null) 'time_of_day_minutes': timeOfDayMinutes,
      if (tzId != null) 'tz_id': tzId,
      if (seasonalMul != null) 'seasonal_mul': seasonalMul,
      if (weatherSensitive != null) 'weather_sensitive': weatherSensitive,
      if (active != null) 'active': active,
      if (nextDueAt != null) 'next_due_at': nextDueAt,
      if (snoozedUntil != null) 'snoozed_until': snoozedUntil,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sync != null) 'sync': sync,
      if (serverRev != null) 'server_rev': serverRev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CareSchedulesCompanion copyWith({
    Value<String>? id,
    Value<String>? userPlantId,
    Value<CareType>? type,
    Value<int>? baseIntervalDays,
    Value<AnchorMode>? anchor,
    Value<int>? timeOfDayMinutes,
    Value<String>? tzId,
    Value<String?>? seasonalMul,
    Value<bool>? weatherSensitive,
    Value<bool>? active,
    Value<DateTime?>? nextDueAt,
    Value<DateTime?>? snoozedUntil,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<SyncState>? sync,
    Value<int?>? serverRev,
    Value<int>? rowid,
  }) {
    return CareSchedulesCompanion(
      id: id ?? this.id,
      userPlantId: userPlantId ?? this.userPlantId,
      type: type ?? this.type,
      baseIntervalDays: baseIntervalDays ?? this.baseIntervalDays,
      anchor: anchor ?? this.anchor,
      timeOfDayMinutes: timeOfDayMinutes ?? this.timeOfDayMinutes,
      tzId: tzId ?? this.tzId,
      seasonalMul: seasonalMul ?? this.seasonalMul,
      weatherSensitive: weatherSensitive ?? this.weatherSensitive,
      active: active ?? this.active,
      nextDueAt: nextDueAt ?? this.nextDueAt,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sync: sync ?? this.sync,
      serverRev: serverRev ?? this.serverRev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userPlantId.present) {
      map['user_plant_id'] = Variable<String>(userPlantId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $CareSchedulesTable.$convertertype.toSql(type.value),
      );
    }
    if (baseIntervalDays.present) {
      map['base_interval_days'] = Variable<int>(baseIntervalDays.value);
    }
    if (anchor.present) {
      map['anchor'] = Variable<String>(
        $CareSchedulesTable.$converteranchor.toSql(anchor.value),
      );
    }
    if (timeOfDayMinutes.present) {
      map['time_of_day_minutes'] = Variable<int>(timeOfDayMinutes.value);
    }
    if (tzId.present) {
      map['tz_id'] = Variable<String>(tzId.value);
    }
    if (seasonalMul.present) {
      map['seasonal_mul'] = Variable<String>(seasonalMul.value);
    }
    if (weatherSensitive.present) {
      map['weather_sensitive'] = Variable<bool>(weatherSensitive.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (nextDueAt.present) {
      map['next_due_at'] = Variable<DateTime>(nextDueAt.value);
    }
    if (snoozedUntil.present) {
      map['snoozed_until'] = Variable<DateTime>(snoozedUntil.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (sync.present) {
      map['sync'] = Variable<String>(
        $CareSchedulesTable.$convertersync.toSql(sync.value),
      );
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('userPlantId: $userPlantId, ')
          ..write('type: $type, ')
          ..write('baseIntervalDays: $baseIntervalDays, ')
          ..write('anchor: $anchor, ')
          ..write('timeOfDayMinutes: $timeOfDayMinutes, ')
          ..write('tzId: $tzId, ')
          ..write('seasonalMul: $seasonalMul, ')
          ..write('weatherSensitive: $weatherSensitive, ')
          ..write('active: $active, ')
          ..write('nextDueAt: $nextDueAt, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sync: $sync, ')
          ..write('serverRev: $serverRev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CareLogsTable extends CareLogs with TableInfo<$CareLogsTable, CareLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CareLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userPlantIdMeta = const VerificationMeta(
    'userPlantId',
  );
  @override
  late final GeneratedColumn<String> userPlantId = GeneratedColumn<String>(
    'user_plant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CareType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CareType>($CareLogsTable.$convertertype);
  static const VerificationMeta _performedAtMeta = const VerificationMeta(
    'performedAt',
  );
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
    'performed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CareLogSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('manual'),
      ).withConverter<CareLogSource>($CareLogsTable.$convertersource);
  static const VerificationMeta _amountMlMeta = const VerificationMeta(
    'amountMl',
  );
  @override
  late final GeneratedColumn<int> amountMl = GeneratedColumn<int>(
    'amount_ml',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> sync =
      GeneratedColumn<String>(
        'sync',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('localOnly'),
      ).withConverter<SyncState>($CareLogsTable.$convertersync);
  static const VerificationMeta _serverRevMeta = const VerificationMeta(
    'serverRev',
  );
  @override
  late final GeneratedColumn<int> serverRev = GeneratedColumn<int>(
    'server_rev',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userPlantId,
    type,
    performedAt,
    source,
    amountMl,
    note,
    photoPath,
    createdAt,
    updatedAt,
    deletedAt,
    sync,
    serverRev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'care_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CareLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_plant_id')) {
      context.handle(
        _userPlantIdMeta,
        userPlantId.isAcceptableOrUnknown(
          data['user_plant_id']!,
          _userPlantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userPlantIdMeta);
    }
    if (data.containsKey('performed_at')) {
      context.handle(
        _performedAtMeta,
        performedAt.isAcceptableOrUnknown(
          data['performed_at']!,
          _performedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_performedAtMeta);
    }
    if (data.containsKey('amount_ml')) {
      context.handle(
        _amountMlMeta,
        amountMl.isAcceptableOrUnknown(data['amount_ml']!, _amountMlMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('server_rev')) {
      context.handle(
        _serverRevMeta,
        serverRev.isAcceptableOrUnknown(data['server_rev']!, _serverRevMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CareLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CareLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userPlantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_plant_id'],
      )!,
      type: $CareLogsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      performedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}performed_at'],
      )!,
      source: $CareLogsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      amountMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_ml'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      sync: $CareLogsTable.$convertersync.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync'],
        )!,
      ),
      serverRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_rev'],
      ),
    );
  }

  @override
  $CareLogsTable createAlias(String alias) {
    return $CareLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CareType, String, String> $convertertype =
      const EnumNameConverter<CareType>(CareType.values);
  static JsonTypeConverter2<CareLogSource, String, String> $convertersource =
      const EnumNameConverter<CareLogSource>(CareLogSource.values);
  static JsonTypeConverter2<SyncState, String, String> $convertersync =
      const EnumNameConverter<SyncState>(SyncState.values);
}

class CareLog extends DataClass implements Insertable<CareLog> {
  final String id;
  final String userPlantId;
  final CareType type;
  final DateTime performedAt;
  final CareLogSource source;
  final int? amountMl;
  final String? note;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final SyncState sync;

  /// The server revision this row was last synced at (the `rev` watermark). Null until
  /// the row has been accepted by the backend; sourced as `base_rev` on the next push.
  final int? serverRev;
  const CareLog({
    required this.id,
    required this.userPlantId,
    required this.type,
    required this.performedAt,
    required this.source,
    this.amountMl,
    this.note,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.sync,
    this.serverRev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_plant_id'] = Variable<String>(userPlantId);
    {
      map['type'] = Variable<String>($CareLogsTable.$convertertype.toSql(type));
    }
    map['performed_at'] = Variable<DateTime>(performedAt);
    {
      map['source'] = Variable<String>(
        $CareLogsTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || amountMl != null) {
      map['amount_ml'] = Variable<int>(amountMl);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['sync'] = Variable<String>($CareLogsTable.$convertersync.toSql(sync));
    }
    if (!nullToAbsent || serverRev != null) {
      map['server_rev'] = Variable<int>(serverRev);
    }
    return map;
  }

  CareLogsCompanion toCompanion(bool nullToAbsent) {
    return CareLogsCompanion(
      id: Value(id),
      userPlantId: Value(userPlantId),
      type: Value(type),
      performedAt: Value(performedAt),
      source: Value(source),
      amountMl: amountMl == null && nullToAbsent
          ? const Value.absent()
          : Value(amountMl),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      sync: Value(sync),
      serverRev: serverRev == null && nullToAbsent
          ? const Value.absent()
          : Value(serverRev),
    );
  }

  factory CareLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CareLog(
      id: serializer.fromJson<String>(json['id']),
      userPlantId: serializer.fromJson<String>(json['userPlantId']),
      type: $CareLogsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
      source: $CareLogsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      amountMl: serializer.fromJson<int?>(json['amountMl']),
      note: serializer.fromJson<String?>(json['note']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      sync: $CareLogsTable.$convertersync.fromJson(
        serializer.fromJson<String>(json['sync']),
      ),
      serverRev: serializer.fromJson<int?>(json['serverRev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userPlantId': serializer.toJson<String>(userPlantId),
      'type': serializer.toJson<String>(
        $CareLogsTable.$convertertype.toJson(type),
      ),
      'performedAt': serializer.toJson<DateTime>(performedAt),
      'source': serializer.toJson<String>(
        $CareLogsTable.$convertersource.toJson(source),
      ),
      'amountMl': serializer.toJson<int?>(amountMl),
      'note': serializer.toJson<String?>(note),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'sync': serializer.toJson<String>(
        $CareLogsTable.$convertersync.toJson(sync),
      ),
      'serverRev': serializer.toJson<int?>(serverRev),
    };
  }

  CareLog copyWith({
    String? id,
    String? userPlantId,
    CareType? type,
    DateTime? performedAt,
    CareLogSource? source,
    Value<int?> amountMl = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    SyncState? sync,
    Value<int?> serverRev = const Value.absent(),
  }) => CareLog(
    id: id ?? this.id,
    userPlantId: userPlantId ?? this.userPlantId,
    type: type ?? this.type,
    performedAt: performedAt ?? this.performedAt,
    source: source ?? this.source,
    amountMl: amountMl.present ? amountMl.value : this.amountMl,
    note: note.present ? note.value : this.note,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    sync: sync ?? this.sync,
    serverRev: serverRev.present ? serverRev.value : this.serverRev,
  );
  CareLog copyWithCompanion(CareLogsCompanion data) {
    return CareLog(
      id: data.id.present ? data.id.value : this.id,
      userPlantId: data.userPlantId.present
          ? data.userPlantId.value
          : this.userPlantId,
      type: data.type.present ? data.type.value : this.type,
      performedAt: data.performedAt.present
          ? data.performedAt.value
          : this.performedAt,
      source: data.source.present ? data.source.value : this.source,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      note: data.note.present ? data.note.value : this.note,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      sync: data.sync.present ? data.sync.value : this.sync,
      serverRev: data.serverRev.present ? data.serverRev.value : this.serverRev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CareLog(')
          ..write('id: $id, ')
          ..write('userPlantId: $userPlantId, ')
          ..write('type: $type, ')
          ..write('performedAt: $performedAt, ')
          ..write('source: $source, ')
          ..write('amountMl: $amountMl, ')
          ..write('note: $note, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('sync: $sync, ')
          ..write('serverRev: $serverRev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userPlantId,
    type,
    performedAt,
    source,
    amountMl,
    note,
    photoPath,
    createdAt,
    updatedAt,
    deletedAt,
    sync,
    serverRev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CareLog &&
          other.id == this.id &&
          other.userPlantId == this.userPlantId &&
          other.type == this.type &&
          other.performedAt == this.performedAt &&
          other.source == this.source &&
          other.amountMl == this.amountMl &&
          other.note == this.note &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.sync == this.sync &&
          other.serverRev == this.serverRev);
}

class CareLogsCompanion extends UpdateCompanion<CareLog> {
  final Value<String> id;
  final Value<String> userPlantId;
  final Value<CareType> type;
  final Value<DateTime> performedAt;
  final Value<CareLogSource> source;
  final Value<int?> amountMl;
  final Value<String?> note;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<SyncState> sync;
  final Value<int?> serverRev;
  final Value<int> rowid;
  const CareLogsCompanion({
    this.id = const Value.absent(),
    this.userPlantId = const Value.absent(),
    this.type = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.note = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.sync = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CareLogsCompanion.insert({
    required String id,
    required String userPlantId,
    required CareType type,
    required DateTime performedAt,
    this.source = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.note = const Value.absent(),
    this.photoPath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.sync = const Value.absent(),
    this.serverRev = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userPlantId = Value(userPlantId),
       type = Value(type),
       performedAt = Value(performedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CareLog> custom({
    Expression<String>? id,
    Expression<String>? userPlantId,
    Expression<String>? type,
    Expression<DateTime>? performedAt,
    Expression<String>? source,
    Expression<int>? amountMl,
    Expression<String>? note,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? sync,
    Expression<int>? serverRev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userPlantId != null) 'user_plant_id': userPlantId,
      if (type != null) 'type': type,
      if (performedAt != null) 'performed_at': performedAt,
      if (source != null) 'source': source,
      if (amountMl != null) 'amount_ml': amountMl,
      if (note != null) 'note': note,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (sync != null) 'sync': sync,
      if (serverRev != null) 'server_rev': serverRev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CareLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? userPlantId,
    Value<CareType>? type,
    Value<DateTime>? performedAt,
    Value<CareLogSource>? source,
    Value<int?>? amountMl,
    Value<String?>? note,
    Value<String?>? photoPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<SyncState>? sync,
    Value<int?>? serverRev,
    Value<int>? rowid,
  }) {
    return CareLogsCompanion(
      id: id ?? this.id,
      userPlantId: userPlantId ?? this.userPlantId,
      type: type ?? this.type,
      performedAt: performedAt ?? this.performedAt,
      source: source ?? this.source,
      amountMl: amountMl ?? this.amountMl,
      note: note ?? this.note,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      sync: sync ?? this.sync,
      serverRev: serverRev ?? this.serverRev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userPlantId.present) {
      map['user_plant_id'] = Variable<String>(userPlantId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $CareLogsTable.$convertertype.toSql(type.value),
      );
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $CareLogsTable.$convertersource.toSql(source.value),
      );
    }
    if (amountMl.present) {
      map['amount_ml'] = Variable<int>(amountMl.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (sync.present) {
      map['sync'] = Variable<String>(
        $CareLogsTable.$convertersync.toSql(sync.value),
      );
    }
    if (serverRev.present) {
      map['server_rev'] = Variable<int>(serverRev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CareLogsCompanion(')
          ..write('id: $id, ')
          ..write('userPlantId: $userPlantId, ')
          ..write('type: $type, ')
          ..write('performedAt: $performedAt, ')
          ..write('source: $source, ')
          ..write('amountMl: $amountMl, ')
          ..write('note: $note, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('sync: $sync, ')
          ..write('serverRev: $serverRev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationRegistryRowsTable extends NotificationRegistryRows
    with TableInfo<$NotificationRegistryRowsTable, NotificationRegistryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationRegistryRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _osNotificationIdMeta = const VerificationMeta(
    'osNotificationId',
  );
  @override
  late final GeneratedColumn<int> osNotificationId = GeneratedColumn<int>(
    'os_notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
    'schedule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firesAtMeta = const VerificationMeta(
    'firesAt',
  );
  @override
  late final GeneratedColumn<DateTime> firesAt = GeneratedColumn<DateTime>(
    'fires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    osNotificationId,
    scheduleId,
    firesAt,
    fingerprint,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_registry_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationRegistryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('os_notification_id')) {
      context.handle(
        _osNotificationIdMeta,
        osNotificationId.isAcceptableOrUnknown(
          data['os_notification_id']!,
          _osNotificationIdMeta,
        ),
      );
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('fires_at')) {
      context.handle(
        _firesAtMeta,
        firesAt.isAcceptableOrUnknown(data['fires_at']!, _firesAtMeta),
      );
    } else if (isInserting) {
      context.missing(_firesAtMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {osNotificationId};
  @override
  NotificationRegistryRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationRegistryRow(
      osNotificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}os_notification_id'],
      )!,
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_id'],
      )!,
      firesAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fires_at'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
    );
  }

  @override
  $NotificationRegistryRowsTable createAlias(String alias) {
    return $NotificationRegistryRowsTable(attachedDatabase, alias);
  }
}

class NotificationRegistryRow extends DataClass
    implements Insertable<NotificationRegistryRow> {
  final int osNotificationId;
  final String scheduleId;
  final DateTime firesAt;
  final String fingerprint;
  const NotificationRegistryRow({
    required this.osNotificationId,
    required this.scheduleId,
    required this.firesAt,
    required this.fingerprint,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['os_notification_id'] = Variable<int>(osNotificationId);
    map['schedule_id'] = Variable<String>(scheduleId);
    map['fires_at'] = Variable<DateTime>(firesAt);
    map['fingerprint'] = Variable<String>(fingerprint);
    return map;
  }

  NotificationRegistryRowsCompanion toCompanion(bool nullToAbsent) {
    return NotificationRegistryRowsCompanion(
      osNotificationId: Value(osNotificationId),
      scheduleId: Value(scheduleId),
      firesAt: Value(firesAt),
      fingerprint: Value(fingerprint),
    );
  }

  factory NotificationRegistryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationRegistryRow(
      osNotificationId: serializer.fromJson<int>(json['osNotificationId']),
      scheduleId: serializer.fromJson<String>(json['scheduleId']),
      firesAt: serializer.fromJson<DateTime>(json['firesAt']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'osNotificationId': serializer.toJson<int>(osNotificationId),
      'scheduleId': serializer.toJson<String>(scheduleId),
      'firesAt': serializer.toJson<DateTime>(firesAt),
      'fingerprint': serializer.toJson<String>(fingerprint),
    };
  }

  NotificationRegistryRow copyWith({
    int? osNotificationId,
    String? scheduleId,
    DateTime? firesAt,
    String? fingerprint,
  }) => NotificationRegistryRow(
    osNotificationId: osNotificationId ?? this.osNotificationId,
    scheduleId: scheduleId ?? this.scheduleId,
    firesAt: firesAt ?? this.firesAt,
    fingerprint: fingerprint ?? this.fingerprint,
  );
  NotificationRegistryRow copyWithCompanion(
    NotificationRegistryRowsCompanion data,
  ) {
    return NotificationRegistryRow(
      osNotificationId: data.osNotificationId.present
          ? data.osNotificationId.value
          : this.osNotificationId,
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
      firesAt: data.firesAt.present ? data.firesAt.value : this.firesAt,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationRegistryRow(')
          ..write('osNotificationId: $osNotificationId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('firesAt: $firesAt, ')
          ..write('fingerprint: $fingerprint')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(osNotificationId, scheduleId, firesAt, fingerprint);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationRegistryRow &&
          other.osNotificationId == this.osNotificationId &&
          other.scheduleId == this.scheduleId &&
          other.firesAt == this.firesAt &&
          other.fingerprint == this.fingerprint);
}

class NotificationRegistryRowsCompanion
    extends UpdateCompanion<NotificationRegistryRow> {
  final Value<int> osNotificationId;
  final Value<String> scheduleId;
  final Value<DateTime> firesAt;
  final Value<String> fingerprint;
  const NotificationRegistryRowsCompanion({
    this.osNotificationId = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.firesAt = const Value.absent(),
    this.fingerprint = const Value.absent(),
  });
  NotificationRegistryRowsCompanion.insert({
    this.osNotificationId = const Value.absent(),
    required String scheduleId,
    required DateTime firesAt,
    required String fingerprint,
  }) : scheduleId = Value(scheduleId),
       firesAt = Value(firesAt),
       fingerprint = Value(fingerprint);
  static Insertable<NotificationRegistryRow> custom({
    Expression<int>? osNotificationId,
    Expression<String>? scheduleId,
    Expression<DateTime>? firesAt,
    Expression<String>? fingerprint,
  }) {
    return RawValuesInsertable({
      if (osNotificationId != null) 'os_notification_id': osNotificationId,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (firesAt != null) 'fires_at': firesAt,
      if (fingerprint != null) 'fingerprint': fingerprint,
    });
  }

  NotificationRegistryRowsCompanion copyWith({
    Value<int>? osNotificationId,
    Value<String>? scheduleId,
    Value<DateTime>? firesAt,
    Value<String>? fingerprint,
  }) {
    return NotificationRegistryRowsCompanion(
      osNotificationId: osNotificationId ?? this.osNotificationId,
      scheduleId: scheduleId ?? this.scheduleId,
      firesAt: firesAt ?? this.firesAt,
      fingerprint: fingerprint ?? this.fingerprint,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (osNotificationId.present) {
      map['os_notification_id'] = Variable<int>(osNotificationId.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (firesAt.present) {
      map['fires_at'] = Variable<DateTime>(firesAt.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationRegistryRowsCompanion(')
          ..write('osNotificationId: $osNotificationId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('firesAt: $firesAt, ')
          ..write('fingerprint: $fingerprint')
          ..write(')'))
        .toString();
  }
}

class $OutboxEntriesTable extends OutboxEntries
    with TableInfo<$OutboxEntriesTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseRevMeta = const VerificationMeta(
    'baseRev',
  );
  @override
  late final GeneratedColumn<int> baseRev = GeneratedColumn<int>(
    'base_rev',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entity,
    entityId,
    op,
    payload,
    baseRev,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('base_rev')) {
      context.handle(
        _baseRevMeta,
        baseRev.isAcceptableOrUnknown(data['base_rev']!, _baseRevMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      baseRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_rev'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OutboxEntriesTable createAlias(String alias) {
    return $OutboxEntriesTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final int id;
  final String entity;
  final String entityId;
  final String op;
  final String payload;
  final int? baseRev;
  final DateTime createdAt;
  const OutboxEntry({
    required this.id,
    required this.entity,
    required this.entityId,
    required this.op,
    required this.payload,
    this.baseRev,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['op'] = Variable<String>(op);
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || baseRev != null) {
      map['base_rev'] = Variable<int>(baseRev);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return OutboxEntriesCompanion(
      id: Value(id),
      entity: Value(entity),
      entityId: Value(entityId),
      op: Value(op),
      payload: Value(payload),
      baseRev: baseRev == null && nullToAbsent
          ? const Value.absent()
          : Value(baseRev),
      createdAt: Value(createdAt),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<int>(json['id']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      op: serializer.fromJson<String>(json['op']),
      payload: serializer.fromJson<String>(json['payload']),
      baseRev: serializer.fromJson<int?>(json['baseRev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'op': serializer.toJson<String>(op),
      'payload': serializer.toJson<String>(payload),
      'baseRev': serializer.toJson<int?>(baseRev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OutboxEntry copyWith({
    int? id,
    String? entity,
    String? entityId,
    String? op,
    String? payload,
    Value<int?> baseRev = const Value.absent(),
    DateTime? createdAt,
  }) => OutboxEntry(
    id: id ?? this.id,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    op: op ?? this.op,
    payload: payload ?? this.payload,
    baseRev: baseRev.present ? baseRev.value : this.baseRev,
    createdAt: createdAt ?? this.createdAt,
  );
  OutboxEntry copyWithCompanion(OutboxEntriesCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      op: data.op.present ? data.op.value : this.op,
      payload: data.payload.present ? data.payload.value : this.payload,
      baseRev: data.baseRev.present ? data.baseRev.value : this.baseRev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('baseRev: $baseRev, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entity, entityId, op, payload, baseRev, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.op == this.op &&
          other.payload == this.payload &&
          other.baseRev == this.baseRev &&
          other.createdAt == this.createdAt);
}

class OutboxEntriesCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<int> id;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> op;
  final Value<String> payload;
  final Value<int?> baseRev;
  final Value<DateTime> createdAt;
  const OutboxEntriesCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.op = const Value.absent(),
    this.payload = const Value.absent(),
    this.baseRev = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OutboxEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String entity,
    required String entityId,
    required String op,
    required String payload,
    this.baseRev = const Value.absent(),
    required DateTime createdAt,
  }) : entity = Value(entity),
       entityId = Value(entityId),
       op = Value(op),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<OutboxEntry> custom({
    Expression<int>? id,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? op,
    Expression<String>? payload,
    Expression<int>? baseRev,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (op != null) 'op': op,
      if (payload != null) 'payload': payload,
      if (baseRev != null) 'base_rev': baseRev,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OutboxEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String>? op,
    Value<String>? payload,
    Value<int?>? baseRev,
    Value<DateTime>? createdAt,
  }) {
    return OutboxEntriesCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      op: op ?? this.op,
      payload: payload ?? this.payload,
      baseRev: baseRev ?? this.baseRev,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (baseRev.present) {
      map['base_rev'] = Variable<int>(baseRev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntriesCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payload: $payload, ')
          ..write('baseRev: $baseRev, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SyncCursorsTable extends SyncCursors
    with TableInfo<$SyncCursorsTable, SyncCursor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastRevMeta = const VerificationMeta(
    'lastRev',
  );
  @override
  late final GeneratedColumn<int> lastRev = GeneratedColumn<int>(
    'last_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [entity, lastRev];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCursor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('last_rev')) {
      context.handle(
        _lastRevMeta,
        lastRev.isAcceptableOrUnknown(data['last_rev']!, _lastRevMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entity};
  @override
  SyncCursor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursor(
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      lastRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_rev'],
      )!,
    );
  }

  @override
  $SyncCursorsTable createAlias(String alias) {
    return $SyncCursorsTable(attachedDatabase, alias);
  }
}

class SyncCursor extends DataClass implements Insertable<SyncCursor> {
  final String entity;
  final int lastRev;
  const SyncCursor({required this.entity, required this.lastRev});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity'] = Variable<String>(entity);
    map['last_rev'] = Variable<int>(lastRev);
    return map;
  }

  SyncCursorsCompanion toCompanion(bool nullToAbsent) {
    return SyncCursorsCompanion(entity: Value(entity), lastRev: Value(lastRev));
  }

  factory SyncCursor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCursor(
      entity: serializer.fromJson<String>(json['entity']),
      lastRev: serializer.fromJson<int>(json['lastRev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entity': serializer.toJson<String>(entity),
      'lastRev': serializer.toJson<int>(lastRev),
    };
  }

  SyncCursor copyWith({String? entity, int? lastRev}) => SyncCursor(
    entity: entity ?? this.entity,
    lastRev: lastRev ?? this.lastRev,
  );
  SyncCursor copyWithCompanion(SyncCursorsCompanion data) {
    return SyncCursor(
      entity: data.entity.present ? data.entity.value : this.entity,
      lastRev: data.lastRev.present ? data.lastRev.value : this.lastRev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursor(')
          ..write('entity: $entity, ')
          ..write('lastRev: $lastRev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entity, lastRev);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCursor &&
          other.entity == this.entity &&
          other.lastRev == this.lastRev);
}

class SyncCursorsCompanion extends UpdateCompanion<SyncCursor> {
  final Value<String> entity;
  final Value<int> lastRev;
  final Value<int> rowid;
  const SyncCursorsCompanion({
    this.entity = const Value.absent(),
    this.lastRev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCursorsCompanion.insert({
    required String entity,
    this.lastRev = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entity = Value(entity);
  static Insertable<SyncCursor> custom({
    Expression<String>? entity,
    Expression<int>? lastRev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entity != null) 'entity': entity,
      if (lastRev != null) 'last_rev': lastRev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCursorsCompanion copyWith({
    Value<String>? entity,
    Value<int>? lastRev,
    Value<int>? rowid,
  }) {
    return SyncCursorsCompanion(
      entity: entity ?? this.entity,
      lastRev: lastRev ?? this.lastRev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (lastRev.present) {
      map['last_rev'] = Variable<int>(lastRev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorsCompanion(')
          ..write('entity: $entity, ')
          ..write('lastRev: $lastRev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SpeciesTable species = $SpeciesTable(this);
  late final $RoomsTable rooms = $RoomsTable(this);
  late final $UserPlantsTable userPlants = $UserPlantsTable(this);
  late final $CareSchedulesTable careSchedules = $CareSchedulesTable(this);
  late final $CareLogsTable careLogs = $CareLogsTable(this);
  late final $NotificationRegistryRowsTable notificationRegistryRows =
      $NotificationRegistryRowsTable(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final $SyncCursorsTable syncCursors = $SyncCursorsTable(this);
  late final PlantsDao plantsDao = PlantsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    species,
    rooms,
    userPlants,
    careSchedules,
    careLogs,
    notificationRegistryRows,
    outboxEntries,
    syncCursors,
  ];
}

typedef $$SpeciesTableCreateCompanionBuilder =
    SpeciesCompanion Function({
      required String id,
      required String scientificName,
      required String commonName,
      Value<String?> family,
      required int wateringIntervalDays,
      Value<int?> fertilizeIntervalDays,
      Value<LightLevel?> lightLevel,
      Value<bool?> toxicToPets,
      Value<int> catalogVersion,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SpeciesTableUpdateCompanionBuilder =
    SpeciesCompanion Function({
      Value<String> id,
      Value<String> scientificName,
      Value<String> commonName,
      Value<String?> family,
      Value<int> wateringIntervalDays,
      Value<int?> fertilizeIntervalDays,
      Value<LightLevel?> lightLevel,
      Value<bool?> toxicToPets,
      Value<int> catalogVersion,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SpeciesTableFilterComposer
    extends Composer<_$AppDatabase, $SpeciesTable> {
  $$SpeciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scientificName => $composableBuilder(
    column: $table.scientificName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commonName => $composableBuilder(
    column: $table.commonName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get family => $composableBuilder(
    column: $table.family,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wateringIntervalDays => $composableBuilder(
    column: $table.wateringIntervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fertilizeIntervalDays => $composableBuilder(
    column: $table.fertilizeIntervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LightLevel?, LightLevel, String>
  get lightLevel => $composableBuilder(
    column: $table.lightLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get toxicToPets => $composableBuilder(
    column: $table.toxicToPets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SpeciesTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeciesTable> {
  $$SpeciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scientificName => $composableBuilder(
    column: $table.scientificName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commonName => $composableBuilder(
    column: $table.commonName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get family => $composableBuilder(
    column: $table.family,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wateringIntervalDays => $composableBuilder(
    column: $table.wateringIntervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fertilizeIntervalDays => $composableBuilder(
    column: $table.fertilizeIntervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lightLevel => $composableBuilder(
    column: $table.lightLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get toxicToPets => $composableBuilder(
    column: $table.toxicToPets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpeciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeciesTable> {
  $$SpeciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scientificName => $composableBuilder(
    column: $table.scientificName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get commonName => $composableBuilder(
    column: $table.commonName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get family =>
      $composableBuilder(column: $table.family, builder: (column) => column);

  GeneratedColumn<int> get wateringIntervalDays => $composableBuilder(
    column: $table.wateringIntervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fertilizeIntervalDays => $composableBuilder(
    column: $table.fertilizeIntervalDays,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LightLevel?, String> get lightLevel =>
      $composableBuilder(
        column: $table.lightLevel,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get toxicToPets => $composableBuilder(
    column: $table.toxicToPets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get catalogVersion => $composableBuilder(
    column: $table.catalogVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SpeciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpeciesTable,
          SpeciesRow,
          $$SpeciesTableFilterComposer,
          $$SpeciesTableOrderingComposer,
          $$SpeciesTableAnnotationComposer,
          $$SpeciesTableCreateCompanionBuilder,
          $$SpeciesTableUpdateCompanionBuilder,
          (
            SpeciesRow,
            BaseReferences<_$AppDatabase, $SpeciesTable, SpeciesRow>,
          ),
          SpeciesRow,
          PrefetchHooks Function()
        > {
  $$SpeciesTableTableManager(_$AppDatabase db, $SpeciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> scientificName = const Value.absent(),
                Value<String> commonName = const Value.absent(),
                Value<String?> family = const Value.absent(),
                Value<int> wateringIntervalDays = const Value.absent(),
                Value<int?> fertilizeIntervalDays = const Value.absent(),
                Value<LightLevel?> lightLevel = const Value.absent(),
                Value<bool?> toxicToPets = const Value.absent(),
                Value<int> catalogVersion = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpeciesCompanion(
                id: id,
                scientificName: scientificName,
                commonName: commonName,
                family: family,
                wateringIntervalDays: wateringIntervalDays,
                fertilizeIntervalDays: fertilizeIntervalDays,
                lightLevel: lightLevel,
                toxicToPets: toxicToPets,
                catalogVersion: catalogVersion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String scientificName,
                required String commonName,
                Value<String?> family = const Value.absent(),
                required int wateringIntervalDays,
                Value<int?> fertilizeIntervalDays = const Value.absent(),
                Value<LightLevel?> lightLevel = const Value.absent(),
                Value<bool?> toxicToPets = const Value.absent(),
                Value<int> catalogVersion = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SpeciesCompanion.insert(
                id: id,
                scientificName: scientificName,
                commonName: commonName,
                family: family,
                wateringIntervalDays: wateringIntervalDays,
                fertilizeIntervalDays: fertilizeIntervalDays,
                lightLevel: lightLevel,
                toxicToPets: toxicToPets,
                catalogVersion: catalogVersion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpeciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpeciesTable,
      SpeciesRow,
      $$SpeciesTableFilterComposer,
      $$SpeciesTableOrderingComposer,
      $$SpeciesTableAnnotationComposer,
      $$SpeciesTableCreateCompanionBuilder,
      $$SpeciesTableUpdateCompanionBuilder,
      (SpeciesRow, BaseReferences<_$AppDatabase, $SpeciesTable, SpeciesRow>),
      SpeciesRow,
      PrefetchHooks Function()
    >;
typedef $$RoomsTableCreateCompanionBuilder =
    RoomsCompanion Function({
      required String id,
      required String name,
      Value<WindowOrientation?> orientation,
      Value<bool> outdoor,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<SyncState> sync,
      Value<int?> serverRev,
      Value<int> rowid,
    });
typedef $$RoomsTableUpdateCompanionBuilder =
    RoomsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<WindowOrientation?> orientation,
      Value<bool> outdoor,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<SyncState> sync,
      Value<int?> serverRev,
      Value<int> rowid,
    });

class $$RoomsTableFilterComposer extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WindowOrientation?, WindowOrientation, String>
  get orientation => $composableBuilder(
    column: $table.orientation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get outdoor => $composableBuilder(
    column: $table.outdoor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get sync =>
      $composableBuilder(
        column: $table.sync,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orientation => $composableBuilder(
    column: $table.orientation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get outdoor => $composableBuilder(
    column: $table.outdoor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sync => $composableBuilder(
    column: $table.sync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WindowOrientation?, String>
  get orientation => $composableBuilder(
    column: $table.orientation,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get outdoor =>
      $composableBuilder(column: $table.outdoor, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get sync =>
      $composableBuilder(column: $table.sync, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);
}

class $$RoomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomsTable,
          Room,
          $$RoomsTableFilterComposer,
          $$RoomsTableOrderingComposer,
          $$RoomsTableAnnotationComposer,
          $$RoomsTableCreateCompanionBuilder,
          $$RoomsTableUpdateCompanionBuilder,
          (Room, BaseReferences<_$AppDatabase, $RoomsTable, Room>),
          Room,
          PrefetchHooks Function()
        > {
  $$RoomsTableTableManager(_$AppDatabase db, $RoomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<WindowOrientation?> orientation = const Value.absent(),
                Value<bool> outdoor = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<SyncState> sync = const Value.absent(),
                Value<int?> serverRev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomsCompanion(
                id: id,
                name: name,
                orientation: orientation,
                outdoor: outdoor,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                sync: sync,
                serverRev: serverRev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<WindowOrientation?> orientation = const Value.absent(),
                Value<bool> outdoor = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<SyncState> sync = const Value.absent(),
                Value<int?> serverRev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomsCompanion.insert(
                id: id,
                name: name,
                orientation: orientation,
                outdoor: outdoor,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                sync: sync,
                serverRev: serverRev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomsTable,
      Room,
      $$RoomsTableFilterComposer,
      $$RoomsTableOrderingComposer,
      $$RoomsTableAnnotationComposer,
      $$RoomsTableCreateCompanionBuilder,
      $$RoomsTableUpdateCompanionBuilder,
      (Room, BaseReferences<_$AppDatabase, $RoomsTable, Room>),
      Room,
      PrefetchHooks Function()
    >;
typedef $$UserPlantsTableCreateCompanionBuilder =
    UserPlantsCompanion Function({
      required String id,
      Value<String?> speciesId,
      Value<String?> roomId,
      required String nickname,
      Value<String?> photoPath,
      Value<DateTime?> acquiredAt,
      Value<PlantStatus> status,
      Value<int> version,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<SyncState> sync,
      Value<int?> serverRev,
      Value<int> rowid,
    });
typedef $$UserPlantsTableUpdateCompanionBuilder =
    UserPlantsCompanion Function({
      Value<String> id,
      Value<String?> speciesId,
      Value<String?> roomId,
      Value<String> nickname,
      Value<String?> photoPath,
      Value<DateTime?> acquiredAt,
      Value<PlantStatus> status,
      Value<int> version,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<SyncState> sync,
      Value<int?> serverRev,
      Value<int> rowid,
    });

class $$UserPlantsTableFilterComposer
    extends Composer<_$AppDatabase, $UserPlantsTable> {
  $$UserPlantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PlantStatus, PlantStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get sync =>
      $composableBuilder(
        column: $table.sync,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPlantsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPlantsTable> {
  $$UserPlantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speciesId => $composableBuilder(
    column: $table.speciesId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sync => $composableBuilder(
    column: $table.sync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPlantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPlantsTable> {
  $$UserPlantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get speciesId =>
      $composableBuilder(column: $table.speciesId, builder: (column) => column);

  GeneratedColumn<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PlantStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get sync =>
      $composableBuilder(column: $table.sync, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);
}

class $$UserPlantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPlantsTable,
          UserPlant,
          $$UserPlantsTableFilterComposer,
          $$UserPlantsTableOrderingComposer,
          $$UserPlantsTableAnnotationComposer,
          $$UserPlantsTableCreateCompanionBuilder,
          $$UserPlantsTableUpdateCompanionBuilder,
          (
            UserPlant,
            BaseReferences<_$AppDatabase, $UserPlantsTable, UserPlant>,
          ),
          UserPlant,
          PrefetchHooks Function()
        > {
  $$UserPlantsTableTableManager(_$AppDatabase db, $UserPlantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPlantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPlantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPlantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> speciesId = const Value.absent(),
                Value<String?> roomId = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime?> acquiredAt = const Value.absent(),
                Value<PlantStatus> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<SyncState> sync = const Value.absent(),
                Value<int?> serverRev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPlantsCompanion(
                id: id,
                speciesId: speciesId,
                roomId: roomId,
                nickname: nickname,
                photoPath: photoPath,
                acquiredAt: acquiredAt,
                status: status,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                sync: sync,
                serverRev: serverRev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> speciesId = const Value.absent(),
                Value<String?> roomId = const Value.absent(),
                required String nickname,
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime?> acquiredAt = const Value.absent(),
                Value<PlantStatus> status = const Value.absent(),
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<SyncState> sync = const Value.absent(),
                Value<int?> serverRev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPlantsCompanion.insert(
                id: id,
                speciesId: speciesId,
                roomId: roomId,
                nickname: nickname,
                photoPath: photoPath,
                acquiredAt: acquiredAt,
                status: status,
                version: version,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                sync: sync,
                serverRev: serverRev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPlantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPlantsTable,
      UserPlant,
      $$UserPlantsTableFilterComposer,
      $$UserPlantsTableOrderingComposer,
      $$UserPlantsTableAnnotationComposer,
      $$UserPlantsTableCreateCompanionBuilder,
      $$UserPlantsTableUpdateCompanionBuilder,
      (UserPlant, BaseReferences<_$AppDatabase, $UserPlantsTable, UserPlant>),
      UserPlant,
      PrefetchHooks Function()
    >;
typedef $$CareSchedulesTableCreateCompanionBuilder =
    CareSchedulesCompanion Function({
      required String id,
      required String userPlantId,
      required CareType type,
      required int baseIntervalDays,
      Value<AnchorMode> anchor,
      Value<int> timeOfDayMinutes,
      required String tzId,
      Value<String?> seasonalMul,
      Value<bool> weatherSensitive,
      Value<bool> active,
      Value<DateTime?> nextDueAt,
      Value<DateTime?> snoozedUntil,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<SyncState> sync,
      Value<int?> serverRev,
      Value<int> rowid,
    });
typedef $$CareSchedulesTableUpdateCompanionBuilder =
    CareSchedulesCompanion Function({
      Value<String> id,
      Value<String> userPlantId,
      Value<CareType> type,
      Value<int> baseIntervalDays,
      Value<AnchorMode> anchor,
      Value<int> timeOfDayMinutes,
      Value<String> tzId,
      Value<String?> seasonalMul,
      Value<bool> weatherSensitive,
      Value<bool> active,
      Value<DateTime?> nextDueAt,
      Value<DateTime?> snoozedUntil,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<SyncState> sync,
      Value<int?> serverRev,
      Value<int> rowid,
    });

class $$CareSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $CareSchedulesTable> {
  $$CareSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userPlantId => $composableBuilder(
    column: $table.userPlantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CareType, CareType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get baseIntervalDays => $composableBuilder(
    column: $table.baseIntervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AnchorMode, AnchorMode, String> get anchor =>
      $composableBuilder(
        column: $table.anchor,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get timeOfDayMinutes => $composableBuilder(
    column: $table.timeOfDayMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tzId => $composableBuilder(
    column: $table.tzId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seasonalMul => $composableBuilder(
    column: $table.seasonalMul,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get weatherSensitive => $composableBuilder(
    column: $table.weatherSensitive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDueAt => $composableBuilder(
    column: $table.nextDueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get sync =>
      $composableBuilder(
        column: $table.sync,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CareSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $CareSchedulesTable> {
  $$CareSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userPlantId => $composableBuilder(
    column: $table.userPlantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseIntervalDays => $composableBuilder(
    column: $table.baseIntervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchor => $composableBuilder(
    column: $table.anchor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeOfDayMinutes => $composableBuilder(
    column: $table.timeOfDayMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tzId => $composableBuilder(
    column: $table.tzId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seasonalMul => $composableBuilder(
    column: $table.seasonalMul,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get weatherSensitive => $composableBuilder(
    column: $table.weatherSensitive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDueAt => $composableBuilder(
    column: $table.nextDueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sync => $composableBuilder(
    column: $table.sync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CareSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareSchedulesTable> {
  $$CareSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userPlantId => $composableBuilder(
    column: $table.userPlantId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CareType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get baseIntervalDays => $composableBuilder(
    column: $table.baseIntervalDays,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AnchorMode, String> get anchor =>
      $composableBuilder(column: $table.anchor, builder: (column) => column);

  GeneratedColumn<int> get timeOfDayMinutes => $composableBuilder(
    column: $table.timeOfDayMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tzId =>
      $composableBuilder(column: $table.tzId, builder: (column) => column);

  GeneratedColumn<String> get seasonalMul => $composableBuilder(
    column: $table.seasonalMul,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get weatherSensitive => $composableBuilder(
    column: $table.weatherSensitive,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueAt =>
      $composableBuilder(column: $table.nextDueAt, builder: (column) => column);

  GeneratedColumn<DateTime> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get sync =>
      $composableBuilder(column: $table.sync, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);
}

class $$CareSchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CareSchedulesTable,
          CareSchedule,
          $$CareSchedulesTableFilterComposer,
          $$CareSchedulesTableOrderingComposer,
          $$CareSchedulesTableAnnotationComposer,
          $$CareSchedulesTableCreateCompanionBuilder,
          $$CareSchedulesTableUpdateCompanionBuilder,
          (
            CareSchedule,
            BaseReferences<_$AppDatabase, $CareSchedulesTable, CareSchedule>,
          ),
          CareSchedule,
          PrefetchHooks Function()
        > {
  $$CareSchedulesTableTableManager(_$AppDatabase db, $CareSchedulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CareSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareSchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userPlantId = const Value.absent(),
                Value<CareType> type = const Value.absent(),
                Value<int> baseIntervalDays = const Value.absent(),
                Value<AnchorMode> anchor = const Value.absent(),
                Value<int> timeOfDayMinutes = const Value.absent(),
                Value<String> tzId = const Value.absent(),
                Value<String?> seasonalMul = const Value.absent(),
                Value<bool> weatherSensitive = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime?> nextDueAt = const Value.absent(),
                Value<DateTime?> snoozedUntil = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<SyncState> sync = const Value.absent(),
                Value<int?> serverRev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CareSchedulesCompanion(
                id: id,
                userPlantId: userPlantId,
                type: type,
                baseIntervalDays: baseIntervalDays,
                anchor: anchor,
                timeOfDayMinutes: timeOfDayMinutes,
                tzId: tzId,
                seasonalMul: seasonalMul,
                weatherSensitive: weatherSensitive,
                active: active,
                nextDueAt: nextDueAt,
                snoozedUntil: snoozedUntil,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sync: sync,
                serverRev: serverRev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userPlantId,
                required CareType type,
                required int baseIntervalDays,
                Value<AnchorMode> anchor = const Value.absent(),
                Value<int> timeOfDayMinutes = const Value.absent(),
                required String tzId,
                Value<String?> seasonalMul = const Value.absent(),
                Value<bool> weatherSensitive = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime?> nextDueAt = const Value.absent(),
                Value<DateTime?> snoozedUntil = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<SyncState> sync = const Value.absent(),
                Value<int?> serverRev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CareSchedulesCompanion.insert(
                id: id,
                userPlantId: userPlantId,
                type: type,
                baseIntervalDays: baseIntervalDays,
                anchor: anchor,
                timeOfDayMinutes: timeOfDayMinutes,
                tzId: tzId,
                seasonalMul: seasonalMul,
                weatherSensitive: weatherSensitive,
                active: active,
                nextDueAt: nextDueAt,
                snoozedUntil: snoozedUntil,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sync: sync,
                serverRev: serverRev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CareSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CareSchedulesTable,
      CareSchedule,
      $$CareSchedulesTableFilterComposer,
      $$CareSchedulesTableOrderingComposer,
      $$CareSchedulesTableAnnotationComposer,
      $$CareSchedulesTableCreateCompanionBuilder,
      $$CareSchedulesTableUpdateCompanionBuilder,
      (
        CareSchedule,
        BaseReferences<_$AppDatabase, $CareSchedulesTable, CareSchedule>,
      ),
      CareSchedule,
      PrefetchHooks Function()
    >;
typedef $$CareLogsTableCreateCompanionBuilder =
    CareLogsCompanion Function({
      required String id,
      required String userPlantId,
      required CareType type,
      required DateTime performedAt,
      Value<CareLogSource> source,
      Value<int?> amountMl,
      Value<String?> note,
      Value<String?> photoPath,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<SyncState> sync,
      Value<int?> serverRev,
      Value<int> rowid,
    });
typedef $$CareLogsTableUpdateCompanionBuilder =
    CareLogsCompanion Function({
      Value<String> id,
      Value<String> userPlantId,
      Value<CareType> type,
      Value<DateTime> performedAt,
      Value<CareLogSource> source,
      Value<int?> amountMl,
      Value<String?> note,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<SyncState> sync,
      Value<int?> serverRev,
      Value<int> rowid,
    });

class $$CareLogsTableFilterComposer
    extends Composer<_$AppDatabase, $CareLogsTable> {
  $$CareLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userPlantId => $composableBuilder(
    column: $table.userPlantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CareType, CareType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CareLogSource, CareLogSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get sync =>
      $composableBuilder(
        column: $table.sync,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CareLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $CareLogsTable> {
  $$CareLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userPlantId => $composableBuilder(
    column: $table.userPlantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sync => $composableBuilder(
    column: $table.sync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverRev => $composableBuilder(
    column: $table.serverRev,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CareLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CareLogsTable> {
  $$CareLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userPlantId => $composableBuilder(
    column: $table.userPlantId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CareType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CareLogSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get amountMl =>
      $composableBuilder(column: $table.amountMl, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get sync =>
      $composableBuilder(column: $table.sync, builder: (column) => column);

  GeneratedColumn<int> get serverRev =>
      $composableBuilder(column: $table.serverRev, builder: (column) => column);
}

class $$CareLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CareLogsTable,
          CareLog,
          $$CareLogsTableFilterComposer,
          $$CareLogsTableOrderingComposer,
          $$CareLogsTableAnnotationComposer,
          $$CareLogsTableCreateCompanionBuilder,
          $$CareLogsTableUpdateCompanionBuilder,
          (CareLog, BaseReferences<_$AppDatabase, $CareLogsTable, CareLog>),
          CareLog,
          PrefetchHooks Function()
        > {
  $$CareLogsTableTableManager(_$AppDatabase db, $CareLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CareLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CareLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CareLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userPlantId = const Value.absent(),
                Value<CareType> type = const Value.absent(),
                Value<DateTime> performedAt = const Value.absent(),
                Value<CareLogSource> source = const Value.absent(),
                Value<int?> amountMl = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<SyncState> sync = const Value.absent(),
                Value<int?> serverRev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CareLogsCompanion(
                id: id,
                userPlantId: userPlantId,
                type: type,
                performedAt: performedAt,
                source: source,
                amountMl: amountMl,
                note: note,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                sync: sync,
                serverRev: serverRev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userPlantId,
                required CareType type,
                required DateTime performedAt,
                Value<CareLogSource> source = const Value.absent(),
                Value<int?> amountMl = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<SyncState> sync = const Value.absent(),
                Value<int?> serverRev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CareLogsCompanion.insert(
                id: id,
                userPlantId: userPlantId,
                type: type,
                performedAt: performedAt,
                source: source,
                amountMl: amountMl,
                note: note,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                sync: sync,
                serverRev: serverRev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CareLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CareLogsTable,
      CareLog,
      $$CareLogsTableFilterComposer,
      $$CareLogsTableOrderingComposer,
      $$CareLogsTableAnnotationComposer,
      $$CareLogsTableCreateCompanionBuilder,
      $$CareLogsTableUpdateCompanionBuilder,
      (CareLog, BaseReferences<_$AppDatabase, $CareLogsTable, CareLog>),
      CareLog,
      PrefetchHooks Function()
    >;
typedef $$NotificationRegistryRowsTableCreateCompanionBuilder =
    NotificationRegistryRowsCompanion Function({
      Value<int> osNotificationId,
      required String scheduleId,
      required DateTime firesAt,
      required String fingerprint,
    });
typedef $$NotificationRegistryRowsTableUpdateCompanionBuilder =
    NotificationRegistryRowsCompanion Function({
      Value<int> osNotificationId,
      Value<String> scheduleId,
      Value<DateTime> firesAt,
      Value<String> fingerprint,
    });

class $$NotificationRegistryRowsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationRegistryRowsTable> {
  $$NotificationRegistryRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get osNotificationId => $composableBuilder(
    column: $table.osNotificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firesAt => $composableBuilder(
    column: $table.firesAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationRegistryRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationRegistryRowsTable> {
  $$NotificationRegistryRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get osNotificationId => $composableBuilder(
    column: $table.osNotificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firesAt => $composableBuilder(
    column: $table.firesAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationRegistryRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationRegistryRowsTable> {
  $$NotificationRegistryRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get osNotificationId => $composableBuilder(
    column: $table.osNotificationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduleId => $composableBuilder(
    column: $table.scheduleId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get firesAt =>
      $composableBuilder(column: $table.firesAt, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );
}

class $$NotificationRegistryRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationRegistryRowsTable,
          NotificationRegistryRow,
          $$NotificationRegistryRowsTableFilterComposer,
          $$NotificationRegistryRowsTableOrderingComposer,
          $$NotificationRegistryRowsTableAnnotationComposer,
          $$NotificationRegistryRowsTableCreateCompanionBuilder,
          $$NotificationRegistryRowsTableUpdateCompanionBuilder,
          (
            NotificationRegistryRow,
            BaseReferences<
              _$AppDatabase,
              $NotificationRegistryRowsTable,
              NotificationRegistryRow
            >,
          ),
          NotificationRegistryRow,
          PrefetchHooks Function()
        > {
  $$NotificationRegistryRowsTableTableManager(
    _$AppDatabase db,
    $NotificationRegistryRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationRegistryRowsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NotificationRegistryRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationRegistryRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> osNotificationId = const Value.absent(),
                Value<String> scheduleId = const Value.absent(),
                Value<DateTime> firesAt = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
              }) => NotificationRegistryRowsCompanion(
                osNotificationId: osNotificationId,
                scheduleId: scheduleId,
                firesAt: firesAt,
                fingerprint: fingerprint,
              ),
          createCompanionCallback:
              ({
                Value<int> osNotificationId = const Value.absent(),
                required String scheduleId,
                required DateTime firesAt,
                required String fingerprint,
              }) => NotificationRegistryRowsCompanion.insert(
                osNotificationId: osNotificationId,
                scheduleId: scheduleId,
                firesAt: firesAt,
                fingerprint: fingerprint,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationRegistryRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationRegistryRowsTable,
      NotificationRegistryRow,
      $$NotificationRegistryRowsTableFilterComposer,
      $$NotificationRegistryRowsTableOrderingComposer,
      $$NotificationRegistryRowsTableAnnotationComposer,
      $$NotificationRegistryRowsTableCreateCompanionBuilder,
      $$NotificationRegistryRowsTableUpdateCompanionBuilder,
      (
        NotificationRegistryRow,
        BaseReferences<
          _$AppDatabase,
          $NotificationRegistryRowsTable,
          NotificationRegistryRow
        >,
      ),
      NotificationRegistryRow,
      PrefetchHooks Function()
    >;
typedef $$OutboxEntriesTableCreateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<int> id,
      required String entity,
      required String entityId,
      required String op,
      required String payload,
      Value<int?> baseRev,
      required DateTime createdAt,
    });
typedef $$OutboxEntriesTableUpdateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<int> id,
      Value<String> entity,
      Value<String> entityId,
      Value<String> op,
      Value<String> payload,
      Value<int?> baseRev,
      Value<DateTime> createdAt,
    });

class $$OutboxEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseRev => $composableBuilder(
    column: $table.baseRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseRev => $composableBuilder(
    column: $table.baseRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get baseRev =>
      $composableBuilder(column: $table.baseRev, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OutboxEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxEntriesTable,
          OutboxEntry,
          $$OutboxEntriesTableFilterComposer,
          $$OutboxEntriesTableOrderingComposer,
          $$OutboxEntriesTableAnnotationComposer,
          $$OutboxEntriesTableCreateCompanionBuilder,
          $$OutboxEntriesTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$OutboxEntriesTableTableManager(_$AppDatabase db, $OutboxEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int?> baseRev = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OutboxEntriesCompanion(
                id: id,
                entity: entity,
                entityId: entityId,
                op: op,
                payload: payload,
                baseRev: baseRev,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entity,
                required String entityId,
                required String op,
                required String payload,
                Value<int?> baseRev = const Value.absent(),
                required DateTime createdAt,
              }) => OutboxEntriesCompanion.insert(
                id: id,
                entity: entity,
                entityId: entityId,
                op: op,
                payload: payload,
                baseRev: baseRev,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxEntriesTable,
      OutboxEntry,
      $$OutboxEntriesTableFilterComposer,
      $$OutboxEntriesTableOrderingComposer,
      $$OutboxEntriesTableAnnotationComposer,
      $$OutboxEntriesTableCreateCompanionBuilder,
      $$OutboxEntriesTableUpdateCompanionBuilder,
      (
        OutboxEntry,
        BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
      ),
      OutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncCursorsTableCreateCompanionBuilder =
    SyncCursorsCompanion Function({
      required String entity,
      Value<int> lastRev,
      Value<int> rowid,
    });
typedef $$SyncCursorsTableUpdateCompanionBuilder =
    SyncCursorsCompanion Function({
      Value<String> entity,
      Value<int> lastRev,
      Value<int> rowid,
    });

class $$SyncCursorsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastRev => $composableBuilder(
    column: $table.lastRev,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncCursorsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastRev => $composableBuilder(
    column: $table.lastRev,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncCursorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<int> get lastRev =>
      $composableBuilder(column: $table.lastRev, builder: (column) => column);
}

class $$SyncCursorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncCursorsTable,
          SyncCursor,
          $$SyncCursorsTableFilterComposer,
          $$SyncCursorsTableOrderingComposer,
          $$SyncCursorsTableAnnotationComposer,
          $$SyncCursorsTableCreateCompanionBuilder,
          $$SyncCursorsTableUpdateCompanionBuilder,
          (
            SyncCursor,
            BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursor>,
          ),
          SyncCursor,
          PrefetchHooks Function()
        > {
  $$SyncCursorsTableTableManager(_$AppDatabase db, $SyncCursorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCursorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncCursorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entity = const Value.absent(),
                Value<int> lastRev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion(
                entity: entity,
                lastRev: lastRev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entity,
                Value<int> lastRev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion.insert(
                entity: entity,
                lastRev: lastRev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncCursorsTable,
      SyncCursor,
      $$SyncCursorsTableFilterComposer,
      $$SyncCursorsTableOrderingComposer,
      $$SyncCursorsTableAnnotationComposer,
      $$SyncCursorsTableCreateCompanionBuilder,
      $$SyncCursorsTableUpdateCompanionBuilder,
      (
        SyncCursor,
        BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursor>,
      ),
      SyncCursor,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SpeciesTableTableManager get species =>
      $$SpeciesTableTableManager(_db, _db.species);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db, _db.rooms);
  $$UserPlantsTableTableManager get userPlants =>
      $$UserPlantsTableTableManager(_db, _db.userPlants);
  $$CareSchedulesTableTableManager get careSchedules =>
      $$CareSchedulesTableTableManager(_db, _db.careSchedules);
  $$CareLogsTableTableManager get careLogs =>
      $$CareLogsTableTableManager(_db, _db.careLogs);
  $$NotificationRegistryRowsTableTableManager get notificationRegistryRows =>
      $$NotificationRegistryRowsTableTableManager(
        _db,
        _db.notificationRegistryRows,
      );
  $$OutboxEntriesTableTableManager get outboxEntries =>
      $$OutboxEntriesTableTableManager(_db, _db.outboxEntries);
  $$SyncCursorsTableTableManager get syncCursors =>
      $$SyncCursorsTableTableManager(_db, _db.syncCursors);
}
