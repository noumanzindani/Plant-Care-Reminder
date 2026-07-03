import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../../app/providers.dart';
import '../../../core/data/db/database.dart';
import '../../../core/data/repositories/care_repository.dart';
import '../../../core/domain/value_objects/enums.dart';
import '../../../shared/care_type_display.dart';

/// A plant's detail screen: its name plus every care type it's scheduled for. Add care
/// types (water, fertilize, mist, …), each on its own cadence, or remove ones you no
/// longer track. Renders reactively from Drift, so edits appear immediately.
class PlantDetailScreen extends ConsumerWidget {
  const PlantDetailScreen({super.key, required this.plantId});

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plant = ref.watch(plantProvider(plantId));
    final schedules = ref.watch(plantSchedulesProvider(plantId));

    return Scaffold(
      appBar: AppBar(
        title: Text(plant.asData?.value?.nickname ?? 'Plant'),
      ),
      body: Column(
        children: [
          _SpeciesTile(plantId: plantId),
          _RoomTile(plantId: plantId),
          _OutdoorTile(plantId: plantId),
          const Divider(height: 1),
          Expanded(
            child: schedules.when(
              data: (items) => items.isEmpty
                  ? const _NoCareTypes()
                  : ListView(
                      children: [
                        for (final item in items) _ScheduleTile(item: item),
                        const SizedBox(height: 80),
                      ],
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Something went wrong: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: schedules.maybeWhen(
        data: (items) => FloatingActionButton.extended(
          onPressed: () => _addCareType(context, ref, items),
          icon: const Icon(Icons.add),
          label: const Text('Add care type'),
        ),
        orElse: () => null,
      ),
    );
  }

  Future<void> _addCareType(
    BuildContext context,
    WidgetRef ref,
    List<CareQueueItem> existing,
  ) async {
    final taken = existing.map((i) => i.type).toSet();
    final available = CareType.values.where((t) => !taken.contains(t)).toList();
    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Every care type is already scheduled.')),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddCareTypeSheet(plantId: plantId, available: available),
    );
  }
}

class _NoCareTypes extends StatelessWidget {
  const _NoCareTypes();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa_outlined, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('No care types yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Add a care type to start getting reminders for this plant.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// The plant's linked catalog species and its reference care facts (light need, pet
/// toxicity, family) — the "smart defaults" made visible. Renders nothing for an
/// unidentified plant (no `speciesId`) or before the catalog lookup resolves, so it's
/// invisible until there's something to show.
class _SpeciesTile extends ConsumerWidget {
  const _SpeciesTile({required this.plantId});

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speciesId = ref.watch(plantProvider(plantId)).asData?.value?.speciesId;
    if (speciesId == null) return const SizedBox.shrink();

    final detail = ref.watch(speciesDetailProvider(speciesId)).asData?.value;
    if (detail == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: Icon(Icons.eco_outlined, color: theme.colorScheme.primary),
          title: Text(detail.commonName),
          subtitle: Text(
            detail.scientificName,
            style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (detail.light != null)
                _InfoChip(
                    icon: Icons.wb_sunny_outlined, label: _lightLabel(detail.light!)),
              if (detail.toxicToPets != null)
                _InfoChip(
                  icon: Icons.pets_outlined,
                  label: detail.toxicToPets! ? 'Toxic to pets' : 'Pet-safe',
                ),
              if (detail.family != null)
                _InfoChip(icon: Icons.spa_outlined, label: detail.family!),
            ],
          ),
        ),
      ],
    );
  }

  String _lightLabel(LightLevel level) => switch (level) {
        LightLevel.low => 'Low light',
        LightLevel.medium => 'Medium light',
        LightLevel.bright => 'Bright light',
      };
}

/// A compact icon + label pill for a single species fact.
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

/// The plant's room assignment. Resolves the room name from the plant's `roomId` against
/// the live rooms list; tapping opens a picker to reassign or create a room.
class _RoomTile extends ConsumerWidget {
  const _RoomTile({required this.plantId});

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plant = ref.watch(plantProvider(plantId)).asData?.value;
    final rooms = ref.watch(roomsProvider).asData?.value ?? const <Room>[];
    final roomId = plant?.roomId;
    final match = rooms.where((r) => r.id == roomId);
    final roomName = (roomId != null && match.isNotEmpty) ? match.first.name : 'None';

    return ListTile(
      leading: Icon(Icons.meeting_room_outlined,
          color: Theme.of(context).colorScheme.primary),
      title: const Text('Room'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(roomName, style: Theme.of(context).textTheme.bodyMedium),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => _RoomPickerSheet(plantId: plantId, currentRoomId: roomId),
      ),
    );
  }
}

/// The outdoor flag of the plant's *room* — the location prior the weather overlay reads.
/// Outdoor is a property of the room (a balcony is outdoors for every plant on it), so the
/// toggle only appears once a room is assigned; toggling it affects that whole room.
class _OutdoorTile extends ConsumerWidget {
  const _OutdoorTile({required this.plantId});

