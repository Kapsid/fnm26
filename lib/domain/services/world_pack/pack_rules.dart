import 'package:characters/characters.dart';
import 'package:fnm/core/config/ui_language.dart';
import 'package:fnm/data/seed/pool_generator.dart';

import '../../entities/enums.dart';
import '../club/clubs.dart';
import '../player/golden_generation.dart';
import '../player/player_traits.dart';
import '../press/y_feed.dart';
import '../rating/overall_rating.dart';
import 'pack_paths.dart';
import 'world_pack.dart';

enum FieldReason {
  empty,
  tooLong,
  badCharacters,
  outOfRange,

  /// Already another's: a Y account renamed onto another account's name
  /// (which would mix the two up), an added club named like another of its
  /// country, an id used twice or a trait picked twice.
  duplicate,
}

/// One thing standing between a pack and a career.
sealed class PackIssue {
  const PackIssue();

  /// Human-meaningful path the editor can jump to.
  String get where;
}

/// A squad (or, with [pool], a pool) of the wrong size: [have] against the
/// bound [need] it breaks, a minimum or a maximum.
class SquadTooSmall extends PackIssue {
  const SquadTooSmall(this.nationId, this.have, this.need, {this.pool = false});
  final int nationId;
  final int have;
  final int need;

  /// Whether it is the nation's pool (`pools.<id>`), not its squad.
  final bool pool;
  @override
  String get where => pool ? 'pools.$nationId' : 'squads.$nationId';
}

class NeedsPosition extends PackIssue {
  const NeedsPosition(this.nationId, this.category, this.have, this.need);
  final int nationId;
  final PositionCategory category;
  final int have;
  final int need;
  @override
  String get where => 'squads.$nationId';
}

class BadField extends PackIssue {
  const BadField(this.path, this.reason);
  final String path;
  final FieldReason reason;
  @override
  String get where => path;
}

class DuplicateCode extends PackIssue {
  const DuplicateCode(this.code, this.nationIds);
  final String code;
  final List<int> nationIds;
  @override
  String get where => 'nations.${nationIds.first}.code';
}

/// An entry naming something the current game no longer has (see
/// [PackRules.compatibility]); [path] is the entry's own.
class UnknownId extends PackIssue {
  const UnknownId(this.path);
  final String path;
  @override
  String get where => path;
}

abstract final class PackRules {
  static const squadMin = 23, squadMax = 40, gkMin = 3, defMin = 6;
  static const midMin = 6, fwdMin = 3;

  /// The ages a pack player may have, both ends included.
  static const ageMin = 15, ageMax = 45;
  static const nameMax = 40, handleMax = 30, codeLength = 3;
  static const nameListMin = 20;

  /// The most players a nation's fixed pool holds.
  static const poolMax = 150;

  /// The most clubs, sponsors and Y accounts a pack adds.
  static const addedClubsMax = 500, addedSponsorsMax = 50, addedYMax = 100;

  /// Longest added sponsor description.
  static const descriptionMax = 120;

  /// The most `localized` values (path and language pairs) a pack carries.
  static const localizedMax = 20000;

  static final _country = RegExp(r'^[a-z]{3}$');

  static final _control = RegExp(r'\p{Cc}', unicode: true);
  static final _code = RegExp(r'^[A-Z]{3}$');

  /// How long [s] is, in user-perceived characters (grapheme clusters):
  /// the unit every name cap counts in, here, in the editor's text fields
  /// (whose `maxLength` counts the same) and when an import is renamed. An
  /// emoji family is one character, not the eight UTF-16 units it takes.
  static int nameLength(String s) => s.characters.length;

  /// [s] cut to at most [max] characters ([nameLength]), trailing spaces
  /// dropped.
  static String fitName(String s, {int max = nameMax}) {
    final c = s.characters;
    return c.length <= max ? s : c.take(max).toString().trimRight();
  }

