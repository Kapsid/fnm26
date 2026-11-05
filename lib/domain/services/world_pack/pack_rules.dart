import 'package:characters/characters.dart';

import '../../entities/enums.dart';
import '../press/y_feed.dart';
import '../rating/overall_rating.dart';
import 'world_pack.dart';

enum FieldReason {
  empty,
  tooLong,
  badCharacters,
  outOfRange,

  /// The name is already another's: a Y account renamed onto another
  /// account's name, which would mix the two up.
  duplicate,
}

/// One thing standing between a pack and a career.
sealed class PackIssue {
  const PackIssue();

  /// Human-meaningful path the editor can jump to.
  String get where;
}

class SquadTooSmall extends PackIssue {
  const SquadTooSmall(this.nationId, this.have, this.need);
  final int nationId;
  final int have;
  final int need;
  @override
  String get where => 'squads.$nationId';
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
      final base = 'squads.$id.${pl.id}';
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
    }
    return out;
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
    _yClashes(p.yAccounts, out);

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
    return out;
  }

  /// Whether the Y account [original]'s new name in [renames] clashes with
  /// another account's name (see [_yClashes]): the editor refuses such a
  /// rename as it is typed.
  static bool yNameTaken(Map<String, String> renames, String original) {
    final out = <PackIssue>[];
    _yClashes(renames, out);
    return out.any((i) => i.where == 'yAccounts.$original');
  }

  /// A Y account's new name must be nobody else's: not another account's
  /// original name (the game's fixed accounts, or one this pack renames),
  /// and not another account's new name. Two accounts under one name would
  /// share a profile and the voice behind it. Compared trimmed and
  /// case-insensitively; keeping an account's own name is fine.
  static void _yClashes(Map<String, String> renames, List<PackIssue> out) {
    String fold(String s) => s.trim().toLowerCase();
    final originals = {
      for (final n in YFeed.namedAccounts) fold(n),
      for (final k in renames.keys) fold(k),
    };
    final byNewName = <String, int>{};
    for (final v in renames.values) {
      if (v.trim().isEmpty) continue;
      byNewName.update(fold(v), (n) => n + 1, ifAbsent: () => 1);
    }
    for (final k in renames.keys.toList()..sort()) {
      final v = renames[k]!;
      if (v.trim().isEmpty) continue;
      final to = fold(v);
      final taken =
          (to != fold(k) && originals.contains(to)) || byNewName[to]! > 1;
      if (taken) out.add(BadField('yAccounts.$k', FieldReason.duplicate));
    }
  }

  /// What in [p] the current game no longer has: every override keyed by a
  /// nation id outside [nationIds] (squads, nations, stadiums, name lists),
  /// a competition outside [competitionNames], a trophy outside
  /// [trophyKeys], a sponsor outside [sponsorBrands] and a Y account outside
  /// [yAccounts], each as an [UnknownId] at its entry's path.
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
    return out;
  }

  static bool isComplete(
    WorldPack p, {
    Map<int, String> baseCodes = const {},
  }) => issues(p, baseCodes: baseCodes).isEmpty;
}
