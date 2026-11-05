import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/diagnostics/app_log.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/nation_repository.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

/// Where a database stands, as the list of databases shows it.
enum PackStatus {
  /// Complete: it can start a career.
  ready,

  /// Saved and shareable, but [PackRules.issues] still lists things to fix.
  missing,

  /// A game update made it incompatible (it refers to something the game no
  /// longer has). Nothing produces this yet: the compatibility check that
  /// does arrives with the New Game world picker.
  needsAttention,

  /// The stored pack could not be read at all. Only deleting it is offered.
  unreadable,
}

/// One database as the editor list shows it.
typedef EditorPackEntry = ({
  int id,
  String name,
  DateTime updatedAt,
  PackStatus status,
  int missing,
});

/// The sections of a database, in the order its home shows them. Each has
/// its own route (see [route]); the section screens fill them in.
enum EditorSection {
  players(Routes.editorPlayers),
  nations(Routes.editorNations),
  clubs(Routes.editorClubs),
  stadiums(Routes.editorStadiums),
  competitions(Routes.editorCompetitions),
  yAccounts(Routes.editorY),
  press(Routes.editorPress),
  nameLists(Routes.editorNameLists),
  sponsors(Routes.editorSponsors),
  trophies(Routes.editorTrophies);

  const EditorSection(this.route);

  /// The route of this section's screen. Expects `?id=` (the pack), and for
  /// [players] and [nameLists] optionally `&nation=`.
  final String route;

  /// The section a [PackIssue.where] path belongs to.
  static EditorSection ofPath(String path) => switch (path.split('.').first) {
    'squads' => players,
    'nations' => nations,
    'clubs' => clubs,
    'stadiums' => stadiums,
    'competitions' => competitions,
    'yAccounts' => yAccounts,
    'reporters' => press,
    'nameLists' => nameLists,
    'sponsors' => sponsors,
    'trophies' => trophies,
    _ => players,
  };
}

/// The location of pack [packId]'s home.
String editorPackLocation(int packId) => '${Routes.editorPack}?id=$packId';

/// The location of [section] in pack [packId], opened on [nationId] when the
/// section is per nation. The players section opened on a nation is that
/// nation's squad ([editorSquadLocation]).
String editorSectionLocation(
  EditorSection section,
  int packId, {
  int? nationId,
}) => section == EditorSection.players && nationId != null
    ? editorSquadLocation(packId, nationId)
    : Uri(
        path: section.route,
        queryParameters: {
          'id': '$packId',
          if (nationId != null) 'nation': '$nationId',
        },
      ).toString();

/// The location of nation [nationId]'s squad in pack [packId].
String editorSquadLocation(int packId, int nationId) =>
    '${Routes.editorSquad}?id=$packId&nation=$nationId';

/// The location of player [playerId] of nation [nationId] in pack [packId].
String editorPlayerLocation(int packId, int nationId, int playerId) =>
    '${Routes.editorPlayer}?id=$packId&nation=$nationId&player=$playerId';

/// Asks the manager for a file and returns its path (null when he picks
/// nothing): any file, or only those ending in one of [extensions] (lower
/// case, no dot). A provider so a test can stand in a file.
typedef EditorFilePicker = Future<String?> Function({List<String>? extensions});

final Provider<EditorFilePicker> editorFilePickerProvider = Provider(
  (ref) =>
      ({extensions}) async => (await FilePicker.pickFiles(
        type: extensions == null ? FileType.any : FileType.custom,
        allowedExtensions: extensions,
      ))?.files.single.path,
);

/// The nations a database covers: the world a career created now starts in.
final AutoDisposeFutureProvider<List<Nation>> editorWorldProvider =
    FutureProvider.autoDispose<List<Nation>>(
      (ref) => ref.watch(nationRepositoryProvider).newCareerWorld(),
    );

/// Every database on the device with its status, by name. Reads (and
/// checks) every pack, so it is autoDispose: back on the list, it is read
/// again, after whatever the editor saved.
final AutoDisposeFutureProvider<List<EditorPackEntry>> editorPacksProvider =
    FutureProvider.autoDispose<List<EditorPackEntry>>((
      ref,
    ) async {
      final summaries = await ref.watch(worldPacksProvider.future);
      final world = await ref.watch(editorWorldProvider.future);
      final repo = ref.watch(worldPackRepositoryProvider);
      final codes = {for (final n in world) n.id: n.code};
      final out = <EditorPackEntry>[];
      for (final s in summaries) {
        WorldPack? pack;
        try {
          pack = await repo.load(s.id);
        } on FormatException {
          pack = null;
        }
        final issues = pack == null
            ? const <PackIssue>[]
            : PackRules.issues(pack, baseCodes: codes);
        out.add((
          id: s.id,
          name: s.name,
          updatedAt: s.updatedAt,
          status: pack == null
              ? PackStatus.unreadable
              : issues.isEmpty
              ? PackStatus.ready
              : PackStatus.missing,
          missing: issues.length,
        ));
      }
      return out;
    });

