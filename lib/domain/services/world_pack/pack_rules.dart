import 'package:characters/characters.dart';
import 'package:fnm/core/config/languages.dart';

import '../../entities/enums.dart';
import '../../entities/player_ids.dart';
import '../club/clubs.dart';
import '../player/golden_generation.dart';
import '../player/player_traits.dart';
import '../press/y_feed.dart';
import '../profanity/profanity_filter.dart';
import '../rating/overall_rating.dart';
import 'pack_paths.dart';
import 'world_pack.dart';

enum FieldReason {
  empty,
  tooLong,
  badCharacters,
  outOfRange,

  /// Already another's: a Y account renamed onto another account's new
  /// name (which would mix the two up), an added club or Y account named
  /// like another the pack names, an id used twice or a trait picked twice.
  /// A clash with a name only the game gives is a [NameClash].
  duplicate,

  /// A word the game does not show ([ProfanityFilter]): only ever a
  /// [NotAllowedName]'s reason, never a [BadField]'s.
  notAllowed,
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

/// An issue between a well-formed pack and the game it is opened in: the
/// pack is kept and flagged, never refused, so files travel between newer
/// and older games. Its fix is Remove (the entry at [path] goes) or, where
/// the entry has a name, a rename.
sealed class CompatIssue extends PackIssue {
  const CompatIssue(this.path);

  /// The entry's own path.
  final String path;
  @override
  String get where => path;
}

/// An entry naming something the current game no longer has (see
/// [PackRules.compatibility]); [path] is the entry's own.
class UnknownId extends CompatIssue {
  const UnknownId(super.path);
}

/// A club or Y account the pack adds, or a Y account it renames, under a
/// name one of the game's own already has: a curated league's club or a
/// city club of its country, or a game Y account. A game update can add
/// such a name to a file made before it, so this is flagged, never refused.
/// So is an added club under the new name the pack gives a league club of
/// its country (see [PackRules.clubNameClash]). A clash with another added
/// item's name, or between two Y names the pack gives, is a [BadField]
/// ([FieldReason.duplicate]) instead.
class NameClash extends CompatIssue {
  const NameClash(super.path);
}

/// A `localized` value in a language this build does not speak, at
/// [path] (`localized.<path>.<language>`). Not a [CompatIssue]: it is kept
/// for the games that speak it, never shown here, and blocks nothing; the
/// editor lists it as a note ([PackRules.unknownLanguages]).
class UnknownLanguage extends PackIssue {
  const UnknownLanguage(this.path, this.language);
  final String path;
  final String language;
  @override
  String get where => path;
}

/// A name in the pack the game does not show ([ProfanityFilter]): a slur,
/// a sexual word or strong swearing, at [path] (the path a [BadField] about
/// that name would have; `name` is the database's own name).
///
/// Listed with what to fix and jumped to like any issue, but it blocks
/// nothing: a shared database is never refused for it. Until it is renamed
/// the game shows the name masked (`maskedForPlay`), and the stored pack
/// keeps it as it was.
class NotAllowedName extends PackIssue {
  const NotAllowedName(this.path);
  final String path;
  @override
  String get where => path;
}

/// Whether [issue] stands between a pack and a career: everything but a
/// [NotAllowedName] (masked in play) and an [UnknownLanguage] (never shown).
bool isBlocking(PackIssue issue) =>
    issue is! NotAllowedName && issue is! UnknownLanguage;

/// Whose name a club name already is, in a country ([PackRules.clubNameClash]).
enum ClubNameClash {
  /// Another club the pack adds to that country.
  added,

  /// A league club of that country the pack renames to it.
  renamed,

  /// A club of the game's in that country under its own name: a curated
  /// league's (one the pack leaves as it is), or a side the game names for
  /// one of its cities.
  game,

  /// A club the pack renames is called it in the game (any country): the
  /// rename map is keyed by the game's names, so a club under it would be
  /// renamed with it.
  renameKey,

  /// A club of the game's in another country goes by it.
  gameElsewhere,
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

