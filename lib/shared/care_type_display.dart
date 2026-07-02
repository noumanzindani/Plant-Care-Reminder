import 'package:flutter/material.dart';

import '../core/domain/value_objects/enums.dart';

/// Presentation helpers for [CareType]: the icon and its present/past-tense verbs.
/// Shared so the care queue, journal, and future screens render care types identically.

IconData careTypeIcon(CareType type) => switch (type) {
      CareType.water => Icons.water_drop,
      CareType.fertilize => Icons.grass,
      CareType.mist => Icons.dew_point,
      CareType.repot => Icons.yard,
      CareType.rotate => Icons.sync,
      CareType.prune => Icons.content_cut,
      CareType.clean => Icons.cleaning_services,
      CareType.inspect => Icons.search,
    };

/// Imperative verb for an upcoming task, e.g. "Water Monstera".
String careVerb(CareType type) => switch (type) {
      CareType.water => 'Water',
      CareType.fertilize => 'Fertilize',
      CareType.mist => 'Mist',
      CareType.repot => 'Repot',
      CareType.rotate => 'Rotate',
      CareType.prune => 'Prune',
      CareType.clean => 'Clean',
      CareType.inspect => 'Inspect',
    };

/// Past-tense verb for a completed task in the journal, e.g. "Watered Monstera".
String carePastVerb(CareType type) => switch (type) {
      CareType.water => 'Watered',
      CareType.fertilize => 'Fertilized',
      CareType.mist => 'Misted',
      CareType.repot => 'Repotted',
      CareType.rotate => 'Rotated',
      CareType.prune => 'Pruned',
      CareType.clean => 'Cleaned',
      CareType.inspect => 'Inspected',
    };
