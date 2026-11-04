import '../../entities/enums.dart';
import '../rating/overall_rating.dart';
import 'world_pack.dart';

enum FieldReason { empty, tooLong, badCharacters, outOfRange }

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

/// A pack id the game does not know (raised by the loader, not [PackRules]).
class UnknownId extends PackIssue {
  const UnknownId(this.path);
  final String path;
  @override
  String get where => path;
}

abstract final class PackRules {
  static const squadMin = 23, squadMax = 40, gkMin = 3, defMin = 6;
  static const midMin = 6, fwdMin = 3;
  static const nameMax = 40, handleMax = 30, codeLength = 3;
  static const nameListMin = 20;

  static final _control = RegExp(r'\p{Cc}', unicode: true);
  static final _code = RegExp(r'^[A-Z]{3}$');

  static FieldReason? checkName(String s, {int max = nameMax}) {
    final t = s.trim();
    if (t.isEmpty) return FieldReason.empty;
    if (t.length > max) return FieldReason.tooLong;
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

  static List<PackIssue> issues(WorldPack p) {
    final out = <PackIssue>[];
    void name(String path, String v, {int max = nameMax}) {
      final r = checkName(v, max: max);
      if (r != null) out.add(BadField(path, r));
    }

    for (final id in p.squads.keys.toList()..sort()) {
      final squad = p.squads[id]!;
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
        name('$base.name', pl.name);
        if (pl.age < 15 || pl.age > 45) {
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
    }

    final byCode = <String, List<int>>{};
    for (final id in p.nations.keys.toList()..sort()) {
      final n = p.nations[id]!;
      name('nations.$id.name', n.name);
      final r = checkCode(n.code);
      if (r != null) {
        out.add(BadField('nations.$id.code', r));
      } else {
        byCode.putIfAbsent(n.code, () => []).add(id);
      }
    }
    for (final e in byCode.entries) {
      if (e.value.length > 1) out.add(DuplicateCode(e.key, e.value));
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

  static bool isComplete(WorldPack p) => issues(p).isEmpty;
}