  static FieldReason? checkName(String s, {int max = nameMax}) {
    final t = s.trim();
    if (t.isEmpty) return FieldReason.empty;
    if (nameLength(t) > max) return FieldReason.tooLong;
    if (_control.hasMatch(t) || _hasUnpairedSurrogate(t)) {
      return FieldReason.badCharacters;
    }
    return null;
  }

  static bool _hasUnpairedSurrogate(String s) {
    final u = s.codeUnits;
    for (var i = 0; i < u.length; i++) {
      final c = u[i];
      if (c >= 0xD800 && c <= 0xDBFF) {
        if (i + 1 < u.length && u[i + 1] >= 0xDC00 && u[i + 1] <= 0xDFFF) {
          i++;
          continue;
        }
        return true;
      }
      if (c >= 0xDC00 && c <= 0xDFFF) return true;
    }
    return false;
  }

  static FieldReason? checkCode(String s) =>
      _code.hasMatch(s) ? null : FieldReason.badCharacters;

  /// What stands between nation [id]'s [squad] and a career: its size, its
  /// position cover and each player's fields. Exactly the squad part of
  /// [issues] for that nation, in the same order; the editor asks it for
  /// one nation without checking the whole pack.
  static List<PackIssue> squadIssues(int id, List<PackPlayer> squad) {
    final out = <PackIssue>[];
    if (squad.length < squadMin) {
      out.add(SquadTooSmall(id, squad.length, squadMin));
    } else if (squad.length > squadMax) {
      out.add(SquadTooSmall(id, squad.length, squadMax));
    }
    final counts = {for (final c in PositionCategory.values) c: 0};
    for (final pl in squad) {
      counts[pl.position.category] = counts[pl.position.category]! + 1;
    }
    const needs = {
      PositionCategory.goalkeeper: gkMin,
      PositionCategory.defender: defMin,
      PositionCategory.midfielder: midMin,
      PositionCategory.forward: fwdMin,
    };
    for (final e in needs.entries) {
      if (counts[e.key]! < e.value) {
        out.add(NeedsPosition(id, e.key, counts[e.key]!, e.value));
      }
    }
    for (final pl in squad) {
      _playerFields('squads.$id.${pl.id}', pl, out);
    }
    return out;
  }

  /// What stands between nation [nationId]'s fixed [pool] and a career: its
  /// size (at most [poolMax], with no minimum) and each player's fields as
  /// [squadIssues] checks them, at `pools.<nationId>.<playerId>`. Exactly the
  /// per-nation part of [issues]'s pool checks; whether an id is free and in
  /// range needs the whole pack, and only [issues] checks it.
  static List<PackIssue> poolIssues(int nationId, List<PackPlayer> pool) {
    final out = <PackIssue>[];
    if (pool.length > poolMax) {
      out.add(SquadTooSmall(nationId, pool.length, poolMax, pool: true));
    }
    for (final pl in pool) {
      _playerFields('pools.$nationId.${pl.id}', pl, out);
    }
    return out;
  }

  static void _playerFields(String base, PackPlayer pl, List<PackIssue> out) {
    final r = checkName(pl.name);
    if (r != null) out.add(BadField('$base.name', r));
    if (pl.age < ageMin || pl.age > ageMax) {
      out.add(BadField('$base.age', FieldReason.outOfRange));
    }
    final overall = OverallRating.forPosition(pl.position, pl.attributes);
    if (overall < 1 || overall > 99) {
      out.add(BadField('$base.attributes', FieldReason.outOfRange));
    }
    if (pl.potential < overall || pl.potential > 99) {
      out.add(BadField('$base.potential', FieldReason.outOfRange));
    }
    // Picked traits: the game's own (the reader refuses any other), at most
    // as many as a rolled player carries, each once.
    final traits = pl.traits;
    if (traits != null) {
      if (traits.length > PlayerTraits.maxTraits) {
        out.add(BadField('$base.traits', FieldReason.outOfRange));
      } else if (traits.toSet().length != traits.length) {
        out.add(BadField('$base.traits', FieldReason.duplicate));
      }
    }
  }