  /// The most clubs, sponsors and Y accounts a pack adds. Clubs: about 24
  /// a nation, room for a whole league in every country, and still a bound
  /// on a hostile file (1.1.x raised it from 500; an older build refuses a
  /// file over its cap, and says the file is from a newer version first:
  /// see `kPackFormatVersion`).
  static const addedClubsMax = 5000, addedSponsorsMax = 50, addedYMax = 100;

  /// The most game clubs a pack sets a strength for. The game has about
  /// 1 600 clubs; this only bounds a hostile file.
  static const clubStrengthsMax = 5000;

  /// Longest added sponsor description.
  static const descriptionMax = 120;

  /// The most `localized` values (path and language pairs) a pack carries.
  static const localizedMax = 20000;

  static final _country = RegExp(r'^[a-z]{3}$');
  static final _industry = RegExp(r'^[a-zA-Z][a-zA-Z0-9]{0,39}$');

  /// What a Y @handle may hold (without its `@`): ASCII letters, digits and
  /// underscores, as on the real thing.
  static final _handle = RegExp(r'^[A-Za-z0-9_]+$');

  /// The longest @handle without its `@`: [handleMax] with it.
  static const int handleChars = handleMax - 1;

  /// What is wrong with [s] as a Y @handle (a leading `@` is not part of
  /// it): empty, longer than [handleChars], or holding anything but ASCII
  /// letters, digits and underscores. Null when it can be used.
  static FieldReason? checkHandle(String s) {
    final t = s.trim();
    if (t.isEmpty) return FieldReason.empty;
    if (t.length > handleChars) return FieldReason.tooLong;
    if (!_handle.hasMatch(t)) return FieldReason.badCharacters;
    return null;
  }

  /// Whether [industry] is shaped like an industry a sponsor can store.
  static bool industryShaped(String industry) => _industry.hasMatch(industry);

  /// A player's stored club country: three letters, either case.
  static final _clubCountry = RegExp(r'^[A-Za-z]{3}$');

  /// The shape of a language code a `localized` value may carry: `cs`,
  /// `fil`, `pt-BR`, `zh_Hant`. Whether this build speaks it is
  /// [compatibility]'s question, never a reason to refuse a file.
  static final languageShape = RegExp(r'^[a-z]{2,3}([_-][A-Za-z]{2,4})?$');

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

  static String _foldName(String s) => s.trim().toLowerCase();

  static Set<String>? _gameClubs;

  /// Every club name of the game's curated leagues, folded.
  static Set<String> get _allGameClubs => _gameClubs ??= {
    for (final l in ClubService.allLeagues())
      for (final c in l.clubs) _foldName(c),
  };

  /// Whose name [name] already is among [country]'s clubs (lower-case
  /// code) in [p], or null when nobody's: the ONE check for a club name,
  /// for an added club ([addedId], when it is that club's own name) and for
  /// a league club's rename ([renamedFrom], the game's name of the club
  /// being renamed). Compared trimmed and case-insensitively; a club's own
  /// name never clashes with itself. [countryCities] names a league-less
  /// country's own sides. The most pressing answer comes first: the pack's
  /// own names ([ClubNameClash.added], [ClubNameClash.renamed]), then the
  /// game's in the country, then the game's anywhere.
  ///
  /// [issues] and the editor read the answer each their way: the editor
  /// refuses every clash as it is typed; [issues] reports a clash with
  /// another added club as the pack's own duplicate, and the rest as a
  /// [NameClash] (a renamed club's new name, or a game update, can bring
  /// it), but not [ClubNameClash.gameElsewhere], which harms nothing.
  static ClubNameClash? clubNameClash(
    WorldPack p,
    String name,
    String country,
    Map<String, List<String>> countryCities, {
    int? addedId,
    String? renamedFrom,
  }) => ClubNameIndex(p, countryCities).clash(
    name,
    country,
    addedId: addedId,
    renamedFrom: renamedFrom,
  );

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
    // The club a player is stored at (the editor's pick, or "Free agent"):
    // shown as text, so it is a name like any other.
    final club = pl.club;
    if (club != null && club != ClubService.freeAgent) {
      final c = checkName(club);
      if (c != null) out.add(BadField('$base.club', c));
    }
    final country = pl.clubCountry;
    if (country != null && !_clubCountry.hasMatch(country)) {
      out.add(BadField('$base.clubCountry', FieldReason.badCharacters));
    }
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
    // Picked traits, known or not (an unknown one is [compatibility]'s): at
    // most as many as a rolled player carries, each once.
    final traits = pl.traits;
    if (traits != null) {
      final names = [for (final t in traits) t.name, ...pl.unknownTraits];
      if (names.length > PlayerTraits.maxTraits) {
        out.add(BadField('$base.traits', FieldReason.outOfRange));
      } else if (names.toSet().length != names.length) {
        out.add(BadField('$base.traits', FieldReason.duplicate));
      }
    }
  }

