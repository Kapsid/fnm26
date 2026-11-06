import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/config/languages.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/core/util/sponsor_label.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/national_stadium_data.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/domain/services/world_pack/pack_keys.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/players/players_ui.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The editor sections that rename what the game names: each a list of
/// (game name, the database's name) rows. Nations are not among them: their
/// names and codes are no longer edited (a database's old renames still
/// apply).
enum NameSection {
  clubs(EditorSection.clubs),
  stadiums(EditorSection.stadiums),
  competitions(EditorSection.competitions),
  yAccounts(EditorSection.yAccounts),
  press(EditorSection.press),
  nameLists(EditorSection.nameLists),
  sponsors(EditorSection.sponsors);

  const NameSection(this.editorSection);

  /// The section of the database home this is.
  final EditorSection editorSection;

  /// The name section [s] is, if it is one.
  static NameSection? of(EditorSection s) =>
      values.firstWhereOrNull((n) => n.editorSection == s);

  /// The first part of this section's [PackIssue.where] paths.
  String get issueRoot => switch (this) {
    clubs => 'clubs',
    stadiums => 'stadiums',
    competitions => 'competitions',
    yAccounts => 'yAccounts',
    press => 'reporters',
    nameLists => 'nameLists',
    sponsors => 'sponsors',
  };

  /// The longest name this section takes, in characters.
  int get maxLength =>
      this == yAccounts ? PackRules.handleMax : PackRules.nameMax;

  /// Whether the game translates these names, so a custom one (the same in
  /// every language) is worth a word.
  bool get translated => this == competitions || this == sponsors;

  /// Whether a row has a second field: a reporter's outlet.
  bool get paired => this == press;

  /// Whether its names can differ per language (the editor's language
  /// picker): every section but the name lists.
  bool get perLanguage => this != nameLists;

  /// Whether its rows are grouped under their country.
  bool get grouped => this == clubs || this == stadiums;

  /// The root of the items a database adds to this section (`addedClubs`,
  /// `addedSponsors`, `addedYAccounts`), or null where nothing is added.
  String? get addedRoot => switch (this) {
    clubs => 'addedClubs',
    sponsors => 'addedSponsors',
    yAccounts => 'addedYAccounts',
    _ => null,
  };

  /// Whether a database can add items of its own here.
  bool get adds => addedRoot != null;

  /// The row key of added item [id]: its `localized` path.
  String addedKey(int id) => '$addedRoot.$id';
}

/// One thing a name section renames, as the game has it.
@immutable
class NameEntry {
  const NameEntry({
    required this.key,
    required this.original,
    required this.fold,
    this.original2 = '',
    this.detail,
    this.nationId,
    this.flagCode,
    this.firstNames = const [],
    this.surnames = const [],
    this.addedId,
  });

  /// The id of the item the database adds that this row is (its name is
  /// [original]; a sponsor's description is [original2]), or null for one
  /// of the game's.
  final int? addedId;

  /// Whether this row is an item the database adds.
  bool get added => addedId != null;

  /// Its key in the pack's override map (a nation or reporter id as text).
  final String key;

  /// The game's name for it, in the manager's language.
  final String original;

  /// The game's second value: a reporter's outlet.
  final String original2;

  /// A line about it under the name (a stadium's city).
  final String? detail;

  /// The nation it is (name lists) or belongs to (clubs, stadiums).
  final int? nationId;

  /// The flag to show beside it.
  final String? flagCode;

  /// The game's name lists (name lists only): the whole pool its new
  /// players are named from ([namePoolOf]).
  final List<String> firstNames;
  final List<String> surnames;

  /// Everything the search matches before any rename, folded.
  final String fold;
}

/// A run of rows under one heading (a country), or under none.
typedef NameGroup = ({
  String? title,
  String? flagCode,
  List<NameEntry> entries,
});

/// What a pack says of an entry: its name and second value, when it
/// overrides them.
typedef NameOverride = ({String name, String second});

/// Each nation's game name lists, by nation id: what the Name lists section
/// starts from, as [namePoolOf] pools them.
final AutoDisposeFutureProvider<Map<int, NameLists>> editorNameListsProvider =
    FutureProvider.autoDispose<Map<int, NameLists>>(
      (ref) => ref.watch(seedSourceProvider).nameLists(),
    );