  static List<PackIssue> issues(
    WorldPack p, {
    Map<int, String> baseCodes = const {},
  }) {
    final out = <PackIssue>[];
    void name(String path, String v, {int max = nameMax}) {
      final r = checkName(v, max: max);
      if (r != null) out.add(BadField(path, r));
    }

    for (final id in p.squads.keys.toList()..sort()) {
      out.addAll(squadIssues(id, p.squads[id]!));
    }
    _pools(p, out);

    final effective = {...baseCodes};
    for (final id in p.nations.keys.toList()..sort()) {
      final n = p.nations[id]!;
      // A blank name or code keeps the game's (`ActiveWorld.textOrNull`):
      // a nation whose code alone changes keeps its name translated.
      if (n.name.trim().isNotEmpty) name('nations.$id.name', n.name);
      if (n.code.trim().isEmpty) continue;
      final r = checkCode(n.code);
      if (r != null) {
        out.add(BadField('nations.$id.code', r));
        effective.remove(id);
      } else {
        effective[id] = n.code;
      }
    }
    final byCode = <String, List<int>>{};
    for (final id in effective.keys.toList()..sort()) {
      byCode.putIfAbsent(effective[id]!, () => []).add(id);
    }
    for (final e in byCode.entries) {
      if (e.value.length > 1 && e.value.any(p.nations.containsKey)) {
        out.add(DuplicateCode(e.key, e.value));
      }
    }

    void values(String root, Map<String, String> m, {int max = nameMax}) {
      for (final e in m.entries) {
        name('$root.${e.key}', e.value, max: max);
      }
    }

    values('clubs', p.clubs);
    values('stadiums', p.stadiums);
    values('competitions', p.competitions);
    values('sponsors', p.sponsors);
    values('yAccounts', p.yAccounts, max: handleMax);
    _yClashes(p.yAccounts, p.addedYAccounts, out, checkAdded: false);

    for (final id in p.reporters.keys.toList()..sort()) {
      name('reporters.$id.name', p.reporters[id]!.name);
      name('reporters.$id.outlet', p.reporters[id]!.outlet);
    }

    for (final id in p.nameLists.keys.toList()..sort()) {
      final l = p.nameLists[id]!;
      for (final e in {'first': l.first, 'sur': l.sur}.entries) {
        final path = 'nameLists.$id.${e.key}';
        final filled = e.value.where((s) => s.trim().isNotEmpty).length;
        if (filled < nameListMin) {
          out.add(BadField(path, FieldReason.outOfRange));
        }
        for (var i = 0; i < e.value.length; i++) {
          name('$path.$i', e.value[i]);
        }
      }
    }
    _added(p, out, name);
    _localized(p, out);
    return out;
  }

  /// The pools beyond [poolIssues]: every pool id at or above
  /// `PoolGenerator.firstFringeId` (a fringe id, whose nation
  /// [compatibility] checks, or a pack-made one below the golden
  /// generation's), and none used twice across the squads and the pools.
  static void _pools(WorldPack p, List<PackIssue> out) {
    final seen = {
      for (final squad in p.squads.values)
        for (final pl in squad) pl.id,
    };
    for (final n in p.pools.keys.toList()..sort()) {
      final pool = p.pools[n]!;
      out.addAll(poolIssues(n, pool));
      for (final pl in pool) {
        final path = 'pools.$n.${pl.id}';
        if (pl.id < PoolGenerator.firstFringeId ||
            pl.id >= GoldenGeneration.idBase) {
          out.add(BadField(path, FieldReason.outOfRange));
        } else if (!seen.add(pl.id)) {
          out.add(BadField(path, FieldReason.duplicate));
        }
      }
    }
  }

  /// Whether [id] may be an added club's, sponsor's or Y account's.
  static bool addedIdInRange(int id) =>
      id >= kPackAddedIdBase && id <= kPackAddedIdMax;

