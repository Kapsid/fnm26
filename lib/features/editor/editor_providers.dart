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
import 'package:fnm/domain/services/world_pack/pack_codec.dart';
import 'package:fnm/domain/services/world_pack/pack_keys.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/pack_status.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/names/added_items.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';
import 'package:image_picker/image_picker.dart' hide XFile;
import 'package:share_plus/share_plus.dart';

export 'package:fnm/domain/services/world_pack/pack_status.dart';

/// One database as the editor list shows it.
typedef EditorPackEntry = ({
  int id,
  String name,
  DateTime updatedAt,
  PackStatus status,
  int missing,
});

/// The sections of a database, in the order its home shows them ([onHome]).
/// Each has its own route (see [route]); the section screens fill them in.
enum EditorSection {
  players(Routes.editorPlayers),
  clubs(Routes.editorClubs),
  stadiums(Routes.editorStadiums),
  competitions(Routes.editorCompetitions),
  yAccounts(Routes.editorY),
  press(Routes.editorPress),
  nameLists(Routes.editorNameLists),

  /// The managers in charge of the nations on day one (format 4).
  managers(Routes.editorManagers),
  sponsors(Routes.editorSponsors),
  trophies(Routes.editorTrophies),

  /// What no section edits any more: a nation's name and code. A database
  /// made before the Nations section went keeps its renames (they still
  /// apply), and one that now breaks a rule is listed on the home with a
  /// Remove ([PackEditor.removeNationRename]). No screen, no route.
  none('');

  const EditorSection(this.route);

  /// The route of this section's screen (empty for [none]). Expects `?id=`
  /// (the pack), and for [players], [nameLists] and [managers] optionally
  /// `&nation=`.
  final String route;

  /// The sections the home lists, in order: all but [none].
  static List<EditorSection> get onHome => [
    for (final s in values)
      if (s != none) s,
  ];

  /// Whether this section has a screen to open.
  bool get hasScreen => this != none;

  /// The section a [PackIssue.where] path belongs to. Added items sit with
  /// the game's own of their kind, a pool with the squads, and a `localized`
  /// entry with the text it translates. A root no section edits (a nation's
  /// old rename, the `localized` cap, anything a newer game writes) is
  /// [none]: the home, where it is listed, never a guessed section.
  static EditorSection ofPath(String path) => switch (path.split('.').first) {
    'squads' || 'pools' => players,
    'nations' => none,
    'clubs' || 'addedClubs' => clubs,
    'stadiums' => stadiums,
    'competitions' => competitions,
    'yAccounts' || 'addedYAccounts' || 'yHandles' => yAccounts,
    'reporters' => press,
    'nameLists' => nameLists,
    'managers' => managers,
    'sponsors' || 'addedSponsors' || 'sponsorIndustries' => sponsors,
    'trophies' => trophies,
    'localized' when path.contains('.') => ofPath(
      path.substring(path.indexOf('.') + 1),
    ),
    _ => none,
  };
}

/// The location of pack [packId]'s home.
String editorPackLocation(int packId) => '${Routes.editorPack}?id=$packId';

/// The location of [section] in pack [packId], opened on [nationId] when the
/// section is per nation. The players section opened on a nation is that
/// nation's squad ([editorSquadLocation]), on its Pool tab with [pool].
String editorSectionLocation(
  EditorSection section,
  int packId, {
  int? nationId,
  bool pool = false,
}) => section == EditorSection.players && nationId != null
    ? editorSquadLocation(packId, nationId, pool: pool)
    : Uri(
        path: section.route,
        queryParameters: {
          'id': '$packId',
          if (nationId != null) 'nation': '$nationId',
        },
      ).toString();

/// The location of nation [nationId]'s squad in pack [packId], on the Pool
/// tab with [pool].
String editorSquadLocation(int packId, int nationId, {bool pool = false}) =>
    '${Routes.editorSquad}?id=$packId&nation=$nationId'
    '${pool ? '&tab=pool' : ''}';

/// The location of player [playerId] of nation [nationId] in pack [packId]:
/// one of its pool with [pool], else of its squad.
String editorPlayerLocation(
  int packId,
  int nationId,
  int playerId, {
  bool pool = false,
}) =>
    '${Routes.editorPlayer}?id=$packId&nation=$nationId&player=$playerId'
    '${pool ? '&pool=1' : ''}';

