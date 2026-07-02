import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/domain/ports/species_catalog_port.dart';

/// Minimal "add a plant" flow for Phase 1: nickname + watering interval + reminder
/// time. Creates the plant and its water schedule, then triggers a reconcile so the
/// first reminder is scheduled immediately.
class AddPlantScreen extends ConsumerStatefulWidget {
  const AddPlantScreen({super.key});

  @override
  ConsumerState<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends ConsumerState<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  int _intervalDays = 7;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  bool _saving = false;

  /// Chosen catalog species (optional). Selecting one pre-fills the watering cadence and,
  /// if the species has a fertilize default, auto-adds a fertilize schedule on save.
  SpeciesSummary? _species;
  int? _fertilizeIntervalDays;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add plant')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: Icon(Icons.local_florist,
                    color: Theme.of(context).colorScheme.primary),
                title: Text(_species?.commonName ?? 'Choose a species (optional)'),
                subtitle: Text(_species?.scientificName ??
                    'Get smart watering & fertilizing defaults'),
                trailing: _species == null
                    ? const Icon(Icons.chevron_right)
                    : IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Clear species',
                        onPressed: () => setState(() {
                          _species = null;
                          _fertilizeIntervalDays = null;
                        }),
                      ),
                onTap: _pickSpecies,
              ),
            ),
            if (_fertilizeIntervalDays != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Will also remind you to fertilize every $_fertilizeIntervalDays days.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'Nickname',
                hintText: 'e.g. Monstera by the window',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Give your plant a name' : null,
            ),
            const SizedBox(height: 24),
            Text('Water every', style: Theme.of(context).textTheme.titleSmall),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _intervalDays.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
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
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Reminder time'),
              trailing: Text(_reminderTime.format(context)),
              onTap: _pickTime,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Add plant'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked =
        await showTimePicker(context: context, initialTime: _reminderTime);
    if (picked != null) setState(() => _reminderTime = picked);
  }

  Future<void> _pickSpecies() async {
    final picked = await showModalBottomSheet<SpeciesSummary>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _SpeciesPickerSheet(),
    );
    if (picked == null) return;

    // Pull the species' care defaults to pre-fill the cadence (and a fertilize schedule).
    final detail = await ref.read(speciesCatalogProvider).getById(picked.id);
    if (!mounted) return;
    setState(() {
      _species = picked;
      if (detail != null) {
        _intervalDays = detail.care.wateringIntervalDays.clamp(1, 30);
        _fertilizeIntervalDays = detail.care.fertilizeIntervalDays;
      }
      if (_nicknameController.text.trim().isEmpty) {
        _nicknameController.text = picked.commonName;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final tzId = (await FlutterTimezone.getLocalTimezone()).identifier;
    await ref.read(careRepositoryProvider).addPlant(
          nickname: _nicknameController.text.trim(),
          speciesId: _species?.id,
          wateringIntervalDays: _intervalDays,
          timeOfDayMinutes: _reminderTime.hour * 60 + _reminderTime.minute,
          tzId: tzId,
          fertilizeIntervalDays: _fertilizeIntervalDays,
        );
    await ref.read(reconcileCoordinatorProvider).reconcile();

    if (mounted) context.pop();
  }
}

/// Search-as-you-type species picker (over the local catalog). Pops the chosen
/// [SpeciesSummary], or null if dismissed.
class _SpeciesPickerSheet extends ConsumerStatefulWidget {
  const _SpeciesPickerSheet();

  @override
  ConsumerState<_SpeciesPickerSheet> createState() => _SpeciesPickerSheetState();
}

class _SpeciesPickerSheetState extends ConsumerState<_SpeciesPickerSheet> {
  final _controller = TextEditingController();
  List<SpeciesSummary> _results = const [];
  bool _loading = true;
  int _queryToken = 0; // guards against out-of-order async results

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final token = ++_queryToken;
    setState(() => _loading = true);
    final results = await ref.read(speciesCatalogProvider).search(query);
    // Ignore a slow response that a newer query has already superseded.
    if (!mounted || token != _queryToken) return;
    setState(() {
      _results = results;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Search species…',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _search,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 320,
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? const Center(child: Text('No matching species'))
                    : ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (_, i) {
                          final s = _results[i];
                          return ListTile(
                            title: Text(s.commonName),
                            subtitle: Text(s.scientificName),
                            onTap: () => Navigator.of(context).pop(s),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
