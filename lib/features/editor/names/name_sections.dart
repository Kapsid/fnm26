import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:fnm/domain/services/world_pack/pack_keys.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';
import 'package:fnm/features/editor/players/players_ui.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The editor sections that rename what the game names: each a list of
/// (game name, the database's name) rows.
enum NameSection {
  nations(EditorSection.nations),
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
    nations => 'nations',
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
  bool get translated =>
      this == nations || this == competitions || this == sponsors;

  /// Whether a row has a second field: a nation's code, a reporter's outlet.
  bool get paired => this == nations || this == press;

  /// Whether its rows are grouped under their country.
  bool get grouped => this == clubs || this == stadiums;
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
  });

  /// Its key in the pack's override map (a nation or reporter id as text).
  final String key;

  /// The game's name for it, in the manager's language.
  final String original;

  /// The game's second value: a nation's code, a reporter's outlet.
  final String original2;

  /// A line about it under the name (a stadium's city).
  final String? detail;

  /// The nation it is (nations, name lists) or belongs to (clubs, stadiums).
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
    case NameSection.nations:
    case NameSection.nameLists:
      final pools = {
        for (final e in lists.entries) e.key: namePoolOf(e.value),
      };
      return one([
        for (final n in nations)
          NameEntry(
            key: '${n.id}',
            original: n.name,
            original2: section == NameSection.nations ? n.code : '',
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
  switch (section) {
    case NameSection.nations:
      final n = pack.nations[int.tryParse(e.key)];
      // Both blank is the game's name and code: no change at all.
      return n == null ||
              (ActiveWorld.textOrNull(n.name) == null &&
                  ActiveWorld.textOrNull(n.code) == null)
          ? null
          : (name: n.name, second: n.code);
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

  /// [pack] with [e] named [name] (and [second], for a nation's code or a
  /// reporter's outlet). A blank field keeps the game's value; when both
  /// come out as the game's, the override goes.
  static WorldPack rename(
    NameSection section,
    WorldPack pack,
    NameEntry e,
    String name, [
    String second = '',
  ]) {
    final n = name.trim();
    final s = section == NameSection.nations
        ? second.trim().toUpperCase()
        : second.trim();
    final newName = n.isEmpty ? e.original : n;
    final newSecond = s.isEmpty ? e.original2 : s;
    final same = newName == e.original && newSecond == e.original2;
    switch (section) {
      case NameSection.nations:
        // What stays the game's is stored blank: the game's name is in the
        // manager's language, and stored it would show in every language.
        final id = int.parse(e.key);
        return pack.copyWith(
          nations: {
            for (final x in pack.nations.entries)
              if (x.key != id) x.key: x.value,
            if (!same)
              id: (
                name: newName == e.original ? '' : newName,
                code: newSecond == e.original2 ? '' : newSecond,
              ),
          },
        );
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

  /// [pack] with nothing of [e] overridden.
  static WorldPack reset(NameSection section, WorldPack pack, NameEntry e) =>
      section == NameSection.nameLists
      ? withLists(pack, e, const [], const [])
      : rename(section, pack, e, '');

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

/// How many problems [issues] (of a whole pack) count against each row key
/// of [section].
Map<String, int> issuesByKey(NameSection section, List<PackIssue> issues) {
  final out = <String, int>{};
  void add(String key) => out.update(key, (n) => n + 1, ifAbsent: () => 1);
  final root = section.issueRoot;
  for (final issue in issues) {
    if (issue is DuplicateCode) {
      if (section == NameSection.nations) {
        for (final id in issue.nationIds) {
          add('$id');
        }
      }
      continue;
    }
    final path = issue.where;
    if (!path.startsWith('$root.')) continue;
    final rest = path.substring(root.length + 1);
    switch (section) {
      case NameSection.nations || NameSection.press || NameSection.nameLists:
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
/// blank keeps the game's name and is no change (a nation with both its
/// name and code blank included).
int changedCount(NameSection section, WorldPack pack) {
  bool text(String s) => ActiveWorld.textOrNull(s) != null;
  return switch (section) {
    NameSection.nations =>
      pack.nations.values.where((n) => text(n.name) || text(n.code)).length,
    NameSection.press =>
      pack.reporters.values.where((r) => text(r.name) || text(r.outlet)).length,
    NameSection.nameLists => pack.nameLists.length,
    NameSection.clubs ||
    NameSection.stadiums ||
    NameSection.competitions ||
    NameSection.yAccounts ||
    NameSection.sponsors => NameEdits._map(
      section,
      pack,
    ).values.where(text).length,
  };
}