  final String plantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomId = ref.watch(plantProvider(plantId)).asData?.value?.roomId;
    if (roomId == null) return const SizedBox.shrink(); // no room → nothing to mark outdoor

    final rooms = ref.watch(roomsProvider).asData?.value ?? const <Room>[];
    final match = rooms.where((r) => r.id == roomId);
    if (match.isEmpty) return const SizedBox.shrink();
    final room = match.first;

    return SwitchListTile(
      secondary: Icon(Icons.wb_cloudy_outlined,
          color: Theme.of(context).colorScheme.primary),
      title: const Text('Outdoor'),
      subtitle: Text('“${room.name}” gets local weather'),
      value: room.outdoor,
      onChanged: (v) => _setOutdoor(ref, room.id, v),
    );
  }

  Future<void> _setOutdoor(WidgetRef ref, String roomId, bool value) async {
    await ref.read(roomsRepositoryProvider).setRoomOutdoor(roomId: roomId, outdoor: value);
    await ref.read(reconcileCoordinatorProvider).reconcile();
  }
}

/// Bottom sheet to pick, clear, or create the plant's room.
class _RoomPickerSheet extends ConsumerStatefulWidget {
  const _RoomPickerSheet({required this.plantId, required this.currentRoomId});

  final String plantId;
  final String? currentRoomId;

  @override
  ConsumerState<_RoomPickerSheet> createState() => _RoomPickerSheetState();
}