  /// The added clubs, sponsors and Y accounts: each list within its cap
  /// (one issue at the list's root past it), each id in the reserved range
  /// and used once across the three (`<root>.<id>.id`), each name a name.
  static void _added(
    WorldPack p,
    List<PackIssue> out,
    void Function(String path, String v, {int max}) name,
  ) {
    final ids = <int>{};
    void id(String root, int id) {
      if (!addedIdInRange(id)) {
        out.add(BadField('$root.$id.id', FieldReason.outOfRange));
      } else if (!ids.add(id)) {
        out.add(BadField('$root.$id.id', FieldReason.duplicate));
      }
    }

    void cap(String root, int have, int max) {
      if (have > max) out.add(BadField(root, FieldReason.outOfRange));
    }

    String fold(String s) => s.trim().toLowerCase();

    cap('addedClubs', p.addedClubs.length, addedClubsMax);
    // Another club of the country: its league's, as this pack names them,
    // or another added one.
    final taken = <String, Set<String>>{};
    final addedNames = <String, Map<String, int>>{};
    for (final c in p.addedClubs) {
      (addedNames[c.country] ??= {}).update(
        fold(c.name),
        (n) => n + 1,
        ifAbsent: () => 1,
      );
    }
    for (final c in p.addedClubs) {
      final path = 'addedClubs.${c.id}';
      id('addedClubs', c.id);
      final r = checkName(c.name);
      if (r != null) {
        out.add(BadField(path, r));
      } else {
        final league = taken[c.country] ??= {
          for (final original in ClubService.leagueClubs(c.country))
            fold(p.clubs[original] ?? original),
        };
        final to = fold(c.name);
        if (league.contains(to) || addedNames[c.country]![to]! > 1) {
          out.add(BadField(path, FieldReason.duplicate));
        }
      }
      if (!_country.hasMatch(c.country)) {
        out.add(BadField('$path.country', FieldReason.badCharacters));
      }
    }

    cap('addedSponsors', p.addedSponsors.length, addedSponsorsMax);
    for (final s in p.addedSponsors) {
      final path = 'addedSponsors.${s.id}';
      id('addedSponsors', s.id);
      name(path, s.name);
      if (s.description.trim().isNotEmpty) {
        name('$path.description', s.description, max: descriptionMax);
      }
    }

    cap('addedYAccounts', p.addedYAccounts.length, addedYMax);
    for (final y in p.addedYAccounts) {
      id('addedYAccounts', y.id);
      name('addedYAccounts.${y.id}', y.name, max: handleMax);
    }
    _yClashes(p.yAccounts, p.addedYAccounts, out, checkRenames: false);
  }

  /// Every `localized` entry: within [localizedMax] in all (one issue at
  /// `localized` past it); its path one [PackPaths] gives, naming an added
  /// item the pack has (`localized.<path>`); and each value in a language
  /// the app speaks and a name within its root's cap
  /// (`localized.<path>.<language>`).
  static void _localized(WorldPack p, List<PackIssue> out) {
    final total = p.localized.values.fold(0, (n, m) => n + m.length);
    if (total > localizedMax) {
      out.add(const BadField('localized', FieldReason.outOfRange));
    }
    final clubIds = {for (final c in p.addedClubs) c.id};
    final sponsorIds = {for (final s in p.addedSponsors) s.id};
    final yIds = {for (final y in p.addedYAccounts) y.id};
    int? idOf(String s) {
      final n = int.tryParse(s);
      return n != null && '$n' == s ? n : null;
    }

    for (final path in p.localized.keys.toList()..sort()) {
      final parsed = PackPaths.parse(path);
      final rest = parsed?.rest ?? '';
      var max = nameMax;
      final ok = switch (parsed?.root) {
        null => false,
        'addedClubs' => clubIds.contains(idOf(rest)),
        'addedYAccounts' => yIds.contains(idOf(rest)),
        'addedSponsors' => () {
          final dot = rest.indexOf('.');
          if (dot < 0) return sponsorIds.contains(idOf(rest));
          max = descriptionMax;
          return rest.substring(dot + 1) == 'description' &&
              sponsorIds.contains(idOf(rest.substring(0, dot)));
        }(),
        'reporters' => () {
          final parts = rest.split('.');
          return parts.length == 2 &&
              idOf(parts[0]) != null &&
              (parts[1] == 'name' || parts[1] == 'outlet');
        }(),
        _ => true,
      };
      if (!ok) {
        out.add(BadField('localized.$path', FieldReason.outOfRange));
        continue;
      }
      if (parsed!.root == 'yAccounts' || parsed.root == 'addedYAccounts') {
        max = handleMax;
      }
      final values = p.localized[path]!;
      for (final lang in values.keys.toList()..sort()) {
        final at = 'localized.$path.$lang';
        if (!supportedLanguageCodes.contains(lang)) {
          out.add(BadField(at, FieldReason.outOfRange));
          continue;
        }
        final r = checkName(values[lang]!, max: max);
        if (r != null) out.add(BadField(at, r));
      }
    }
  }