/// [body] run with the default world on show, so the display helpers print
/// the game's own names (what a custom one replaces).
T _inDefaultWorld<T>(T Function() body) {
  final saved = ActiveWorld.current;
  ActiveWorld.current = ActiveWorld.none;
  try {
    return body();
  } finally {
    ActiveWorld.current = saved;
  }
}

/// Every row of [section], grouped, in the manager's language [l]: [world]
/// the nations a career starts with, [lists] the game's name lists.
List<NameGroup> nameGroups(
  NameSection section,
  AppLocalizations l,
  List<Nation> world, {
  Map<int, NameLists> lists = const {},
}) {
  final nations = [...world]
    ..sort((a, b) => searchFold(a.name).compareTo(searchFold(b.name)));
  String fold(Iterable<String?> parts) =>
      parts.whereType<String>().map(searchFold).join(' ');
  List<NameGroup> one(List<NameEntry> entries) => [
    (title: null, flagCode: null, entries: entries),
  ];
  List<NameEntry> sorted(List<NameEntry> entries) =>
      entries..sort((a, b) => a.fold.compareTo(b.fold));

  switch (section) {
    case NameSection.nameLists:
      final pools = {
        for (final e in lists.entries) e.key: namePoolOf(e.value),
      };
      return one([
        for (final n in nations)
          NameEntry(
            key: '${n.id}',
            original: n.name,
            nationId: n.id,
            flagCode: n.code,
            firstNames: pools[n.id]?.first ?? const [],
            surnames: pools[n.id]?.sur ?? const [],
            fold: fold([n.name, n.englishName, n.code]),
          ),
      ]);
    case NameSection.clubs:
      return [
        for (final n in nations)
          if (ClubService.leagueClubs(n.code) case final clubs
              when clubs.isNotEmpty)
            (
              title: n.name,
              flagCode: n.code,
              entries: [
                for (final club in clubs)
                  NameEntry(
                    key: club,
                    original: club,
                    nationId: n.id,
                    fold: fold([club, n.name, n.englishName]),
                  ),
              ],
            ),
      ];
    case NameSection.stadiums:
      return [
        for (final n in nations)
          if (nationalStadiumData[n.id] case final grounds?
              when grounds.isNotEmpty)
            (
              title: n.name,
              flagCode: n.code,
              entries: [
                // Only a city's first ground can be renamed.
                for (final city in {for (final g in grounds) g.$1})
                  _stadium(l, n, city, fold),
              ],
            ),
      ];
    case NameSection.competitions:
      // Each stored name with the continent it belongs to: in some
      // languages two Nations Cups read the same. The same names, in the
      // same order, as `packCompetitionNames`.
      final stored = <(String, Confederation?)>[
        (kPackWorldCompetitions.first, null),
        for (final e in ContinentalCups.byConfederation.entries)
          (e.value.name, e.key),
        for (var i = 0; i < NationsCups.allNames.length; i++)
          (NationsCups.allNames[i], NationsCups.confederations[i]),
        for (final s in kPackWorldCompetitions.skip(1)) (s, null),
      ];
      return one(
        _inDefaultWorld(
          () => [
            for (final (s, conf) in stored)
              NameEntry(
                key: s,
                original: competitionLabel(l, s),
                detail: conf == null ? null : confederationLabel(l, conf),
                fold: fold([
                  competitionLabel(l, s),
                  s,
                  if (conf != null) confederationLabel(l, conf),
                ]),
              ),
          ],
        ),
      );
    case NameSection.yAccounts:
      return one(
        sorted([
          for (final name in YFeed.namedAccounts)
            NameEntry(key: name, original: name, fold: fold([name])),
        ]),
      );
    case NameSection.press:
      return one([
        for (final r in Press.reporters)
          NameEntry(
            key: '${r.index}',
            original: r.name,
            original2: r.outlet,
            fold: fold([r.name, r.outlet]),
          ),
      ]);
    case NameSection.sponsors:
      return one(
        sorted(
          _inDefaultWorld(
            () => [
              for (final b in SponsorBrand.values)
                NameEntry(
                  key: b.name,
                  original: sponsorBrandName(l, b),
                  fold: fold([sponsorBrandName(l, b), b.name]),
                ),
            ],
          ),
        ),
      );
  }
}