class _RoomPickerSheetState extends ConsumerState<_RoomPickerSheet> {
  final _newRoomController = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _newRoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rooms = ref.watch(roomsProvider).asData?.value ?? const <Room>[];
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Room', style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          RadioGroup<String?>(
            groupValue: widget.currentRoomId,
            onChanged: (v) {
              if (!_busy) _assign(v);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const RadioListTile<String?>(
                  value: null,
                  title: Text('No room'),
                ),
                for (final room in rooms)
                  RadioListTile<String?>(
                    value: room.id,
                    title: Text(room.name),
                  ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newRoomController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'New room',
                      hintText: 'e.g. Living room',
                    ),
                    onSubmitted: (_) => _createAndAssign(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Create room',
                  onPressed: _busy ? null : _createAndAssign,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _assign(String? roomId) async {
    setState(() => _busy = true);
    await ref
        .read(roomsRepositoryProvider)
        .assignPlantToRoom(plantId: widget.plantId, roomId: roomId);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _createAndAssign() async {
    final name = _newRoomController.text.trim();
    if (name.isEmpty) return;
    setState(() => _busy = true);
    final repo = ref.read(roomsRepositoryProvider);
    final roomId = await repo.addRoom(name: name);
    await repo.assignPlantToRoom(plantId: widget.plantId, roomId: roomId);
    if (mounted) Navigator.of(context).pop();
  }
}

class _ScheduleTile extends ConsumerWidget {
  const _ScheduleTile({required this.item});

  final CareQueueItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          leading:
              Icon(careTypeIcon(item.type), color: Theme.of(context).colorScheme.primary),
          title: Text(careVerb(item.type)),
          subtitle: Text(_dueText(item.nextDueAt)),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Remove care type',
            onPressed: () => _remove(ref),
          ),
        ),
        // Weather adaptation only makes sense for watering (rain/heat/humidity shift when
        // the soil needs water); other care types don't read the forecast.
        if (item.type == CareType.water)
          SwitchListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(left: 72, right: 16),
            title: const Text('Weather-adaptive'),
            subtitle: const Text('Shift with local rain & heat (outdoor plants only)'),
            value: item.weatherSensitive,
            onChanged: (v) => _setWeather(ref, v),
          ),
        const Divider(height: 1),
      ],
    );
  }

  Future<void> _remove(WidgetRef ref) async {
    await ref.read(careRepositoryProvider).deactivateSchedule(item.scheduleId);
    await ref.read(reconcileCoordinatorProvider).reconcile();
  }

  Future<void> _setWeather(WidgetRef ref, bool value) async {
    await ref.read(careRepositoryProvider).setWeatherSensitive(item.scheduleId, value);
    await ref.read(reconcileCoordinatorProvider).reconcile();
  }

  String _dueText(DateTime? due) {
    if (due == null) return 'Scheduling…';
    final now = DateTime.now();
    final days = DateTime(due.year, due.month, due.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (days < 0) return 'Overdue by ${-days} day(s)';
    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    return 'Due in $days days';
  }
}

/// Bottom sheet for adding a care type: pick the type, its cadence, and reminder time.
class _AddCareTypeSheet extends ConsumerStatefulWidget {
  const _AddCareTypeSheet({required this.plantId, required this.available});

  final String plantId;
  final List<CareType> available;

  @override
  ConsumerState<_AddCareTypeSheet> createState() => _AddCareTypeSheetState();
}

class _AddCareTypeSheetState extends ConsumerState<_AddCareTypeSheet> {
  late CareType _type = widget.available.first;
  int _intervalDays = 7;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Add care type', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          DropdownButtonFormField<CareType>(
            initialValue: _type,
            decoration: const InputDecoration(
              labelText: 'Care type',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final t in widget.available)
                DropdownMenuItem(
                  value: t,
                  child: Row(
                    children: [
                      Icon(careTypeIcon(t), size: 20),
                      const SizedBox(width: 12),
                      Text(careVerb(t)),
                    ],
                  ),
                ),
            ],
            onChanged: (t) => setState(() => _type = t ?? _type),
          ),
          const SizedBox(height: 20),
          Text('Every', style: Theme.of(context).textTheme.titleSmall),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _intervalDays.toDouble(),
                  min: 1,
                  max: 90,
                  divisions: 89,
                  label: '$_intervalDays days',
                  onChanged: (v) => setState(() => _intervalDays = v.round()),
                ),
              ),
              SizedBox(
                width: 72,
                child: Text('$_intervalDays days', textAlign: TextAlign.end),
              ),
            ],
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Reminder time'),
            trailing: Text(_reminderTime.format(context)),
            onTap: _pickTime,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _reminderTime);
    if (picked != null) setState(() => _reminderTime = picked);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final tzId = (await FlutterTimezone.getLocalTimezone()).identifier;
    await ref.read(careRepositoryProvider).addSchedule(
          plantId: widget.plantId,
          type: _type,
          intervalDays: _intervalDays,
          timeOfDayMinutes: _reminderTime.hour * 60 + _reminderTime.minute,
          tzId: tzId,
        );
    await ref.read(reconcileCoordinatorProvider).reconcile();
    if (mounted) Navigator.of(context).pop();
  }
}