  /// [countryCities] are the city lists (biggest first) of the countries
  /// with no curated league, by lower-case code: an added club under the
  /// name of a side the game generates for one of them is a [NameClash].
  ///
  /// Every issue here but a [NameClash] is the pack's own; a [NameClash] is
  /// a [CompatIssue], flagged with what [compatibility] finds.
  static List<PackIssue> issues(
    WorldPack p, {
    Map<int, String> baseCodes = const {},
    Map<String, List<String>> countryCities = const {},
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
    if (p.clubStrengths.length > clubStrengthsMax) {
      out.add(const BadField('clubStrengths', FieldReason.outOfRange));
    }
    for (final e in p.clubStrengths.entries) {
      if (!ClubStrength.valid(e.value)) {
        out.add(BadField('clubStrengths.${e.key}', FieldReason.outOfRange));
      }
    }
    values('stadiums', p.stadiums);
    values('competitions', p.competitions);
    values('sponsors', p.sponsors);
    values('yAccounts', p.yAccounts, max: handleMax);
    _yClashes(p.yAccounts, p.addedYAccounts, out, checkAdded: false);
    for (final e in p.sponsorIndustries.entries) {
      if (!_industry.hasMatch(e.value)) {
        out.add(
          BadField('sponsorIndustries.${e.key}', FieldReason.badCharacters),
        );
      }
    }
    _handles(p, out);

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
    _managers(p, out, baseCodes);
    _added(p, out, name, countryCities);
    _localized(p, out);
    _yLanguageClashes(p, out);
    return out;
  }

  /// The day-one managers (format 4): each name 1 to [nameMax] characters
  /// that can be shown, each nationality three letters, and (when the game's
  /// codes [baseCodes] are known) one of them, in any case. Whether the
  /// nation itself is the game's is [compatibility]'s.
  static void _managers(
    WorldPack p,
    List<PackIssue> out,
    Map<int, String> baseCodes,
  ) {
    final codes = {for (final c in baseCodes.values) c.toUpperCase()};
    for (final id in p.managers.keys.toList()..sort()) {
      final m = p.managers[id]!;
      if (checkName(m.name) case final r?) {
        out.add(BadField('managers.$id.name', r));
      }
      final code = m.nationality.trim().toUpperCase();
      if (!_code.hasMatch(code)) {
        out.add(
          BadField('managers.$id.nationality', FieldReason.badCharacters),
        );
      } else if (codes.isNotEmpty && !codes.contains(code)) {
        out.add(BadField('managers.$id.nationality', FieldReason.outOfRange));
      }
    }
  }

  /// The pools beyond [poolIssues]: every pool id in the fringe space
  /// ([kFirstFringeId] to [kFringeIdLimit]; whose nation's it is,
  /// [compatibility] checks) or a pack-made one ([kPackPlayerIdBase] up to
  /// the golden generation's), and none used twice across the squads and
  /// the pools. Any other id (a core player's, the added items' range, the
  /// gap between) could never be a pool player.
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
        if (!poolIdInRange(pl.id)) {
          out.add(BadField(path, FieldReason.outOfRange));
        } else if (!seen.add(pl.id)) {
          out.add(BadField(path, FieldReason.duplicate));
        }
      }
    }
  }

  /// Whether [id] may be a pool player's: a fringe id or a pack-made one.
  static bool poolIdInRange(int id) =>
      (id >= kFirstFringeId && id < kFringeIdLimit) ||
      (id >= kPackPlayerIdBase && id < GoldenGeneration.idBase);

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
    Map<String, List<String>> countryCities,
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

    cap('addedClubs', p.addedClubs.length, addedClubsMax);
    // Every name folded once, so checking every club is linear in them,
    // not quadratic: thousands of clubs are checked on every edit.
    final names = ClubNameIndex(p, countryCities);
    for (final c in p.addedClubs) {
      final path = 'addedClubs.${c.id}';
      id('addedClubs', c.id);
      final r = checkName(c.name);
      if (c.strength case final s? when !ClubStrength.valid(s)) {
        out.add(BadField('$path.strength', FieldReason.outOfRange));
      }
      if (r != null) {
        out.add(BadField(path, r));
      } else {
        switch (names.clash(c.name, c.country, addedId: c.id)) {
          // Two added clubs under one name: the pack's own duplicate.
          case ClubNameClash.added:
            out.add(BadField(path, FieldReason.duplicate));
          // A league club the pack renames onto it (either may be the one
          // that moved), a club of the game's, or a club the rename map
          // names: flagged, not refused (Ruling 1).
          case ClubNameClash.renamed ||
              ClubNameClash.game ||
              ClubNameClash.renameKey:
            out.add(NameClash(path));
          case ClubNameClash.gameElsewhere || null:
            break;
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
      if (!_industry.hasMatch(s.industry)) {
        out.add(BadField('$path.industry', FieldReason.badCharacters));
      }
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

  /// Every @handle [p] sets (a built-in account's, `yHandles.<original>`,
  /// or an added one's, `addedYAccounts.<id>.handle`): one [checkHandle]
  /// takes, and no other account's ([takenHandle]).
  static void _handles(WorldPack p, List<PackIssue> out) {
    for (final e in p.yHandles.entries) {
      final path = 'yHandles.${e.key}';
      final r = checkHandle(e.value);
      if (r != null) {
        out.add(BadField(path, r));
      } else if (takenHandle(p, e.value, original: e.key)) {
        out.add(BadField(path, FieldReason.duplicate));
      }
    }
    for (final y in p.addedYAccounts) {
      final h = y.handle;
      if (h == null) continue;
      final path = 'addedYAccounts.${y.id}.handle';
      final r = checkHandle(h);
      if (r != null) {
        out.add(BadField(path, r));
      } else if (takenHandle(p, h, addedId: y.id)) {
        out.add(BadField(path, FieldReason.duplicate));
      }
    }
  }

  /// Whether [handle] (with or without its `@`) is, ignoring case, the
  /// @handle another account of [p] shows: any of the game's named accounts
  /// ([YFeed.namedAccounts], under the handle [p] gives it) or any account
  /// [p] adds, other than built-in account [original] or added [addedId].
  static bool takenHandle(
    WorldPack p,
    String handle, {
    String? original,
    int? addedId,
  }) {
    final want = YFeed.withAt(handle).toLowerCase();
    for (final o in YFeed.namedAccounts) {
      if (o == original) continue;
      if (YFeed.packHandleOf(p, o).toLowerCase() == want) return true;
    }
    for (final a in p.addedYAccounts) {
      if (a.id == addedId) continue;
      if (YFeed.addedHandleOf(a).toLowerCase() == want) return true;
    }
    return false;
  }

  /// Every `localized` entry: within [localizedMax] in all (one issue at
  /// `localized` past it); its path one [PackPaths] gives, naming an added
  /// item the pack has, and holding at least one value
  /// (`localized.<path>`); and each value under a code shaped like a
  /// language ([languageShape]) and a name within its root's cap
  /// (`localized.<path>.<language>`). A language this build does not speak
  /// is [compatibility]'s.
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
      if (values.isEmpty) {
        out.add(BadField('localized.$path', FieldReason.empty));
        continue;
      }
      for (final lang in values.keys.toList()..sort()) {
        final at = 'localized.$path.$lang';
        if (!languageShape.hasMatch(lang)) {
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

  /// Whether the Y account value [p] gives [path] (a `yAccounts.<original>`
  /// or `addedYAccounts.<id>` [PackPaths] path) in [language] clashes with
  /// what another account shows in that language (see [_yLanguageClashes]):
  /// the editor refuses such a value as it is typed.
  static bool yNameTakenIn(WorldPack p, String path, String language) {
    final out = <PackIssue>[];
    _yLanguageClashes(p, out);
    return out.any((i) => i.where == 'localized.$path.$language');
  }

  /// Whether the name [p] gives its added Y account [id] is taken (see
  /// [_yClashes]): another account's name, or, in a language in which
  /// another account shows a name of its own, that name while this account
  /// shows its main one there (see [_yLanguageClashes]). The editor refuses
  /// such a name as it is typed.
  static bool addedYNameTaken(WorldPack p, int id) {
    final out = <PackIssue>[];
    _yClashes(p.yAccounts, p.addedYAccounts, out, checkRenames: false);
    if (out.any((i) => i.where == 'addedYAccounts.$id')) return true;
    _yLanguageClashes(p, out, mainOf: id);
    final path = 'localized.${PackPaths.addedY(id)}.';
    return out.any((i) => i.where.startsWith(path));
  }

  /// A Y account's new name must be nobody else's: not another account's
  /// new name, nor another account's original name (the game's fixed
  /// accounts, or one this pack renames). Two accounts under one name would
  /// share a profile and the voice behind it. Compared trimmed and
  /// case-insensitively; keeping an account's own name is fine.
  ///
  /// The same goes for an account the pack adds ([added]). A clash with
  /// another new name, a rename's or an added account's, is the pack's own
  /// (a [BadField]). A clash with an original name is a [NameClash], for a
  /// rename and an added account alike: flagged, not refused, as a game
  /// update can add the name.
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
        if (byNewName[to]! > 1) {
          out.add(BadField('yAccounts.$k', FieldReason.duplicate));
        } else if (to != fold(k) && originals.contains(to)) {
          out.add(NameClash('yAccounts.$k'));
        }
      }
    }
    for (final a in checkAdded ? added : const <PackYAccount>[]) {
      if (checkName(a.name, max: handleMax) != null) continue;
      final to = fold(a.name);
      if (byNewName[to]! > 1) {
        out.add(BadField('addedYAccounts.${a.id}', FieldReason.duplicate));
      } else if (originals.contains(to)) {
        out.add(NameClash('addedYAccounts.${a.id}'));
      }
    }
  }

  /// No two Y accounts may show under one name in any language: a value
  /// `localized` gives an account (a renamed one, `yAccounts.<original>`, or
  /// an added one, `addedYAccounts.<id>`) is checked against what every
  /// other account shows in that language (its own value there, else its
  /// main name: a rename's, an added account's, or the game account's own).
  /// Each clashing value is a [NameClash] at `localized.<path>.<language>`
  /// (Ruling 1: flagged, not refused). Main names alone are [_yClashes]'s.
  ///
  /// With [mainOf], added account [mainOf]'s main name is checked as well,
  /// in each language where it shows it (it has no value of its own there):
  /// a clash is reported at its path in that language.
  static void _yLanguageClashes(
    WorldPack p,
    List<PackIssue> out, {
    int? mainOf,
  }) {
    String fold(String s) => s.trim().toLowerCase();
    final languages = <String>{};
    for (final e in p.localized.entries) {
      final root = PackPaths.parse(e.key)?.root;
      if (root == 'yAccounts' || root == 'addedYAccounts') {
        // A language this build does not speak is never shown, so it can
        // clash with nothing ([compatibility] flags it as unknown).
        languages.addAll(e.value.keys.where(supportedLanguageCodes.contains));
      }
    }
    if (languages.isEmpty) return;
    final originals = {
      ...YFeed.namedAccounts,
      ...p.yAccounts.keys,
      for (final path in p.localized.keys)
        if (PackPaths.parse(path) case (root: 'yAccounts', :final rest)) rest,
    };
    for (final lang in languages.toList()..sort()) {
      // Each account: what it shows in [lang], and the path that gave it
      // when that is a per-language value.
      final shown = <({String name, String? path})>[];
      String? value(String path) {
        final v = p.localized[path]?[lang];
        return v == null || v.trim().isEmpty ? null : v;
      }

      for (final o in originals) {
        final path = PackPaths.yAccount(o);
        final own = value(path);
        final main = p.yAccounts[o];
        shown.add((
          name: own ?? (main == null || main.trim().isEmpty ? o : main),
          path: own == null ? null : path,
        ));
      }
      for (final a in p.addedYAccounts) {
        final path = PackPaths.addedY(a.id);
        final own = value(path);
        shown.add((
          name: own ?? a.name,
          path: own == null && a.id != mainOf ? null : path,
        ));
      }
      final count = <String, int>{};
      for (final s in shown) {
        count.update(fold(s.name), (n) => n + 1, ifAbsent: () => 1);
      }
      final clashes = [
        for (final s in shown)
          if (s.path != null && count[fold(s.name)]! > 1)
            'localized.${s.path}.$lang',
      ]..sort();
      out.addAll(clashes.map(NameClash.new));
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
  /// [sponsorBrands] and [sponsorIndustries] (picker-only trades), and a
  /// `localized` path whose key the game no longer has (`localized.<path>`, checked as the plain maps are).
  ///
  /// And what this build does not know of a well-formed file: a picked
  /// trait (`<squads|pools>.<id>.<playerId>.traits`), a sponsor's deal
  /// (`addedSponsors.<id>.deal`) and a Y account's voice
  /// (`addedYAccounts.<id>.voice`). A language this build does not speak is
  /// not here: it blocks nothing ([unknownLanguages]).
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
    Set<String> sponsorIndustries = const {},
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
    ids('managers', p.managers.keys);
    names('competitions', p.competitions.keys, competitionNames);
    names('yAccounts', p.yAccounts.keys, yAccounts);
    names('sponsors', p.sponsors.keys, sponsorBrands);
    names('trophies', p.trophies, trophyKeys);
    names('yHandles', p.yHandles.keys, yAccounts);
    for (final k in p.sponsorIndustries.keys.toList()..sort()) {
      final v = p.sponsorIndustries[k]!;
      if (!sponsorBrands.contains(k) ||
          (!sponsorBrands.contains(v) && !sponsorIndustries.contains(v))) {
        out.add(UnknownId('sponsorIndustries.$k'));
      }
    }

    for (final n in p.pools.keys.toList()..sort()) {
      if (!nationIds.contains(n)) {
        out.add(UnknownId('pools.$n'));
        continue;
      }
      final range = fringeRanges[n];
      for (final pl in p.pools[n]!) {
        // Pack-made ids, and ids [issues] already refuses, are not fringe.
        if (pl.id < kFirstFringeId || pl.id >= kFringeIdLimit) continue;
        if (range == null || pl.id < range.first || pl.id > range.last) {
          out.add(UnknownId('pools.$n.${pl.id}'));
        }
      }
    }
    for (final (root, players) in [('squads', p.squads), ('pools', p.pools)]) {
      for (final n in players.keys.toList()..sort()) {
        for (final pl in players[n]!) {
          if (pl.unknownTraits.isNotEmpty) {
            out.add(UnknownId('$root.$n.${pl.id}.traits'));
          }
        }
      }
    }
    for (final c in p.addedClubs) {
      if (!countryCodes.contains(c.country)) {
        out.add(UnknownId('addedClubs.${c.id}'));
      }
    }
    for (final s in p.addedSponsors) {
      if (!sponsorBrands.contains(s.industry) &&
          !sponsorIndustries.contains(s.industry)) {
        out.add(UnknownId('addedSponsors.${s.id}'));
      }
      if (s.unknownDeal != null) {
        out.add(UnknownId('addedSponsors.${s.id}.deal'));
      }
    }
    for (final y in p.addedYAccounts) {
      if (y.nationId case final n? when !nationIds.contains(n)) {
        out.add(UnknownId('addedYAccounts.${y.id}'));
      }
      if (y.unknownVoice != null) {
        out.add(UnknownId('addedYAccounts.${y.id}.voice'));
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

  /// Every name of [p] the game does not show ([ProfanityFilter]), each a
  /// [NotAllowedName] at its own path, in the order [issues] goes: the
  /// players first (as [notAllowedPlayers] gives them), then the nations,
  /// the renames, the reporters, the name lists, the managers, the added
  /// clubs, sponsors and Y accounts, the per-language values, and last the
  /// database's own name (`name`). Blocks nothing ([isBlocking]).
  static List<NotAllowedName> notAllowed(WorldPack p) {
    final out = <NotAllowedName>[];
    void check(String path, String? v) {
      if (v != null && v.trim().isNotEmpty && ProfanityFilter.isOffensive(v)) {
        out.add(NotAllowedName(path));
      }
    }

    for (final id in p.squads.keys.toList()..sort()) {
      out.addAll(notAllowedPlayers('squads.$id', p.squads[id]!));
    }
    for (final id in p.pools.keys.toList()..sort()) {
      out.addAll(notAllowedPlayers('pools.$id', p.pools[id]!));
    }
    for (final id in p.nations.keys.toList()..sort()) {
      check('nations.$id.name', p.nations[id]!.name);
    }
    for (final (root, m) in [
      ('clubs', p.clubs),
      ('stadiums', p.stadiums),
      ('competitions', p.competitions),
      ('sponsors', p.sponsors),
      ('yAccounts', p.yAccounts),
      ('yHandles', p.yHandles),
    ]) {
      for (final k in m.keys.toList()..sort()) {
        check('$root.$k', m[k]);
      }
    }
    for (final id in p.reporters.keys.toList()..sort()) {
      check('reporters.$id.name', p.reporters[id]!.name);
      check('reporters.$id.outlet', p.reporters[id]!.outlet);
    }
    for (final id in p.nameLists.keys.toList()..sort()) {
      final l = p.nameLists[id]!;
      for (final (kind, names) in [('first', l.first), ('sur', l.sur)]) {
        for (var i = 0; i < names.length; i++) {
          check('nameLists.$id.$kind.$i', names[i]);
        }
      }
    }
    for (final id in p.managers.keys.toList()..sort()) {
      check('managers.$id.name', p.managers[id]!.name);
    }
    for (final c in p.addedClubs) {
      check('addedClubs.${c.id}', c.name);
    }
    for (final s in p.addedSponsors) {
      check('addedSponsors.${s.id}', s.name);
      check('addedSponsors.${s.id}.description', s.description);
    }
    for (final y in p.addedYAccounts) {
      check('addedYAccounts.${y.id}', y.name);
      check('addedYAccounts.${y.id}.handle', y.handle);
    }
    for (final path in p.localized.keys.toList()..sort()) {
      final values = p.localized[path]!;
      for (final lang in values.keys.toList()..sort()) {
        check('localized.$path.$lang', values[lang]);
      }
    }
    check('name', p.name);
    return out;
  }

  /// [players]' names and clubs the game does not show, at
  /// `<base>.<playerId>.name` and `.club` ([base] is `squads.<nationId>` or
  /// `pools.<nationId>`).
  static List<NotAllowedName> notAllowedPlayers(
    String base,
    List<PackPlayer> players,
  ) => [
    for (final pl in players) ...[
      if (ProfanityFilter.isOffensive(pl.name))
        NotAllowedName('$base.${pl.id}.name'),
      if (pl.club case final c? when ProfanityFilter.isOffensive(c))
        NotAllowedName('$base.${pl.id}.club'),
    ],
  ];

  /// Every `localized` value of [p] under a well-formed language this build
  /// does not speak, by path then language. Kept, listed, never blocking:
  /// see [UnknownLanguage].
  static List<UnknownLanguage> unknownLanguages(WorldPack p) => [
    for (final path in p.localized.keys.toList()..sort())
      for (final lang in p.localized[path]!.keys.toList()..sort())
        if (languageShape.hasMatch(lang) &&
            !supportedLanguageCodes.contains(lang))
          UnknownLanguage('localized.$path.$lang', lang),
  ];

  static bool isComplete(
    WorldPack p, {
    Map<int, String> baseCodes = const {},
    Map<String, List<String>> countryCities = const {},
  }) => issues(
    p,
    baseCodes: baseCodes,
    countryCities: countryCities,
  ).isEmpty;
}

/// Every club name a pack's club checks compare against, folded once: the
/// index behind [PackRules.clubNameClash]. Built for one pack and kept for
/// all of its clubs, so checking n clubs costs n lookups rather than n
/// scans of every name (which at the 5 000-club cap was 25 million
/// comparisons on every edit). A country's part is built the first time a
/// club of it is asked about.
class ClubNameIndex {
  ClubNameIndex(this._p, this._countryCities);

  final WorldPack _p;
  final Map<String, List<String>> _countryCities;

  static String _fold(String s) => s.trim().toLowerCase();

  /// Lower-case code -> folded name -> the ids of the added clubs under it.
  late final Map<String, Map<String, List<int>>> _added = () {
    final out = <String, Map<String, List<int>>>{};
    for (final c in _p.addedClubs) {
      ((out[c.country] ??= {})[_fold(c.name)] ??= []).add(c.id);
    }
    return out;
  }();

  /// Folded rename key -> the keys (game names) folding to it.
  late final Map<String, List<String>> _renameKeys = () {
    final out = <String, List<String>>{};
    for (final k in _p.clubs.keys) {
      (out[_fold(k)] ??= []).add(k);
    }
    return out;
  }();

  final Map<String, _CountryNames> _countries = {};

  _CountryNames _country(String code) => _countries[code] ??= () {
    final renamed = <String, List<String>>{};
    final game = <String, List<String>>{};
    for (final original in ClubService.leagueClubs(code)) {
      switch (_p.clubs[original]) {
        case final to? when to.trim().isNotEmpty:
          (renamed[_fold(to)] ??= []).add(original);
        case _:
          (game[_fold(original)] ??= []).add(original);
      }
    }
    return (
      renamed: renamed,
      game: game,
      domestic: {
        for (final c in ClubService.domesticClubNames(
          code,
          _countryCities[code] ?? const [],
        ))
          _fold(c),
      },
    );
  }();

  /// [PackRules.clubNameClash] for [name] in [country], off this index.
  ClubNameClash? clash(
    String name,
    String country, {
    int? addedId,
    String? renamedFrom,
  }) {
    final to = _fold(name);
    if (renamedFrom != null && _fold(renamedFrom) == to) return null;
    final code = country.toLowerCase();
    if (_added[code]?[to]?.any((id) => id != addedId) ?? false) {
      return ClubNameClash.added;
    }
    final here = _country(code);
    bool other(List<String>? names) =>
        names?.any((n) => n != renamedFrom) ?? false;
    if (other(here.renamed[to])) return ClubNameClash.renamed;
    if (other(here.game[to]) || here.domestic.contains(to)) {
      return ClubNameClash.game;
    }
    if (other(_renameKeys[to])) return ClubNameClash.renameKey;
    if (PackRules._allGameClubs.contains(to)) {
      return ClubNameClash.gameElsewhere;
    }
    return null;
  }
}

/// One country's part of a [ClubNameIndex]: its league clubs under the
/// names the pack gives them ([renamed]) and under their own ([game]),
/// each folded name to the game names behind it, and the folded names of
/// the sides the game names for its cities ([domestic]).
typedef _CountryNames = ({
  Map<String, List<String>> renamed,
  Map<String, List<String>> game,
  Set<String> domestic,
});