NameEntry _stadium(
  AppLocalizations l,
  Nation n,
  String city,
  String Function(Iterable<String?>) fold,
) {
  final name = VenueGenerator.gameGroundName(n.id, city);
  return NameEntry(
    key: '${n.id}:$city',
    original: name,
    detail: l.editorNamesMainStadium(city),
    nationId: n.id,
    fold: fold([name, city, n.name, n.englishName]),
  );
}

/// What [pack] overrides of [e] in [section], or null when it keeps the
/// game's (name lists: see [NameEdits.listsOf]).
NameOverride? nameOverride(NameSection section, WorldPack pack, NameEntry e) {
  // An added item's name is its own: nothing of the game's to override.
  if (e.added) return null;
  switch (section) {
    case NameSection.press:
      final r = pack.reporters[int.tryParse(e.key)];
      return r == null ? null : (name: r.name, second: r.outlet);
    case NameSection.nameLists:
      return null;
    case NameSection.clubs ||
        NameSection.stadiums ||
        NameSection.competitions ||
        NameSection.yAccounts ||
        NameSection.sponsors:
      final v = NameEdits._map(section, pack)[e.key];
      return v == null ? null : (name: v, second: '');
  }
}

/// The edits a name section makes. A value left blank or typed back to the
/// game's is no override at all: it is removed, never stored.
abstract final class NameEdits {
  static Map<String, String> _map(NameSection s, WorldPack p) => switch (s) {
    NameSection.clubs => p.clubs,
    NameSection.stadiums => p.stadiums,
    NameSection.competitions => p.competitions,
    NameSection.yAccounts => p.yAccounts,
    NameSection.sponsors => p.sponsors,
    _ => throw ArgumentError('$s is not a plain rename'),
  };

  static WorldPack _withMap(
    NameSection s,
    WorldPack p,
    Map<String, String> m,
  ) => switch (s) {
    NameSection.clubs => p.copyWith(clubs: m),
    NameSection.stadiums => p.copyWith(stadiums: m),
    NameSection.competitions => p.copyWith(competitions: m),
    NameSection.yAccounts => p.copyWith(yAccounts: m),
    NameSection.sponsors => p.copyWith(sponsors: m),
    _ => throw ArgumentError('$s is not a plain rename'),
  };

  /// [pack] with [e] named [name] (and [second], for a reporter's outlet):
  /// its main name, shown in every language that has none of its own. A
  /// blank field keeps the game's value; when both come out as the game's,
  /// the override goes (its per-language names stay: see [reset]).
  static WorldPack rename(
    NameSection section,
    WorldPack pack,
    NameEntry e,
    String name, [
    String second = '',
  ]) {
    final n = name.trim();
    final s = second.trim();
    final newName = n.isEmpty ? e.original : n;
    final newSecond = s.isEmpty ? e.original2 : s;
    final same = newName == e.original && newSecond == e.original2;
    switch (section) {
      case NameSection.press:
        final id = int.parse(e.key);
        return pack.copyWith(
          reporters: {
            for (final x in pack.reporters.entries)
              if (x.key != id) x.key: x.value,
            if (!same) id: PackReporter(name: newName, outlet: newSecond),
          },
        );
      case NameSection.nameLists:
        throw ArgumentError('name lists are set with withLists');
      case NameSection.clubs ||
          NameSection.stadiums ||
          NameSection.competitions ||
          NameSection.yAccounts ||
          NameSection.sponsors:
        return _withMap(section, pack, {
          for (final x in _map(section, pack).entries)
            if (x.key != e.key) x.key: x.value,
          if (!same) e.key: newName,
        });
    }
  }