/// One nation's pool in one pack.
typedef EditorPoolKey = ({int packId, int nationId});

/// Nation `nationId`'s pool as the game generates it for pack `packId`
/// ([WorldPackService.generatedPool]): what an untouched pool shows, and what
/// the first edit fixes. Read again only when the pack's name lists for the
/// nation change. The squad screen watches it on both tabs, fixed pool or
/// not, so fixing the pool (and undoing that, or going back to generated)
/// never reads it again while the screen is open.
final AutoDisposeFutureProviderFamily<List<PackPlayer>, EditorPoolKey>
editorGeneratedPoolProvider = FutureProvider.autoDispose
    .family<List<PackPlayer>, EditorPoolKey>((ref, key) {
      final names = ref.watch(
        packEditorProvider(key.packId).select(
          (s) => (
            loaded: s.hasValue,
            names: s.valueOrNull?.nameLists[key.nationId],
          ),
        ),
      );
      final pack = ref.read(packEditorProvider(key.packId)).valueOrNull;
      // Until the pack is read there is nothing to name the pool from; the
      // read itself rebuilds this.
      if (!names.loaded || pack == null) {
        return Completer<List<PackPlayer>>().future;
      }
      return ref
          .watch(worldPackServiceProvider)
          .generatedPool(key.nationId, pack);
    });

/// Nation `nationId`'s pool in pack `packId` as the Pool tab shows it: the
/// pack's own ([WorldPack.pools]) once fixed, else the generated one
/// ([editorGeneratedPoolProvider]).
final AutoDisposeFutureProviderFamily<List<PackPlayer>, EditorPoolKey>
editorPoolProvider = FutureProvider.autoDispose
    .family<List<PackPlayer>, EditorPoolKey>((ref, key) {
      final fixed = ref.watch(
        packEditorProvider(
          key.packId,
        ).select((s) => s.valueOrNull?.pools[key.nationId]),
      );
      if (fixed != null) return fixed;
      return ref.watch(editorGeneratedPoolProvider(key).future);
    });

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

/// Hands database [packId]'s file to the manager: the share sheet on a
/// device ([WorldPackService.export]), a download in the web editor. Throws
/// [PackTooBigToShare] for a file over the cap. A provider so the web editor
/// (and a test) can stand in its own way out.
typedef EditorPackExporter =
    Future<void> Function(int packId, {required String subject, Rect? origin});

final Provider<EditorPackExporter> editorPackExporterProvider = Provider(
  (ref) =>
      (packId, {required subject, origin}) async {
        final file = await ref.read(worldPackServiceProvider).export(packId);
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path, mimeType: PackCodec.mimeType)],
            subject: subject,
            sharePositionOrigin: origin,
          ),
        );
      },
);

/// Whether the editor's front page has a way back to the game's home
/// screen; false in the web editor, where the editor is all there is.
final Provider<bool> editorHasHomeProvider = Provider<bool>((ref) => true);

/// Picks one picture from the phone's photo gallery and gives its path, or
/// null when nothing was picked. A provider so a test can stand in a path.
typedef EditorGalleryPicker = Future<String?> Function();

final Provider<EditorGalleryPicker> editorGalleryPickerProvider = Provider(
  (ref) =>
      () async => (await ImagePicker().pickImage(
        source: ImageSource.gallery,
        // The framing screen works from the picture as it is: no recompress.
        requestFullMetadata: false,
      ))?.path,
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
      final facts = await ref.watch(packFactsProvider.future);
      final out = <EditorPackEntry>[];
      for (final s in summaries) {
        WorldPack? pack;
        try {
          pack = await repo.load(s.id);
        } on FormatException {
          pack = null;
        }
        final a = await assessPackAsync(pack, world, facts: facts);
        out.add((
          id: s.id,
          name: s.name,
          updatedAt: s.updatedAt,
          status: a.status,
          missing: a.issues.length,
        ));
      }
      return out;
    });