/// The database being edited, by pack id: edits save as they go
/// ([PackEditor.update]), and the last ones can be undone.
///
/// AutoDispose: when the last editor screen of a pack closes, pending edits
/// are written ([PackEditor.dispose]) and the pack is let go.
final AutoDisposeStateNotifierProviderFamily<
  PackEditor,
  AsyncValue<WorldPack>,
  int
>
packEditorProvider = StateNotifierProvider.autoDispose
    .family<PackEditor, AsyncValue<WorldPack>, int>((ref, id) {
      final container = ref.container;
      return PackEditor(
        id: id,
        packs: ref.watch(worldPackRepositoryProvider),
        nations: ref.watch(nationRepositoryProvider),
        // The list's dates and statuses follow the save. Through the
        // container, not this ref: the last save comes from dispose.
        onSaved: () {
          try {
            container.invalidate(worldPacksProvider);
          } on Object {
            // The app (or the test) is tearing the container down.
          }
        },
      );
    });

/// Holds one pack while it is edited.
///
/// Every [update] replaces the pack in memory at once and writes it to the
/// device [saveDelay] after the last change (and on [flush] or [dispose]),
/// so a run of quick edits is one write and nothing typed is lost. The
/// [undoDepth] states before the latest edits are kept for [undo].
///
/// Nothing here keeps a [Future] across calls: only resolved values. A
/// future remembers the zone it was made in, and one awaited from another
/// zone (a widget test's fake async) never completes.
class PackEditor extends StateNotifier<AsyncValue<WorldPack>> {
  PackEditor({
    required int id,
    required WorldPackRepository packs,
    required NationRepository nations,
    void Function()? onSaved,
  }) : _id = id,
       _packs = packs,
       _onSaved = onSaved ?? _noop,
       super(const AsyncValue.loading()) {
    // The app going to the background may be the last the manager does:
    // whatever waits for its save is written now, not 400 ms later.
    _lifecycle = AppLifecycleListener(
      onStateChange: (s) {
        if (s != AppLifecycleState.resumed) unawaited(flush());
      },
    );
    unawaited(_load(nations));
  }

  late final AppLifecycleListener _lifecycle;

  static const Duration saveDelay = Duration(milliseconds: 400);
  static const int undoDepth = 20;

  final int _id;
  final WorldPackRepository _packs;
  final void Function() _onSaved;

  static void _noop() {}

  final List<WorldPack> _past = [];
  Timer? _timer;

  /// The pack still to be written, if an edit is waiting for its save.
  WorldPack? _unsaved;

  List<Nation> _world = const [];
  Map<int, String> _baseCodes = const {};

  WorldPack? _issuesOf;
  List<PackIssue> _issues = const [];

  /// The pack's own trophy pictures, by key (see [setTrophy]).
  Map<String, Uint8List> _trophies = const {};