  /// [pack] with nothing of [e] overridden: its main name and every
  /// language's own ("Reset" under All languages).
  static WorldPack reset(NameSection section, WorldPack pack, NameEntry e) {
    if (section == NameSection.nameLists) {
      return withLists(pack, e, const [], const []);
    }
    final main = rename(section, pack, e, '');
    final paths = pathsOf(section, e);
    if (!paths.any(main.localized.containsKey)) return main;
    return main.copyWith(
      localized: {
        for (final x in main.localized.entries)
          if (!paths.contains(x.key)) x.key: x.value,
      },
    );
  }

  /// The `localized` paths of [e] in [section]: its name's, and a
  /// reporter's outlet's (an added sponsor's description's). None for the
  /// name lists.
  static List<String> pathsOf(NameSection section, NameEntry e) =>
      switch (e.addedId) {
        final id? => switch (section) {
          NameSection.clubs => [PackPaths.addedClub(id)],
          NameSection.sponsors => [
            PackPaths.addedSponsor(id),
            PackPaths.addedSponsorDescription(id),
          ],
          NameSection.yAccounts => [PackPaths.addedY(id)],
          _ => throw ArgumentError('$section adds nothing'),
        },
        null => _gamePathsOf(section, e),
      };

  static List<String> _gamePathsOf(NameSection section, NameEntry e) =>
      switch (section) {
        NameSection.clubs => [PackPaths.club(e.key)],
        NameSection.stadiums => [PackPaths.stadium(e.key)],
        NameSection.competitions => [PackPaths.competition(e.key)],
        NameSection.yAccounts => [PackPaths.yAccount(e.key)],
        NameSection.sponsors => [PackPaths.sponsor(e.key)],
        NameSection.press => [
          PackPaths.reporterName(int.parse(e.key)),
          PackPaths.reporterOutlet(int.parse(e.key)),
        ],
        NameSection.nameLists => const [],
      };

  /// [pack] with [e]'s own name in language [lang] set to [value] (and a
  /// reporter's outlet to [second]). A value left blank, or typed as what
  /// the row shows without one (the main name, else the game's in [lang]),
  /// is no value: it is removed, and a path left with no language goes
  /// with it (an empty one is refused). Past [PackRules.localizedMax] in
  /// all, nothing new is added.
  static WorldPack renameIn(
    NameSection section,
    WorldPack pack,
    NameEntry e,
    String lang,
    String value, [
    String second = '',
  ]) {
    final localized = _localizedIn(section, pack, e, lang, value, second);
    if (_overflows(pack.localized, localized)) return pack;
    return const DeepCollectionEquality().equals(localized, pack.localized)
        ? pack
        : pack.copyWith(localized: localized);
  }

  /// Whether [renameIn] with these values is refused because it would add
  /// a value past [PackRules.localizedMax] in all.
  static bool overflowsIn(
    NameSection section,
    WorldPack pack,
    NameEntry e,
    String lang,
    String value, [
    String second = '',
  ]) => _overflows(
    pack.localized,
    _localizedIn(section, pack, e, lang, value, second),
  );

  static bool _overflows(
    Map<String, Map<String, String>> before,
    Map<String, Map<String, String>> after,
  ) =>
      localizedCount(after) > PackRules.localizedMax &&
      localizedCount(after) > localizedCount(before);

  /// [pack]'s `localized` as [renameIn] leaves it, cap aside.
  static Map<String, Map<String, String>> _localizedIn(
    NameSection section,
    WorldPack pack,
    NameEntry e,
    String lang,
    String value,
    String second,
  ) {
    final paths = pathsOf(section, e);
    if (paths.isEmpty) throw ArgumentError('$section has no languages');
    final v = valueIn(section, pack, e, lang);
    var localized = pack.localized;
    void put(String path, String typed, LanguageValue now) {
      final t = typed.trim();
      final values = {...?localized[path]};
      if (t.isEmpty || t == (now.main ?? now.game)) {
        values.remove(lang);
      } else {
        values[lang] = t;
      }
      localized = {
        for (final x in localized.entries)
          if (x.key != path) x.key: x.value,
        if (values.isNotEmpty) path: values,
      };
    }

    put(paths.first, value, v.name);
    if (v.second case final s?) put(paths[1], second, s);
    return localized;
  }