  /// Whether the Y account [original]'s new name in [renames] clashes with
  /// another account's name (see [_yClashes]): the editor refuses such a
  /// rename as it is typed.
  static bool yNameTaken(
    Map<String, String> renames,
    String original, {
    List<PackYAccount> added = const [],
  }) {
    final out = <PackIssue>[];
    _yClashes(renames, added, out);
    return out.any((i) => i.where == 'yAccounts.$original');
  }

  /// A Y account's new name must be nobody else's: not another account's
  /// original name (the game's fixed accounts, or one this pack renames),
  /// and not another account's new name. Two accounts under one name would
  /// share a profile and the voice behind it. Compared trimmed and
  /// case-insensitively; keeping an account's own name is fine.
  ///
  /// An account the pack adds ([added]) joins in: its name must be no game
  /// account's, no rename's (either side) and no other account's.
  /// [checkRenames] and [checkAdded] pick which side is reported, so
  /// [issues] lists each where its section is.
  static void _yClashes(
    Map<String, String> renames,
    List<PackYAccount> added,
    List<PackIssue> out, {
    bool checkRenames = true,
    bool checkAdded = true,
  }) {
    String fold(String s) => s.trim().toLowerCase();
    final originals = {
      for (final n in YFeed.namedAccounts) fold(n),
      for (final k in renames.keys) fold(k),
    };
    final byNewName = <String, int>{};
    void count(String v) {
      if (v.trim().isEmpty) return;
      byNewName.update(fold(v), (n) => n + 1, ifAbsent: () => 1);
    }

    renames.values.forEach(count);
    for (final a in added) {
      count(a.name);
    }
    if (checkRenames) {
      for (final k in renames.keys.toList()..sort()) {
        final v = renames[k]!;
        if (v.trim().isEmpty) continue;
        final to = fold(v);
        final taken =
            (to != fold(k) && originals.contains(to)) || byNewName[to]! > 1;
        if (taken) out.add(BadField('yAccounts.$k', FieldReason.duplicate));
      }
    }
    for (final a in checkAdded ? added : const <PackYAccount>[]) {
      if (checkName(a.name, max: handleMax) != null) continue;
      final to = fold(a.name);
      if (originals.contains(to) || byNewName[to]! > 1) {
        out.add(BadField('addedYAccounts.${a.id}', FieldReason.duplicate));
      }
    }
  }