  Future<void> _load(NationRepository nations) async {
    try {
      final world = await nations.newCareerWorld();
      final pack = await _packs.load(_id);
      final trophies = pack == null
          ? const <String, Uint8List>{}
          : await _packs.trophies(_id);
      if (!mounted) return;
      if (pack == null) {
        state = AsyncValue.error(
          StateError('No world pack $_id'),
          StackTrace.current,
        );
        return;
      }
      _world = world;
      _baseCodes = {for (final n in world) n.id: n.code};
      _trophies = trophies;
      // The picture rows are what a career and an export take, so a pack
      // whose list of them drifted (one stored before they were kept in
      // step) is put right from the rows.
      final keys = trophies.keys.toSet();
      if (!setEquals(keys, pack.trophies)) {
        state = AsyncValue.data(pack.copyWith(trophies: keys));
        _unsaved = state.valueOrNull;
        _timer = Timer(saveDelay, () => unawaited(flush()));
        return;
      }
      state = AsyncValue.data(pack);
    } on Object catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
    }
  }

  /// The nations the pack covers, strongest first (empty until loaded).
  List<Nation> get world => _world;

  /// What stands between the pack and a career ([PackRules.issues]).
  List<PackIssue> get issues {
    final pack = state.valueOrNull;
    if (pack == null) return const [];
    if (!identical(pack, _issuesOf)) {
      _issues = PackRules.issues(pack, baseCodes: _baseCodes);
      _issuesOf = pack;
    }
    return _issues;
  }

  /// What stands between nation [nationId]'s squad and a career
  /// ([PackRules.squadIssues]); empty for a nation the pack has no squad for.
  ///
  /// Remembered per squad list: an edit replaces only the edited nation's
  /// list, so a keystroke rechecks one squad, not the whole pack.
  List<PackIssue> squadIssues(int nationId) {
    final squad = state.valueOrNull?.squads[nationId];
    if (squad == null) return const [];
    return _squadIssues[squad] ??= PackRules.squadIssues(nationId, squad);
  }

  final Expando<List<PackIssue>> _squadIssues = Expando('squadIssues');

  /// Trophy [key]'s own picture (a PNG at the trophy's size), or
  /// null while the game's is used.
  Uint8List? trophy(String key) => _trophies[key];

  /// Whether a [setTrophy] is being written.
  bool _writingTrophy = false;

  /// Gives trophy [key] the picture [png], or with null the game's again.
  /// Returns whether it was stored.
  ///
  /// The picture row and the pack's [WorldPack.trophies] are written in one
  /// transaction, and the pack in memory follows at once. Pictures are not
  /// edits: [undo] never brings one back or takes one away, so every state
  /// it could go back to is given the same change.
  Future<bool> setTrophy(String key, Uint8List? png) async {
    final current = state.valueOrNull;
    if (current == null || _writingTrophy) return false;
    WorldPack mark(WorldPack p) {
      final keys = {...p.trophies};
      png == null ? keys.remove(key) : keys.add(key);
      return p.copyWith(trophies: keys);
    }

    _writingTrophy = true;
    // The waiting edit goes out with the picture.
    _timer?.cancel();
    _timer = null;
    final waiting = _unsaved;
    _unsaved = null;
    try {
      await _packs.setTrophy(_id, key, png, pack: mark(current));
    } on Object catch (e, st) {
      AppLog.error('pack-editor-trophy', e, st);
      _writingTrophy = false;
      _unsaved ??= waiting;
      _resumeSaving();
      return false;
    }
    _writingTrophy = false;
    _trophies = {..._trophies};
    png == null ? _trophies.remove(key) : _trophies[key] = png;
    for (var i = 0; i < _past.length; i++) {
      _past[i] = mark(_past[i]);
    }
    final latest = state.valueOrNull;
    if (mounted && latest != null) {
      _revision++;
      state = AsyncValue.data(mark(latest));
    }
    // An edit made while the picture was written is written again with it.
    final pending = _unsaved;
    if (pending != null) _unsaved = mounted ? state.valueOrNull : mark(pending);
    _resumeSaving();
    _onSaved();
    return true;
  }

  /// After a [setTrophy]: a waiting edit is saved as usual, or at once if
  /// the editor closed meanwhile.
  void _resumeSaving() {
    if (_unsaved == null) return;
    if (mounted) {
      _timer = Timer(saveDelay, () => unawaited(flush()));
    } else {
      unawaited(flush());
    }
  }

  /// Whether there is an edit to undo.
  bool get canUndo => _past.isNotEmpty;

  /// Applies [edit] to the pack and saves it shortly after.
  ///
  /// A run of updates passing the same [group] (any object, compared by
  /// identity: one slider drag, one spell of typing in a field) is one undo
  /// step, so a drag across thirty values does not push the edits before it
  /// out of [undoDepth].
  void update(WorldPack Function(WorldPack) edit, {Object? group}) {
    final current = state.valueOrNull;
    if (current == null) return;
    final next = edit(current);
    if (identical(next, current)) return;
    final joins = group != null && identical(group, _group) && canUndo;
    if (!joins) {
      _past.add(current);
      if (_past.length > undoDepth) _past.removeAt(0);
    }
    _group = group;
    _set(next);
  }

  /// The group of the last [update], whose run the next one may join.
  Object? _group;

  /// Goes back to the pack as it was before the last [update] (before the
  /// whole run, for a grouped one).
  void undo() {
    if (_past.isEmpty) return;
    _group = null;
    _set(_past.removeLast());
  }

  /// Counts every change [update] or [undo] makes. An undo offered for one
  /// edit (a removal's snackbar) notes it right after that edit and passes
  /// it to [undoIfLatest], so it never undoes whatever came after.
  int get revision => _revision;
  int _revision = 0;

  /// [undo], but only while the last change is still the one made at
  /// [revision]; returns whether it undid.
  bool undoIfLatest(int revision) {
    if (revision != _revision || !canUndo) return false;
    undo();
    return true;
  }

  void _set(WorldPack pack) {
    _revision++;
    state = AsyncValue.data(pack);
    _unsaved = pack;
    _timer?.cancel();
    _timer = Timer(saveDelay, () => unawaited(flush()));
  }

  /// Writes a waiting edit now. A write that fails is logged and kept
  /// waiting, so the next edit (or flush) tries it again.
  Future<void> flush() async {
    _timer?.cancel();
    _timer = null;
    // A picture being written takes the waiting edit with it (setTrophy).
    if (_writingTrophy) return;
    final pack = _unsaved;
    if (pack == null) return;
    _unsaved = null;
    try {
      await _packs.save(_id, pack);
    } on Object catch (e, st) {
      AppLog.error('pack-editor-save', e, st);
      _unsaved ??= pack;
      return;
    }
    _onSaved();
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    unawaited(flush());
    super.dispose();
  }
}