  /// [pack] without [e]'s own names in language [lang] ("Use the main
  /// name"); a path left with no language goes.
  static WorldPack resetIn(
    NameSection section,
    WorldPack pack,
    NameEntry e,
    String lang,
  ) {
    final paths = pathsOf(section, e);
    if (!paths.any((p) => pack.localized[p]?.containsKey(lang) ?? false)) {
      return pack;
    }
    return pack.copyWith(
      localized: {
        for (final x in pack.localized.entries)
          if (!paths.contains(x.key))
            x.key: x.value
          else if (({...x.value}..remove(lang)) case final rest
              when rest.isNotEmpty)
            x.key: rest,
      },
    );
  }

  /// How many (path, language) values [localized] holds.
  static int localizedCount(Map<String, Map<String, String>> localized) =>
      localized.values.fold(0, (n, m) => n + m.length);

  /// The names in [text]: split on commas and new lines, trimmed, blanks
  /// dropped.
  static List<String> parseNames(String text) => [
    for (final s in text.split(RegExp(r'[,\n]')))
      if (s.trim().isNotEmpty) s.trim(),
  ];

  /// The name lists [pack] gives nation [e] (its own, else the game's).
  static ({List<String> first, List<String> sur}) listsOf(
    WorldPack pack,
    NameEntry e,
  ) => switch (pack.nameLists[int.parse(e.key)]) {
    final l? => (first: l.first, sur: l.sur),
    null => (first: e.firstNames, sur: e.surnames),
  };

  /// [pack] with nation [e]'s name lists set to [first] and [sur]. Both
  /// empty, or both the game's, is no override. A list under the minimum
  /// is kept (the pack then lists it as missing).
  static WorldPack withLists(
    WorldPack pack,
    NameEntry e,
    List<String> first,
    List<String> sur,
  ) {
    const eq = ListEquality<String>();
    final id = int.parse(e.key);
    final none =
        (first.isEmpty && sur.isEmpty) ||
        (eq.equals(first, e.firstNames) && eq.equals(sur, e.surnames));
    return pack.copyWith(
      nameLists: {
        for (final x in pack.nameLists.entries)
          if (x.key != id) x.key: x.value,
        if (!none) id: PackNameLists(first: first, sur: sur),
      },
    );
  }
}

/// What a row shows for one text in one language: its own value there
/// ([own]), else the database's main one ([main]), else the game's in that
/// language ([game]).
typedef LanguageValue = ({String? own, String? main, String game});

/// What [v] shows.
String shownOf(LanguageValue v) => v.own ?? v.main ?? v.game;

/// The game's own name for [e] of [section] in language [lang]: the
/// translated sections (competitions, sponsors) say it in [lang]; every
/// other name is the same in every language.
String gameNameIn(NameSection section, NameEntry e, String lang) {
  if (!section.translated || e.added) return e.original;
  final l = lookupAppLocalizations(Locale(lang));
  return _inDefaultWorld(
    () => switch (section) {
      NameSection.competitions => competitionLabel(l, e.key),
      NameSection.sponsors => switch (SponsorBrand.values.asNameMap()[e.key]) {
        final b? => sponsorBrandName(l, b),
        null => e.original,
      },
      _ => e.original,
    },
  );
}

/// What [pack] gives [e] of [section] in language [lang]: its name, and a
/// reporter's outlet or an added sponsor's description ([second], null for
/// every other row). An added item's [LanguageValue.game] is its own main
/// value.
({LanguageValue name, LanguageValue? second}) valueIn(
  NameSection section,
  WorldPack pack,
  NameEntry e,
  String lang,
) {
  final paths = NameEdits.pathsOf(section, e);
  String? own(int i) => ActiveWorld.textOrNull(pack.localized[paths[i]]?[lang]);
  final main = nameOverride(section, pack, e);
  return (
    name: (
      own: own(0),
      main: ActiveWorld.textOrNull(main?.name),
      game: gameNameIn(section, e, lang),
    ),
    second: paths.length > 1
        ? (
            own: own(1),
            main: ActiveWorld.textOrNull(main?.second),
            game: e.original2,
          )
        : null,
  );
}

