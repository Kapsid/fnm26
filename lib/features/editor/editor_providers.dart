import 'dart:async';

import 'package:file_picker/file_picker.dart';
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
/// section is per nation.
String editorSectionLocation(
  EditorSection section,
  int packId, {
  int? nationId,
}) => Uri(
  path: section.route,
  queryParameters: {
    'id': '$packId',
    if (nationId != null) 'nation': '$nationId',
  },
).toString();

/// Asks the manager for a file to import and returns its path (null when
/// he picks nothing). A provider so a test can stand in a file.
final Provider<Future<String?> Function()> editorFilePickerProvider = Provider(
  (ref) =>
      () async => (await FilePicker.pickFiles())?.files.single.path,
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

  Future<void> _load(NationRepository nations) async {
    try {
      final world = await nations.newCareerWorld();
      final pack = await _packs.load(_id);
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

  /// Whether there is an edit to undo.
  bool get canUndo => _past.isNotEmpty;

  /// Applies [edit] to the pack and saves it shortly after.
  void update(WorldPack Function(WorldPack) edit) {
    final current = state.valueOrNull;
    if (current == null) return;
    final next = edit(current);
    if (identical(next, current)) return;
    _past.add(current);
    if (_past.length > undoDepth) _past.removeAt(0);
    _set(next);
  }

  /// Goes back to the pack as it was before the last [update].
  void undo() {
    if (_past.isEmpty) return;
    _set(_past.removeLast());
  }

  void _set(WorldPack pack) {
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