/// Counts the times an edit of a database has failed to save twice in a
/// row (see [PackEditor.flush]); `PackSaveFailureListener` says so.
final StateProvider<int> packSaveFailuresProvider = StateProvider<int>(
  (ref) => 0,
);

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
        facts: () => readPackFacts(
          ref.read(playerRepositoryProvider),
          ref.read(seedSourceProvider),
        ),
        // The list's dates and statuses follow the save. Through the
        // container, not this ref: the last save comes from dispose.
        onSaved: () {
          try {
            container.invalidate(worldPacksProvider);
          } on Object {
            // The app (or the test) is tearing the container down.
          }
        },
        onSaveFailed: () {
          try {
            container.read(packSaveFailuresProvider.notifier).state++;
          } on Object {
            // As above.
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
    required Future<PackFacts> Function() facts,
    void Function()? onSaved,
    void Function()? onSaveFailed,
  }) : _id = id,
       _packs = packs,
       _onSaved = onSaved ?? _noop,
       _onSaveFailed = onSaveFailed ?? _noop,
       super(const AsyncValue.loading()) {
    // The app going to the background may be the last the manager does:
    // whatever waits for its save is written now, not 400 ms later.
    _lifecycle = AppLifecycleListener(
      onStateChange: (s) {
        if (s != AppLifecycleState.resumed) unawaited(flush());
      },
    );
    unawaited(_load(nations, facts));
  }

  late final AppLifecycleListener _lifecycle;

  static const Duration saveDelay = Duration(milliseconds: 400);
  static const int undoDepth = 20;

  final int _id;
  final WorldPackRepository _packs;
  final void Function() _onSaved;

  /// Told when a save fails for the second time in a row.
  final void Function() _onSaveFailed;

  static void _noop() {}

  /// Saves that have failed in a row since the last one that went through.
  int _failedSaves = 0;

  /// How many times a closed editor tries a failing save before it gives up.
  static const int closedRetries = 3;

  final List<WorldPack> _past = [];
  Timer? _timer;

  /// The pack still to be written, if an edit is waiting for its save.
  WorldPack? _unsaved;

  List<Nation> _world = const [];
  Map<int, String> _baseCodes = const {};
  Map<String, List<String>> _countryCities = const {};
  PackGameKeys _gameKeys = PackGameKeys.of(
    const [],
    codes: const {},
    fringeRanges: const {},
  );

  WorldPack? _issuesOf;
  List<PackIssue> _issues = const [];

  /// The pack's own trophy pictures, by key (see [setTrophy]).
  Map<String, Uint8List> _trophies = const {};

  Future<void> _load(
    NationRepository nations,
    Future<PackFacts> Function() readFacts,
  ) async {
    try {
      final world = await nations.newCareerWorld();
      final facts = await readFacts();
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
      _gameKeys = PackGameKeys.of(
        [for (final n in world) n.id],
        codes: _baseCodes,
        fringeRanges: facts.fringeRanges,
      );
      _countryCities = packCountryCities(world, facts.cities);
      _trophies = trophies;
      // The first check of the pack, off the UI isolate when it is big (and
      // already made when the list of databases checked it): [issues] is
      // the same check, run in the build that first asks for it, which
      // froze opening a big pack.
      final checked = await assessPackAsync(pack, world, facts: facts);
      if (!mounted) return;
      _issuesOf = pack;
      _issues = [...checked.issues, ...PackRules.notAllowed(pack)];
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

  /// Each country's cities, biggest first, by lower-case FIFA code: what
  /// the game names a league-less country's clubs for (empty until loaded).
  Map<String, List<String>> get countryCities => _countryCities;

  /// What stands between the pack and a career: every [CompatIssue] (what
  /// the game no longer has, [PackRules.compatibility], and an added name
  /// the game's own already has, [NameClash]) first, then what is missing
  /// ([PackRules.issues]); and last every name the game does not show
  /// ([PackRules.notAllowed]), listed to fix but never blocking
  /// ([isBlocking]).
  List<PackIssue> get issues {
    final pack = state.valueOrNull;
    if (pack == null) return const [];
    if (!identical(pack, _issuesOf)) {
      _issues = [
        ...compatFirst(
          _gameKeys.check(pack),
          PackRules.issues(
            pack,
            baseCodes: _baseCodes,
            countryCities: _countryCities,
          ),
        ),
        ...PackRules.notAllowed(pack),
      ];
      _issuesOf = pack;
    }
    return _issues;
  }

  /// Whether the pack refers to something the game no longer has, or adds
  /// a name the game's own already has.
  bool get needsAttention => issues.any((i) => i is CompatIssue);

  WorldPack? _notesOf;
  List<UnknownLanguage> _notes = const [];

  /// What the pack keeps that this build does not use and that blocks
  /// nothing: its values in languages this build does not speak
  /// ([PackRules.unknownLanguages]). Listed on the pack home as notes.
  List<UnknownLanguage> get notes {
    final pack = state.valueOrNull;
    if (pack == null) return const [];
    if (!identical(pack, _notesOf)) {
      _notes = PackRules.unknownLanguages(pack);
      _notesOf = pack;
    }
    return _notes;
  }

  /// Removes every entry of [kind] ([kindsOf]) as ONE undoable edit:
  /// "Remove all like this". Returns whether something was removed.
  bool removeAllLike(String kind) {
    final before = _revision;
    update((p) => withoutKind(p, kind));
    return _revision != before;
  }

  /// Removes exactly the entry [issue] names, as one undoable edit (for a
  /// [NameClash], the added club or Y account, or the Y rename). A trophy
  /// goes with its picture ([setTrophy]), which, like every picture, undo
  /// does not bring back: a pack's list of trophies follows its picture
  /// rows, so the list entry alone would come back on the next open. Returns
  /// whether something was removed.
  Future<bool> removeUnknown(CompatIssue issue) async {
    final path = issue.path;
    final dot = path.indexOf('.');
    if (dot < 0) return false;
    if (path.substring(0, dot) == 'trophies') {
      return setTrophy(path.substring(dot + 1), null);
    }
    final before = _revision;
    update((p) => dropUnknown(p, path));
    return _revision != before;
  }

  /// Whether [issue] is about a nation's old rename ([EditorSection.none]):
  /// a code it shares with another nation ([DuplicateCode]), or a name or
  /// code that breaks a rule (a [BadField] at `nations.<id>...`). Its fix is
  /// [removeNationRename].
  static bool isNationIssue(PackIssue issue) =>
      issue is DuplicateCode ||
      (issue is BadField && issue.path.startsWith('nations.'));

  /// Drops the nation renames [issue] ([isNationIssue]) is about, as one
  /// undoable edit: for a shared code, every nation of it the pack renames.
  /// Returns whether something was removed.
  bool removeNationRename(PackIssue issue) {
    final before = _revision;
    update((p) => withoutNationRename(p, issue));
    return _revision != before;
  }

  /// [p] without the nation renames [issue] is about, or [p] itself
  /// (identical) when it is about none the pack has.
  static WorldPack withoutNationRename(WorldPack p, PackIssue issue) {
    final ids = switch (issue) {
      DuplicateCode(:final nationIds) => nationIds.toSet(),
      BadField(:final path) when path.startsWith('nations.') => {
        ?int.tryParse(path.split('.')[1]),
      },
      _ => const <int>{},
    };
    if (!ids.any(p.nations.containsKey)) return p;
    return p.copyWith(
      nations: {
        for (final e in p.nations.entries)
          if (!ids.contains(e.key)) e.key: e.value,
      },
    );
  }

  /// [p] without exactly the entry the [UnknownId] path [path] names, or
  /// [p] itself (identical) when it names nothing the pack has:
  ///
  /// - a nation's squad, nation entry, name list, day-one manager or pool, a
  ///   stadium, competition, Y account or sponsor rename;
  /// - a pool player (`pools.<n>.<id>`);
  /// - an added club, sponsor or Y account, with every `localized` name of
  ///   it (`addedClubs.<id>`, and for a sponsor its description's too), as
  ///   the editor deletes one ([AddedEdits]): a club's players go back to
  ///   Auto;
  /// - a `localized` path, or one language of it (`localized.<path>.<lang>`;
  ///   the path goes with its last language);
  /// - what this build does not know of an item, which goes while the item
  ///   stays: a player's unknown traits (`<squads|pools>.<n>.<id>.traits`),
  ///   a sponsor's unknown deal (`addedSponsors.<id>.deal`, leaving
  ///   [PackSponsor.fallbackDeal]) and a Y account's unknown voice
  ///   (`addedYAccounts.<id>.voice`, leaving [PackYAccount.fallbackVoice]).
  static WorldPack dropUnknown(WorldPack p, String path) {
    final dot = path.indexOf('.');
    if (dot < 0) return p;
    final root = path.substring(0, dot);
    final key = path.substring(dot + 1);
    final parts = key.split('.');
    int? at(int i) {
      if (parts.length <= i) return null;
      final n = int.tryParse(parts[i]);
      return n != null && '$n' == parts[i] ? n : null;
    }

    final id = parts.length == 1 ? at(0) : null;
    Map<K, V> without<K, V>(Map<K, V> m, K k) => {...m}..remove(k);

    // A player's unknown traits: `<squads|pools>.<n>.<id>.traits`.
    if ((root == 'squads' || root == 'pools') &&
        parts.length == 3 &&
        parts[2] == 'traits') {
      final players = root == 'pools' ? p.pools : p.squads;
      final n = at(0);
      final list = players[n];
      if (n == null || list == null) return p;
      if (!list.any((pl) => pl.id == at(1) && pl.unknownTraits.isNotEmpty)) {
        return p;
      }
      final next = {
        ...players,
        n: [
          for (final pl in list) pl.id == at(1) ? pl.withoutUnknown() : pl,
        ],
      };
      return root == 'pools'
          ? p.copyWith(pools: next)
          : p.copyWith(squads: next);
    }

    switch (root) {
      case 'pools':
        final n = at(0);
        if (n == null || !p.pools.containsKey(n)) return p;
        if (parts.length == 1) return p.copyWith(pools: without(p.pools, n));
        final playerId = at(1);
        if (parts.length != 2 || !p.pools[n]!.any((pl) => pl.id == playerId)) {
          return p;
        }
        return p.copyWith(
          pools: {
            ...p.pools,
            n: [
              for (final pl in p.pools[n]!)
                if (pl.id != playerId) pl,
            ],
          },
        );
      case 'addedClubs':
        // As the editor deletes one: its players go back to Auto.
        final itemId = at(0);
        if (parts.length != 1 || itemId == null) return p;
        return AddedEdits.removeClub(p, itemId);
      case 'addedSponsors':
        final itemId = at(0);
        final sponsor = p.addedSponsors.where((s) => s.id == itemId);
        if (sponsor.isEmpty) return p;
        if (parts.length == 2 && parts[1] == 'deal') {
          if (sponsor.first.unknownDeal == null) return p;
          return p.copyWith(
            addedSponsors: [
              for (final s in p.addedSponsors)
                s.id == itemId ? s.withoutUnknown() : s,
            ],
          );
        }
        if (parts.length != 1) return p;
        return AddedEdits.removeSponsor(p, itemId!);
      case 'addedYAccounts':
        final itemId = at(0);
        final account = p.addedYAccounts.where((y) => y.id == itemId);
        if (account.isEmpty) return p;
        if (parts.length == 2 && parts[1] == 'voice') {
          if (account.first.unknownVoice == null) return p;
          return p.copyWith(
            addedYAccounts: [
              for (final y in p.addedYAccounts)
                y.id == itemId ? y.withoutUnknown() : y,
            ],
          );
        }
        if (parts.length != 1) return p;
        return AddedEdits.removeY(p, itemId!);
      case 'localized':
        if (p.localized.containsKey(key)) {
          return p.copyWith(localized: without(p.localized, key));
        }
        // One language of a path: `<path>.<lang>`.
        final last = key.lastIndexOf('.');
        if (last < 0) return p;
        final entry = key.substring(0, last);
        final lang = key.substring(last + 1);
        final values = p.localized[entry];
        if (values == null || !values.containsKey(lang)) return p;
        final rest = without(values, lang);
        return p.copyWith(
          localized: rest.isEmpty
              ? without(p.localized, entry)
              : {...p.localized, entry: rest},
        );
      case 'squads' when id != null && p.squads.containsKey(id):
        return p.copyWith(squads: without(p.squads, id));
      case 'nations' when id != null && p.nations.containsKey(id):
        return p.copyWith(nations: without(p.nations, id));
      case 'nameLists' when id != null && p.nameLists.containsKey(id):
        return p.copyWith(nameLists: without(p.nameLists, id));
      case 'managers' when id != null && p.managers.containsKey(id):
        return p.copyWith(managers: without(p.managers, id));
      case 'stadiums' when p.stadiums.containsKey(key):
        return p.copyWith(stadiums: without(p.stadiums, key));
      case 'competitions' when p.competitions.containsKey(key):
        return p.copyWith(competitions: without(p.competitions, key));
      case 'yAccounts' when p.yAccounts.containsKey(key):
        return p.copyWith(yAccounts: without(p.yAccounts, key));
      case 'sponsors' when p.sponsors.containsKey(key):
        return p.copyWith(sponsors: without(p.sponsors, key));
      case 'yHandles' when p.yHandles.containsKey(key):
        return p.copyWith(yHandles: without(p.yHandles, key));
      case 'sponsorIndustries' when p.sponsorIndustries.containsKey(key):
        return p.copyWith(
          sponsorIndustries: without(p.sponsorIndustries, key),
        );
    }
    return p;
  }

  /// The kinds [issue] is one of: what it shares with other entries, so
  /// they can go together ("Remove all like this", [withoutKind]). An
  /// unknown language (`language:<code>`); each unknown trait a player's
  /// entry names (`trait:<name>`, most common first); a sponsor's unknown
  /// deal (`deal:<name>`) and a Y account's unknown voice (`voice:<name>`).
  /// Empty for anything else, which is one of a kind.
  static List<String> kindsOf(PackIssue issue, WorldPack p) {
    if (issue is UnknownLanguage) return ['language:${issue.language}'];
    if (issue is! UnknownId) return const [];
    final parts = issue.path.split('.');
    if (parts.length == 4 &&
        (parts[0] == 'squads' || parts[0] == 'pools') &&
        parts[3] == 'traits') {
      final players = parts[0] == 'pools' ? p.pools : p.squads;
      final id = int.tryParse(parts[2]);
      final names = [
        for (final pl
            in players[int.tryParse(parts[1])] ?? const <PackPlayer>[])
          if (pl.id == id) ...pl.unknownTraits,
      ].map((t) => 'trait:$t').toList();
      final counts = {for (final k in names) k: countOfKind(p, k)};
      return names..sort((a, b) => counts[b]!.compareTo(counts[a]!));
    }
    if (parts.length == 3 && parts[2] == 'deal') {
      final s = p.addedSponsors.where((s) => '${s.id}' == parts[1]);
      if (s.firstOrNull?.unknownDeal case final d?) return ['deal:$d'];
    }
    if (parts.length == 3 && parts[2] == 'voice') {
      final y = p.addedYAccounts.where((y) => '${y.id}' == parts[1]);
      if (y.firstOrNull?.unknownVoice case final v?) return ['voice:$v'];
    }
    return const [];
  }

  /// How many entries of [p] are of [kind] ([kindsOf]): values for a
  /// language, players for a trait, sponsors for a deal, accounts for a
  /// voice.
  static int countOfKind(WorldPack p, String kind) {
    final colon = kind.indexOf(':');
    if (colon < 0) return 0;
    final name = kind.substring(colon + 1);
    return switch (kind.substring(0, colon)) {
      'language' => p.localized.values.where((m) => m.containsKey(name)).length,
      'trait' => [
        ...p.squads.values,
        ...p.pools.values,
      ].expand((l) => l).where((pl) => pl.unknownTraits.contains(name)).length,
      'deal' => p.addedSponsors.where((s) => s.unknownDeal == name).length,
      'voice' => p.addedYAccounts.where((y) => y.unknownVoice == name).length,
      _ => 0,
    };
  }

  /// [p] without every entry of [kind] ([kindsOf]), or [p] itself
  /// (identical) when it has none: the language's values (a path goes with
  /// its last one), the trait from every player (his other traits stay),
  /// the deal or voice from every item (each keeps its fallback).
  static WorldPack withoutKind(WorldPack p, String kind) {
    if (countOfKind(p, kind) == 0) return p;
    final colon = kind.indexOf(':');
    final name = kind.substring(colon + 1);
    switch (kind.substring(0, colon)) {
      case 'language':
        return p.copyWith(
          localized: {
            for (final e in p.localized.entries)
              if (!(e.value.length == 1 && e.value.containsKey(name)))
                e.key: {...e.value}..remove(name),
          },
        );
      case 'trait':
        PackPlayer drop(PackPlayer pl) => !pl.unknownTraits.contains(name)
            ? pl
            : PackPlayer(
                id: pl.id,
                name: pl.name,
                age: pl.age,
                position: pl.position,
                attributes: pl.attributes,
                potential: pl.potential,
                club: pl.club,
                clubCountry: pl.clubCountry,
                traits: pl.traits,
                unknownTraits: [
                  for (final t in pl.unknownTraits)
                    if (t != name) t,
                ],
              );
        Map<int, List<PackPlayer>> each(Map<int, List<PackPlayer>> m) => {
          for (final e in m.entries)
            e.key: [for (final pl in e.value) drop(pl)],
        };
        return p.copyWith(squads: each(p.squads), pools: each(p.pools));
      case 'deal':
        return p.copyWith(
          addedSponsors: [
            for (final s in p.addedSponsors)
              s.unknownDeal == name ? s.withoutUnknown() : s,
          ],
        );
      case 'voice':
        return p.copyWith(
          addedYAccounts: [
            for (final y in p.addedYAccounts)
              y.unknownVoice == name ? y.withoutUnknown() : y,
          ],
        );
    }
    return p;
  }

  /// What stands between nation [nationId]'s squad and a career
  /// ([PackRules.squadIssues]), then its names the game does not show
  /// ([PackRules.notAllowedPlayers]); empty for a nation the pack has no
  /// squad for.
  ///
  /// Remembered per squad list: an edit replaces only the edited nation's
  /// list, so a keystroke rechecks one squad, not the whole pack.
  List<PackIssue> squadIssues(int nationId) {
    final squad = state.valueOrNull?.squads[nationId];
    if (squad == null) return const [];
    return _squadIssues[squad] ??= [
      ...PackRules.squadIssues(nationId, squad),
      ...PackRules.notAllowedPlayers('squads.$nationId', squad),
    ];
  }

  final Expando<List<PackIssue>> _squadIssues = Expando('squadIssues');

  /// What stands between nation [nationId]'s fixed pool and a career
  /// ([PackRules.poolIssues]), remembered per pool list as [squadIssues] is;
  /// empty for a pool the pack leaves to the game.
  List<PackIssue> poolIssues(int nationId) {
    final pool = state.valueOrNull?.pools[nationId];
    if (pool == null) return const [];
    return _poolIssues[pool] ??= [
      ...PackRules.poolIssues(nationId, pool),
      ...PackRules.notAllowedPlayers('pools.$nationId', pool),
    ];
  }

  final Expando<List<PackIssue>> _poolIssues = Expando('poolIssues');

  /// How many things stand between nation [nationId] and a career: its
  /// squad's ([squadIssues]) and its fixed pool's ([poolIssues]). The pack
  /// home counts both under Players, so the nation list must too: counting
  /// the squad alone showed "Squad ready" on a nation whose Pool tab, and
  /// the home, still had something to fix.
  int nationToFix(int nationId) =>
      squadIssues(nationId).length + poolIssues(nationId).length;

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

  /// Writes a waiting edit now. A write that fails is logged, kept waiting
  /// and tried again after a pause that grows with each failure (a closed
  /// editor tries [closedRetries] times); the second failure in a row is
  /// told to `PackSaveFailureListener`, which says so.
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
      _failedSaves++;
      if (_failedSaves == 2) _onSaveFailed();
      // An edit made meanwhile has armed its own save, which takes this
      // one with it.
      if (_timer == null && (mounted || _failedSaves <= closedRetries)) {
        _timer = Timer(
          saveDelay * _failedSaves.clamp(1, 10),
          () => unawaited(flush()),
        );
      }
      return;
    }
    _failedSaves = 0;
    _onSaved();
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    unawaited(flush());
    super.dispose();
  }
}