/// The languages [pack] gives [e] of [section] a name (or outlet) of its
/// own in, in [supportedLanguageCodes] order.
List<String> languagesOf(NameSection section, WorldPack pack, NameEntry e) {
  final codes = {
    for (final path in NameEdits.pathsOf(section, e))
      ...?pack.localized[path]?.keys,
  };
  return [
    for (final c in supportedLanguageCodes)
      if (codes.contains(c)) c,
  ];
}

/// The row key a `localized` [path] of [section] belongs to, or null when
/// it is another section's: an added item's is [NameSection.addedKey].
String? _localizedKey(NameSection section, String path) {
  final parsed = PackPaths.parse(path);
  if (parsed == null) return null;
  if (parsed.root == section.addedRoot) {
    return '${parsed.root}.${parsed.rest.split('.').first}';
  }
  if (parsed.root != section.issueRoot) return null;
  return section == NameSection.press
      ? parsed.rest.split('.').first
      : parsed.rest;
}

/// How many problems [issues] (of a whole pack) count against each row key
/// of [section]: its main name's, and its per-language names'
/// (`localized.<path>` and `localized.<path>.<language>`, told apart by
/// [pack]'s paths).
Map<String, int> issuesByKey(
  NameSection section,
  List<PackIssue> issues, {
  WorldPack? pack,
}) {
  final out = <String, int>{};
  void add(String key) => out.update(key, (n) => n + 1, ifAbsent: () => 1);
  final root = section.issueRoot;
  for (final issue in issues) {
    final path = issue.where;
    if (path.startsWith('localized.')) {
      var entry = path.substring('localized.'.length);
      // `<path>.<language>`: a club name may hold a dot, so the pack says
      // which paths there are.
      final last = entry.lastIndexOf('.');
      if (!(pack?.localized.containsKey(entry) ?? false) &&
          last > 0 &&
          PackRules.languageShape.hasMatch(entry.substring(last + 1))) {
        entry = entry.substring(0, last);
      }
      if (_localizedKey(section, entry) case final key?) add(key);
      continue;
    }
    // An added item's own: `<addedRoot>.<id>[.<field>]`.
    if (section.addedRoot case final added? when path.startsWith('$added.')) {
      add('$added.${path.substring(added.length + 1).split('.').first}');
      continue;
    }
    if (!path.startsWith('$root.')) continue;
    final rest = path.substring(root.length + 1);
    switch (section) {
      case NameSection.press || NameSection.nameLists:
        add(rest.split('.').first);
      case NameSection.clubs ||
          NameSection.stadiums ||
          NameSection.competitions ||
          NameSection.yAccounts ||
          NameSection.sponsors:
        add(rest);
    }
  }
  return out;
}

/// How many things of [section] [pack] really changes: an override left
/// blank keeps the game's name and is no change; a name given only in some
/// languages is one. What it adds is [addedCount].
int changedCount(NameSection section, WorldPack pack) {
  bool text(String s) => ActiveWorld.textOrNull(s) != null;
  final keys = <String>{
    ...switch (section) {
      NameSection.press => [
        for (final e in pack.reporters.entries)
          if (text(e.value.name) || text(e.value.outlet)) '${e.key}',
      ],
      NameSection.nameLists => [for (final k in pack.nameLists.keys) '$k'],
      NameSection.clubs ||
      NameSection.stadiums ||
      NameSection.competitions ||
      NameSection.yAccounts ||
      NameSection.sponsors => [
        for (final e in NameEdits._map(section, pack).entries)
          if (text(e.value)) e.key,
      ],
    },
    for (final path in pack.localized.keys)
      if (_localizedKey(section, path) case final key?
          when section.addedRoot == null ||
              !key.startsWith('${section.addedRoot}.'))
        key,
  };
  return keys.length;
}

/// How many items [pack] adds to [section].
int addedCount(NameSection section, WorldPack pack) => switch (section) {
  NameSection.clubs => pack.addedClubs.length,
  NameSection.sponsors => pack.addedSponsors.length,
  NameSection.yAccounts => pack.addedYAccounts.length,
  _ => 0,
};