  /// What in [p] the current game no longer has: every override keyed by a
  /// nation id outside [nationIds] (squads, nations, stadiums, name lists),
  /// a competition outside [competitionNames], a trophy outside
  /// [trophyKeys], a sponsor outside [sponsorBrands] and a Y account outside
  /// [yAccounts], each as an [UnknownId] at its entry's path.
  ///
  /// Format 2's parts likewise: a pool keyed by an unknown nation
  /// (`pools.<id>`), a pool's fringe id outside its own nation's range in
  /// [fringeRanges] (`pools.<id>.<playerId>`), an added club in a country
  /// outside [countryCodes] (lower-case), an added Y account bound to an
  /// unknown nation, an added sponsor whose industry is outside
  /// [sponsorBrands], and a `localized` path whose key the game no longer
  /// has (`localized.<path>`, checked as the plain maps are).
  ///
  /// Only references: whether an entry's content is right is [issues]'s
  /// business. A nation the game has and the pack never mentions is not an
  /// issue either: the pack takes the game's for it.
  static List<PackIssue> compatibility(
    WorldPack p, {
    required Set<int> nationIds,
    required Set<String> competitionNames,
    required Set<String> trophyKeys,
    required Set<String> sponsorBrands,
    required Set<String> yAccounts,
    required Set<String> countryCodes,
    required Map<int, ({int first, int last})> fringeRanges,
  }) {
    final out = <PackIssue>[];
    void ids(String root, Iterable<int> keys) {
      for (final id in keys.toList()..sort()) {
        if (!nationIds.contains(id)) out.add(UnknownId('$root.$id'));
      }
    }

    void names(String root, Iterable<String> keys, Set<String> known) {
      for (final k in keys.toList()..sort()) {
        if (!known.contains(k)) out.add(UnknownId('$root.$k'));
      }
    }

    ids('squads', p.squads.keys);
    ids('nations', p.nations.keys);
    for (final k in p.stadiums.keys.toList()..sort()) {
      final id = int.tryParse(k.split(':').first);
      if (id == null || !nationIds.contains(id)) {
        out.add(UnknownId('stadiums.$k'));
      }
    }
    ids('nameLists', p.nameLists.keys);
    names('competitions', p.competitions.keys, competitionNames);
    names('yAccounts', p.yAccounts.keys, yAccounts);
    names('sponsors', p.sponsors.keys, sponsorBrands);
    names('trophies', p.trophies, trophyKeys);

    for (final n in p.pools.keys.toList()..sort()) {
      if (!nationIds.contains(n)) {
        out.add(UnknownId('pools.$n'));
        continue;
      }
      final range = fringeRanges[n];
      for (final pl in p.pools[n]!) {
        // Pack-made ids, and ids [issues] already refuses, are not fringe.
        if (pl.id < PoolGenerator.firstFringeId || pl.id >= kPackPlayerIdBase) {
          continue;
        }
        if (range == null || pl.id < range.first || pl.id > range.last) {
          out.add(UnknownId('pools.$n.${pl.id}'));
        }
      }
    }
    for (final c in p.addedClubs) {
      if (!countryCodes.contains(c.country)) {
        out.add(UnknownId('addedClubs.${c.id}'));
      }
    }
    for (final s in p.addedSponsors) {
      if (!sponsorBrands.contains(s.industry)) {
        out.add(UnknownId('addedSponsors.${s.id}'));
      }
    }
    for (final y in p.addedYAccounts) {
      if (y.nationId case final n? when !nationIds.contains(n)) {
        out.add(UnknownId('addedYAccounts.${y.id}'));
      }
    }
    for (final path in p.localized.keys.toList()..sort()) {
      final parsed = PackPaths.parse(path);
      if (parsed == null) continue;
      final key = parsed.rest;
      final known = switch (parsed.root) {
        'stadiums' => nationIds.contains(int.tryParse(key.split(':').first)),
        'competitions' => competitionNames.contains(key),
        'sponsors' => sponsorBrands.contains(key),
        'yAccounts' => yAccounts.contains(key),
        _ => true,
      };
      if (!known) out.add(UnknownId('localized.$path'));
    }
    return out;
  }

  static bool isComplete(
    WorldPack p, {
    Map<int, String> baseCodes = const {},
  }) => issues(p, baseCodes: baseCodes).isEmpty;
}
