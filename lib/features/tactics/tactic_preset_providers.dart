import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/domain/entities/tactic_preset.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The shared_preferences key holding one save's JSON array of tactic presets.
/// Presets live outside the save database (so adding them needs no schema bump)
/// but are scoped per-career, so one save's setups never leak into another.
String _presetsKey(int careerId) => 'tactic_presets_v2:$careerId';

/// Loads, saves and deletes a save's named tactic presets.
class TacticPresetStore {
  const TacticPresetStore(this._ref);

  final Ref _ref;

  Future<List<TacticPreset>> load(int careerId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_presetsKey(careerId));
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const [];
      final presets = <TacticPreset>[];
      for (final e in list) {
        if (e is! Map<String, dynamic>) continue;
        final p = TacticPreset.fromJson(e);
        if (p != null) presets.add(p);
      }
      return presets;
    } on FormatException {
      return const [];
    }
  }

  Future<void> _persist(int careerId, List<TacticPreset> presets) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _presetsKey(careerId),
      jsonEncode([for (final p in presets) p.toJson()]),
    );
    _ref.invalidate(tacticPresetsProvider(careerId));
  }

  /// Saves [preset] for [careerId], replacing any existing one with the same
  /// name (case insensitive) so re-saving a style updates it, not duplicates.
  Future<void> save(int careerId, TacticPreset preset) async {
    final presets = await load(careerId);
    final lower = preset.name.toLowerCase();
    final next = [
      for (final p in presets)
        if (p.name.toLowerCase() != lower) p,
      preset,
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    await _persist(careerId, next);
  }

  Future<void> delete(int careerId, String name) async {
    final presets = await load(careerId);
    final lower = name.toLowerCase();
    await _persist(careerId, [
      for (final p in presets)
        if (p.name.toLowerCase() != lower) p,
    ]);
  }
}

final Provider<TacticPresetStore> tacticPresetStoreProvider =
    Provider(TacticPresetStore.new);

/// The saved tactic presets for one save, alphabetically ordered.
final AutoDisposeFutureProviderFamily<List<TacticPreset>, int>
    tacticPresetsProvider =
    FutureProvider.autoDispose.family<List<TacticPreset>, int>(
        (ref, careerId) => ref.watch(tacticPresetStoreProvider).load(careerId));
