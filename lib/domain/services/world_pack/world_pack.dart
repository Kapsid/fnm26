import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../../entities/enums.dart';
import '../../entities/player_attributes.dart';
import '../club/clubs.dart';
import '../federation/sponsors.dart';
import '../player/player_traits.dart';
import '../press/y_feed.dart';

/// Current on-disk format of a world pack. Format 2 (editor 2) adds
/// [WorldPack.pools], the added clubs, sponsors and Y accounts,
/// [WorldPack.localized] and [PackPlayer.traits]; format 3 (clubs) adds
/// club strength ([WorldPack.clubStrengths], [PackClub.strength]); format 4
/// (world managers) adds [WorldPack.managers]; format 5 (1.1.1) adds a
/// built-in sponsor's industry ([WorldPack.sponsorIndustries]) and a Y
/// account's handle ([WorldPack.yHandles], [PackYAccount.handle]); format 6
/// (1.1.1) adds the press reporters and the stadiums a pack adds
/// ([WorldPack.addedReporters], [WorldPack.addedStadiums]).
/// [WorldPack.migrate] lifts a format-1 to 5 pack to it, step by step.
///
/// A pack is written in the oldest format that holds it ([WorldPack.asWritten]):
/// format 3 when it names no managers, so a 1.1.x build without managers still
/// reads it, format 4 when it does, format 5 when it sets an industry or a
/// handle, and format 6 only when it adds a reporter or a stadium. A build
/// that reads only an older format says the file is from a newer version
/// rather than calling it broken.
const int kPackFormatVersion = 6;

/// Ids at or above this belong to players created in a pack.
const int kPackPlayerIdBase = 800000000;

/// The id range of the clubs, sponsors, Y accounts, reporters and stadiums
/// a pack adds (one range for all of them, each id used once).
const int kPackAddedIdBase = 700000000, kPackAddedIdMax = 799999999;

/// The voices a pack's own Y account can post as.
const Set<YVoice> kPackYVoices = {
  YVoice.fan,
  YVoice.pundit,
  YVoice.meme,
  YVoice.stats,
  YVoice.rival,
  YVoice.expro,
  YVoice.neutral,
};

const _eq = DeepCollectionEquality();

/// A player in a pack's core squad. [potential] is the peak overall, 1..99.
@immutable
class PackPlayer {
  const PackPlayer({
    required this.id,
    required this.name,
    required this.age,
    required this.position,
    required this.attributes,
    required this.potential,
    this.club,
    this.clubCountry,
    this.traits,
    this.unknownTraits = const [],
  });

  final int id;
  final String name;
  final int age;
  final PlayerPosition position;
  final PlayerAttributes attributes;
  final int potential;
  final String? club;
  final String? clubCountry;

  /// His traits as picked in the pack. Null is Random: the game rolls them
  /// as it always has. An empty list is "no traits". Only the traits this
  /// build knows; see [unknownTraits].
  final List<PlayerTrait>? traits;

  /// Picked trait names this build does not know (a file from a newer or
  /// older game), kept as they are so the file travels on unchanged. Every
  /// reader ignores them; the editor flags them (`PackRules.compatibility`)
  /// and Remove drops them ([withoutUnknown]). Non-empty only when [traits]
  /// is non-null.
  final List<String> unknownTraits;

  /// This player with [unknownTraits] dropped.
  PackPlayer withoutUnknown() => PackPlayer(
    id: id,
    name: name,
    age: age,
    position: position,
    attributes: attributes,
    potential: potential,
    club: club,
    clubCountry: clubCountry,
    traits: traits,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'position': position.name,
    'attributes': {
      'physical': attributes.physical,
      'technical': attributes.technical,
      'stamina': attributes.stamina,
    },
    'potential': potential,
    'club': club,
    'clubCountry': clubCountry,
    if (traits case final t?)
      'traits': [for (final x in t) x.name, ...unknownTraits],
  };

  static PackPlayer fromJson(Object? raw) {
    final m = _map(raw, 'player');
    _only(m, const {
      'id',
      'name',
      'age',
      'position',
      'attributes',
      'potential',
      'club',
      'clubCountry',
      'traits',
    }, 'player');
    final a = _map(m['attributes'], 'attributes');
    _only(a, const {'physical', 'technical', 'stamina'}, 'attributes');
    final positionName = _str(m['position'], 'position');
    final position = PlayerPosition.values.asNameMap()[positionName];
    if (position == null) {
      throw FormatException('Unknown position "$positionName"');
    }
    final traitNames = m['traits'] == null
        ? null
        : [for (final t in _strList(m['traits'], 'traits')) _token(t, 'trait')];
    final known = PlayerTrait.values.asNameMap();
    return PackPlayer(
      id: _int(m['id'], 'id'),
      name: _str(m['name'], 'name'),
      age: _int(m['age'], 'age'),
      position: position,
      attributes: PlayerAttributes(
        physical: _int(a['physical'], 'physical'),
        technical: _int(a['technical'], 'technical'),
        stamina: _int(a['stamina'], 'stamina'),
      ),
      potential: _int(m['potential'], 'potential'),
      club: _strOrNull(m['club'], 'club'),
      clubCountry: _strOrNull(m['clubCountry'], 'clubCountry'),
      traits: traitNames == null
          ? null
          : [for (final t in traitNames) ?known[t]],
      unknownTraits: [
        for (final t in traitNames ?? const <String>[])
          if (!known.containsKey(t)) t,
      ],
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PackPlayer &&
      other.id == id &&
      other.name == name &&
      other.age == age &&
      other.position == position &&
      other.attributes == attributes &&
      other.potential == potential &&
      other.club == club &&
      other.clubCountry == clubCountry &&
      _eq.equals(other.traits, traits) &&
      _eq.equals(other.unknownTraits, unknownTraits);

  @override
  int get hashCode => Object.hash(
    id,
    name,
    age,
    position,
    attributes,
    potential,
    club,
    clubCountry,
    traits == null ? null : _eq.hash(traits),
    _eq.hash(unknownTraits),
  );
}

/// A club a pack adds. [country] is a lower-case FIFA code; [strength] its
/// stars, 1 to 5 (format 3), or null for its league's lowest.
@immutable
class PackClub {
  const PackClub({
    required this.id,
    required this.name,
    required this.country,
    this.strength,
  });

  final int id;
  final String name;
  final String country;
  final int? strength;

  /// This club under [name] and/or with [strength] (a [Some] of null
  /// clears it back to the default).
  PackClub copyWith({String? name, Some<int?>? strength}) => PackClub(
    id: id,
    name: name ?? this.name,
    country: country,
    strength: strength == null ? this.strength : strength.value,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'country': country,
    'strength': ?strength,
  };

  static PackClub fromJson(Object? raw) {
    final m = _map(raw, 'club');
    _only(m, const {'id', 'name', 'country', 'strength'}, 'club');
    return PackClub(
      id: _int(m['id'], 'id'),
      name: _str(m['name'], 'name'),
      country: _str(m['country'], 'country'),
      strength: m['strength'] == null ? null : _int(m['strength'], 'strength'),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PackClub &&
      other.id == id &&
      other.name == name &&
      other.country == country &&
      other.strength == strength;

  @override
  int get hashCode => Object.hash(id, name, country, strength);
}

/// A value that may itself be null, for a `copyWith` that must tell "leave
/// it" (no [Some]) from "set it to null".
@immutable
class Some<T> {
  const Some(this.value);
  final T value;
}

/// A sponsor a pack adds. [industry] is the `SponsorBrand.name` whose
/// industry label it reuses; [description] is empty when none was given.
@immutable
class PackSponsor {
  const PackSponsor({
    required this.id,
    required this.name,
    required this.deal,
    required this.industry,
    this.description = '',
    this.unknownDeal,
  });

  final int id;
  final String name;
  final SponsorDeal deal;
  final String industry;
  final String description;

  /// The deal name the file gave when this build does not know it (a newer
  /// or older game's), kept so the file travels on unchanged; [deal] is then
  /// [fallbackDeal]. The editor flags it (`PackRules.compatibility`), and
  /// Remove keeps [fallbackDeal] ([withoutUnknown]).
  final String? unknownDeal;

  /// The deal an unknown one reads as: the plain, middle-of-the-road deal
  /// (a modest fee, no board or press trouble).
  static const SponsorDeal fallbackDeal = SponsorDeal.crowdPleaser;

  /// This sponsor with [unknownDeal] dropped: its deal is [deal].
  PackSponsor withoutUnknown() => PackSponsor(
    id: id,
    name: name,
    deal: deal,
    industry: industry,
    description: description,
  );

  /// Its string id wherever the game stores a sponsor.
  String get key => 'pack$id';

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'deal': unknownDeal ?? deal.name,
    'industry': industry,
    'description': description,
  };

  static PackSponsor fromJson(Object? raw) {
    final m = _map(raw, 'sponsor');
    _only(m, const {
      'id',
      'name',
      'deal',
      'industry',
      'description',
    }, 'sponsor');
    final dealName = _token(_str(m['deal'], 'deal'), 'deal');
    final deal = SponsorDeal.values.asNameMap()[dealName];
    return PackSponsor(
      id: _int(m['id'], 'id'),
      name: _str(m['name'], 'name'),
      deal: deal ?? fallbackDeal,
      industry: _str(m['industry'], 'industry'),
      description: _strOrNull(m['description'], 'description') ?? '',
      unknownDeal: deal == null ? dealName : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PackSponsor &&
      other.id == id &&
      other.name == name &&
      other.deal == deal &&
      other.industry == industry &&
      other.description == description &&
      other.unknownDeal == unknownDeal;

  @override
  int get hashCode =>
      Object.hash(id, name, deal, industry, description, unknownDeal);
}

/// A Y account a pack adds, posting as [voice] (one of [kPackYVoices]) in
/// nation [nationId]'s feed, or in every nation's when it is null.
@immutable
class PackYAccount {
  const PackYAccount({
    required this.id,
    required this.name,
    required this.voice,
    this.nationId,
    this.unknownVoice,
    this.handle,
  });

  final int id;
  final String name;
  final YVoice voice;
  final int? nationId;

  /// The account's @handle without the `@` (format 5), or null for the one
  /// its name gives (`YFeed.handleFor`).
  final String? handle;

  /// The voice name the file gave when it is not one of [kPackYVoices] in
  /// this build, kept so the file travels on unchanged; [voice] is then
  /// [fallbackVoice]. The editor flags it (`PackRules.compatibility`), and
  /// Remove keeps [fallbackVoice] ([withoutUnknown]).
  final String? unknownVoice;

  /// The voice an unknown one reads as: the plain observer's.
  static const YVoice fallbackVoice = YVoice.neutral;

  /// This account with [unknownVoice] dropped: its voice is [voice].
  PackYAccount withoutUnknown() => PackYAccount(
    id: id,
    name: name,
    voice: voice,
    nationId: nationId,
    handle: handle,
  );

  /// This account with [name] and [handle] as given (the rest kept).
  PackYAccount withNames({required String name, required String? handle}) =>
      PackYAccount(
        id: id,
        name: name,
        voice: voice,
        nationId: nationId,
        unknownVoice: unknownVoice,
        handle: handle,
      );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'voice': unknownVoice ?? voice.name,
    'nationId': nationId,
    // Format 5's key, written only when set: an account without one reads
    // in a format-4 build.
    'handle': ?handle,
  };

  static PackYAccount fromJson(Object? raw) {
    final m = _map(raw, 'yAccount');
    _only(m, const {'id', 'name', 'voice', 'nationId', 'handle'}, 'yAccount');
    final voiceName = _token(_str(m['voice'], 'voice'), 'voice');
    final voice = YVoice.values.asNameMap()[voiceName];
    final known = voice != null && kPackYVoices.contains(voice);
    final nationId = m['nationId'];
    return PackYAccount(
      id: _int(m['id'], 'id'),
      name: _str(m['name'], 'name'),
      voice: known ? voice : fallbackVoice,
      nationId: nationId == null ? null : _int(nationId, 'nationId'),
      unknownVoice: known ? null : voiceName,
      handle: m['handle'] == null ? null : _str(m['handle'], 'handle'),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PackYAccount &&
      other.id == id &&
      other.name == name &&
      other.voice == voice &&
      other.nationId == nationId &&
      other.unknownVoice == unknownVoice &&
      other.handle == handle;

  @override
  int get hashCode =>
      Object.hash(id, name, voice, nationId, unknownVoice, handle);
}

/// Custom first and surname pools for one nation.
@immutable
class PackNameLists {
  const PackNameLists({required this.first, required this.sur});

  final List<String> first;
  final List<String> sur;

  Map<String, Object?> toJson() => {'first': first, 'sur': sur};

  static PackNameLists fromJson(Object? raw) {
    final m = _map(raw, 'nameLists');
    _only(m, const {'first', 'sur'}, 'nameLists');
    return PackNameLists(
      first: _strList(m['first'], 'first'),
      sur: _strList(m['sur'], 'sur'),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PackNameLists &&
      _eq.equals(other.first, first) &&
      _eq.equals(other.sur, sur);

  @override
  int get hashCode => Object.hash(_eq.hash(first), _eq.hash(sur));
}

/// A press reporter replacement.
@immutable
class PackReporter {
  const PackReporter({required this.name, required this.outlet});

  final String name;
  final String outlet;

  Map<String, Object?> toJson() => {'name': name, 'outlet': outlet};

  static PackReporter fromJson(Object? raw) {
    final m = _map(raw, 'reporter');
    _only(m, const {'name', 'outlet'}, 'reporter');
    return PackReporter(
      name: _str(m['name'], 'name'),
      outlet: _str(m['outlet'], 'outlet'),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PackReporter && other.name == name && other.outlet == outlet;

  @override
  int get hashCode => Object.hash(name, outlet);
}

/// A press reporter a pack adds (format 6): he joins the game's reporters
/// in the press room of a career on the pack.
@immutable
class PackAddedReporter {
  const PackAddedReporter({
    required this.id,
    required this.name,
    required this.outlet,
  });

  final int id;
  final String name;
  final String outlet;

  Map<String, Object?> toJson() => {'id': id, 'name': name, 'outlet': outlet};

  static PackAddedReporter fromJson(Object? raw) {
    final m = _map(raw, 'addedReporter');
    _only(m, const {'id', 'name', 'outlet'}, 'addedReporter');
    return PackAddedReporter(
      id: _int(m['id'], 'id'),
      name: _str(m['name'], 'name'),
      outlet: _str(m['outlet'], 'outlet'),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PackAddedReporter &&
      other.id == id &&
      other.name == name &&
      other.outlet == outlet;

  @override
  int get hashCode => Object.hash(id, name, outlet);
}

/// A stadium a pack adds to nation [nationId] (format 6): a ground of
/// [capacity] seats in [city], one more of the nation's grounds in a career
/// on the pack.
@immutable
class PackStadium {
  const PackStadium({
    required this.id,
    required this.nationId,
    required this.name,
    required this.city,
    required this.capacity,
  });

  final int id;
  final int nationId;
  final String name;
  final String city;
  final int capacity;

  Map<String, Object?> toJson() => {
    'id': id,
    'nationId': nationId,
    'name': name,
    'city': city,
    'capacity': capacity,
  };

  static PackStadium fromJson(Object? raw) {
    final m = _map(raw, 'addedStadium');
    _only(m, const {
      'id',
      'nationId',
      'name',
      'city',
      'capacity',
    }, 'addedStadium');
    return PackStadium(
      id: _int(m['id'], 'id'),
      nationId: _int(m['nationId'], 'nationId'),
      name: _str(m['name'], 'name'),
      city: _str(m['city'], 'city'),
      capacity: _int(m['capacity'], 'capacity'),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PackStadium &&
      other.id == id &&
      other.nationId == nationId &&
      other.name == name &&
      other.city == city &&
      other.capacity == capacity;

  @override
  int get hashCode => Object.hash(id, nationId, name, city, capacity);
}

/// A shareable custom starting world: edits layered on the default world.
@immutable
class WorldPack {
  const WorldPack({
    required this.uuid,
    required this.name,
    required this.author,
    required this.formatVersion,
    required this.madeWithVersion,
    this.squads = const {},
    this.nations = const {},
    this.clubs = const {},
    this.clubStrengths = const {},
    this.stadiums = const {},
    this.competitions = const {},
    this.yAccounts = const {},
    this.reporters = const {},
    this.nameLists = const {},
    this.sponsors = const {},
    this.trophies = const {},
    this.pools = const {},
    this.addedClubs = const [],
    this.addedSponsors = const [],
    this.addedYAccounts = const [],
    this.localized = const {},
    this.managers = const {},
    this.sponsorIndustries = const {},
    this.yHandles = const {},
    this.addedReporters = const [],
    this.addedStadiums = const [],
  });

  final String uuid;
  final String name;
  final String author;
  final int formatVersion;
  final String madeWithVersion;

  /// nationId -> core squad.
  final Map<int, List<PackPlayer>> squads;
  final Map<int, ({String name, String code})> nations;

  /// Original club name -> new name.
  final Map<String, String> clubs;

  /// A game club's original name -> its stars, 1 to 5 (format 3). A club
  /// not in it has its default strength (`ClubStrength.derived`).
  final Map<String, int> clubStrengths;

  /// `'$nationId:$city'` -> stadium name.
  final Map<String, String> stadiums;

  /// Canonical stored English name -> new name.
  final Map<String, String> competitions;

  /// Original display name -> new name.
  final Map<String, String> yAccounts;

  /// Index in `Press.reporters` -> replacement.
  final Map<int, PackReporter> reporters;
  final Map<int, PackNameLists> nameLists;

  /// `SponsorBrand.name` -> new name.
  final Map<String, String> sponsors;

  /// Keys that have a custom trophy PNG.
  final Set<String> trophies;

  /// nationId -> the whole day-one fringe. A nation not in it draws its
  /// fringe per career, as 1.1.0 does.
  final Map<int, List<PackPlayer>> pools;
  final List<PackClub> addedClubs;
  final List<PackSponsor> addedSponsors;
  final List<PackYAccount> addedYAccounts;

  /// Path (see `PackPaths`) -> language code -> value.
  final Map<String, Map<String, String>> localized;

  /// nationId -> the name and nationality (upper-case FIFA code) of the
  /// manager in charge on day one. Renames only the seeded incumbent; every
  /// later manager is the game's own.
  final Map<int, ({String name, String nationality})> managers;

  /// A built-in sponsor's `SponsorBrand.name` -> the industry it is shown
  /// in: another brand's name (that brand's trade) or a `SponsorIndustry`
  /// id, as an added sponsor stores its own (format 5).
  final Map<String, String> sponsorIndustries;

  /// A built-in Y account's original display name -> its @handle without
  /// the `@` (format 5). An account not in it keeps the handle its name
  /// gives.
  final Map<String, String> yHandles;

  /// The press reporters the pack adds (format 6).
  final List<PackAddedReporter> addedReporters;

  /// The stadiums the pack adds, every nation's (format 6).
  final List<PackStadium> addedStadiums;

  /// Whether the pack uses what only format 6 holds.
  bool get _needsFormat6 =>
      addedReporters.isNotEmpty || addedStadiums.isNotEmpty;

  /// Whether the pack uses what only format 5 holds.
  bool get _needsFormat5 =>
      sponsorIndustries.isNotEmpty ||
      yHandles.isNotEmpty ||
      addedYAccounts.any((y) => y.handle != null);

  /// This pack in the oldest format that holds it, as every writer stores
  /// and exports it: format 3 (which a 1.1.x build without managers reads)
  /// when it names no managers, 4 when it does, 5 when it sets a sponsor's
  /// industry or a Y handle, and [kPackFormatVersion] (6) only when it adds
  /// a reporter or a stadium.
  WorldPack get asWritten => copyWith(
    formatVersion: _needsFormat6
        ? kPackFormatVersion
        : _needsFormat5
        ? 5
        : managers.isEmpty
        ? 3
        : 4,
  );

  /// [managers] without the entries a game cannot use: a blank name, a
  /// nationality that is not one of [codes] (upper-case FIFA codes), or a
  /// nation id not in [nationIds]. Each one dropped is passed to [dropped].
  /// Light on purpose: a bad entry costs only itself, never the pack.
  static Map<int, ({String name, String nationality})> usableManagers(
    Map<int, ({String name, String nationality})> managers, {
    required Set<int> nationIds,
    required Set<String> codes,
    void Function(int nationId, String why)? dropped,
  }) {
    final out = <int, ({String name, String nationality})>{};
    for (final MapEntry(key: id, value: m) in managers.entries) {
      final why = m.name.trim().isEmpty
          ? 'blank name'
          : !codes.contains(m.nationality.trim().toUpperCase())
          ? 'unknown nationality "${m.nationality}"'
          : !nationIds.contains(id)
          ? 'unknown nation'
          : null;
      if (why == null) {
        out[id] = m;
      } else {
        dropped?.call(id, why);
      }
    }
    return out;
  }

  WorldPack copyWith({
    String? uuid,
    String? name,
    String? author,
    int? formatVersion,
    String? madeWithVersion,
    Map<int, List<PackPlayer>>? squads,
    Map<int, ({String name, String code})>? nations,
    Map<String, String>? clubs,
    Map<String, int>? clubStrengths,
    Map<String, String>? stadiums,
    Map<String, String>? competitions,
    Map<String, String>? yAccounts,
    Map<int, PackReporter>? reporters,
    Map<int, PackNameLists>? nameLists,
    Map<String, String>? sponsors,
    Set<String>? trophies,
    Map<int, List<PackPlayer>>? pools,
    List<PackClub>? addedClubs,
    List<PackSponsor>? addedSponsors,
    List<PackYAccount>? addedYAccounts,
    Map<String, Map<String, String>>? localized,
    Map<int, ({String name, String nationality})>? managers,
    Map<String, String>? sponsorIndustries,
    Map<String, String>? yHandles,
    List<PackAddedReporter>? addedReporters,
    List<PackStadium>? addedStadiums,
  }) => WorldPack(
    uuid: uuid ?? this.uuid,
    name: name ?? this.name,
    author: author ?? this.author,
    formatVersion: formatVersion ?? this.formatVersion,
    madeWithVersion: madeWithVersion ?? this.madeWithVersion,
    squads: squads ?? this.squads,
    nations: nations ?? this.nations,
    clubs: clubs ?? this.clubs,
    clubStrengths: clubStrengths ?? this.clubStrengths,
    stadiums: stadiums ?? this.stadiums,
    competitions: competitions ?? this.competitions,
    yAccounts: yAccounts ?? this.yAccounts,
    reporters: reporters ?? this.reporters,
    nameLists: nameLists ?? this.nameLists,
    sponsors: sponsors ?? this.sponsors,
    trophies: trophies ?? this.trophies,
    pools: pools ?? this.pools,
    addedClubs: addedClubs ?? this.addedClubs,
    addedSponsors: addedSponsors ?? this.addedSponsors,
    addedYAccounts: addedYAccounts ?? this.addedYAccounts,
    localized: localized ?? this.localized,
    managers: managers ?? this.managers,
    sponsorIndustries: sponsorIndustries ?? this.sponsorIndustries,
    yHandles: yHandles ?? this.yHandles,
    addedReporters: addedReporters ?? this.addedReporters,
    addedStadiums: addedStadiums ?? this.addedStadiums,
  );

  Map<String, Object?> toJson() => {
    'uuid': uuid,
    'name': name,
    'author': author,
    'formatVersion': formatVersion,
    'madeWithVersion': madeWithVersion,
    'squads': {
      for (final e in squads.entries)
        '${e.key}': [for (final p in e.value) p.toJson()],
    },
    'nations': {
      for (final e in nations.entries)
        '${e.key}': {'name': e.value.name, 'code': e.value.code},
    },
    'clubs': clubs,
    'clubStrengths': clubStrengths,
    'stadiums': stadiums,
    'competitions': competitions,
    'yAccounts': yAccounts,
    'reporters': {
      for (final e in reporters.entries) '${e.key}': e.value.toJson(),
    },
    'nameLists': {
      for (final e in nameLists.entries) '${e.key}': e.value.toJson(),
    },
    'sponsors': sponsors,
    'trophies': trophies.toList()..sort(),
    'pools': {
      for (final e in pools.entries)
        '${e.key}': [for (final p in e.value) p.toJson()],
    },
    'addedClubs': [for (final c in addedClubs) c.toJson()],
    'addedSponsors': [for (final s in addedSponsors) s.toJson()],
    'addedYAccounts': [for (final y in addedYAccounts) y.toJson()],
    'localized': {
      for (final e in localized.entries) e.key: {...e.value},
    },
    // Written from format 4 on (see [asWritten]): a format-3 reader knows
    // no such key.
    if (formatVersion >= 4 || managers.isNotEmpty)
      'managers': {
        for (final e in managers.entries)
          '${e.key}': {
            'name': e.value.name,
            'nationality': e.value.nationality,
          },
      },
    // Written from format 5 on (see [asWritten]): a format-4 reader knows
    // neither key.
    if (formatVersion >= 5 || _needsFormat5 || _needsFormat6) ...{
      'sponsorIndustries': sponsorIndustries,
      'yHandles': yHandles,
    },
    // Written from format 6 on: a format-5 reader knows neither key.
    if (formatVersion >= 6 || _needsFormat6) ...{
      'addedReporters': [for (final r in addedReporters) r.toJson()],
      'addedStadiums': [for (final s in addedStadiums) s.toJson()],
    },
  };

  static const _keys = {
    'uuid',
    'name',
    'author',
    'formatVersion',
    'madeWithVersion',
    'squads',
    'nations',
    'clubs',
    'clubStrengths',
    'stadiums',
    'competitions',
    'yAccounts',
    'reporters',
    'nameLists',
    'sponsors',
    'trophies',
    'pools',
    'addedClubs',
    'addedSponsors',
    'addedYAccounts',
    'localized',
    'managers',
    'sponsorIndustries',
    'yHandles',
    'addedReporters',
    'addedStadiums',
  };

  /// Strict reader: any wrong type or unknown key throws [FormatException].
  /// Run [migrate] first on stored or imported JSON.
  static WorldPack fromJson(Map<String, Object?> json) {
    _only(json, _keys, 'pack');
    return WorldPack(
      uuid: _str(json['uuid'], 'uuid'),
      name: _str(json['name'], 'name'),
      author: _str(json['author'], 'author'),
      formatVersion: _int(json['formatVersion'], 'formatVersion'),
      madeWithVersion: _str(json['madeWithVersion'], 'madeWithVersion'),
      squads: {
        for (final e in _map(json['squads'], 'squads').entries)
          _intKey(e.key): _list(
            e.value,
            'squad',
          ).map(PackPlayer.fromJson).toList(),
      },
      nations: {
        for (final e in _map(json['nations'], 'nations').entries)
          _intKey(e.key): _nation(e.value),
      },
      clubs: _strMap(json['clubs'], 'clubs'),
      clubStrengths: {
        for (final e in _map(json['clubStrengths'], 'clubStrengths').entries)
          e.key: _int(e.value, 'clubStrengths'),
      },
      stadiums: _strMap(json['stadiums'], 'stadiums'),
      competitions: _strMap(json['competitions'], 'competitions'),
      yAccounts: _strMap(json['yAccounts'], 'yAccounts'),
      reporters: {
        for (final e in _map(json['reporters'], 'reporters').entries)
          _intKey(e.key): PackReporter.fromJson(e.value),
      },
      nameLists: {
        for (final e in _map(json['nameLists'], 'nameLists').entries)
          _intKey(e.key): PackNameLists.fromJson(e.value),
      },
      sponsors: _strMap(json['sponsors'], 'sponsors'),
      trophies: _strList(json['trophies'], 'trophies').toSet(),
      pools: {
        for (final e in _map(json['pools'], 'pools').entries)
          _intKey(e.key): _list(
            e.value,
            'pool',
          ).map(PackPlayer.fromJson).toList(),
      },
      addedClubs: _list(
        json['addedClubs'],
        'addedClubs',
      ).map(PackClub.fromJson).toList(),
      addedSponsors: _list(
        json['addedSponsors'],
        'addedSponsors',
      ).map(PackSponsor.fromJson).toList(),
      addedYAccounts: _list(
        json['addedYAccounts'],
        'addedYAccounts',
      ).map(PackYAccount.fromJson).toList(),
      localized: {
        for (final e in _map(json['localized'], 'localized').entries)
          e.key: _strMap(e.value, 'localized'),
      },
      managers: {
        for (final e in _map(json['managers'], 'managers').entries)
          _intKey(e.key): _manager(e.value),
      },
      sponsorIndustries: _strMap(
        json['sponsorIndustries'],
        'sponsorIndustries',
      ),
      yHandles: _strMap(json['yHandles'], 'yHandles'),
      addedReporters: _list(
        json['addedReporters'],
        'addedReporters',
      ).map(PackAddedReporter.fromJson).toList(),
      addedStadiums: _list(
        json['addedStadiums'],
        'addedStadiums',
      ).map(PackStadium.fromJson).toList(),
    );
  }

  /// Upgrades older JSON step by step to [kPackFormatVersion]. Identity at v6
  /// for a pack naming no renamed club ([_retiredClubs]).
  /// Throws [FormatException] for a missing or newer version. Never changes
  /// [json] itself.
  static Map<String, Object?> migrate(Map<String, Object?> json) {
    final v = json['formatVersion'];
    if (v is! int) {
      throw const FormatException('Pack has no valid formatVersion');
    }
    if (v > kPackFormatVersion) {
      throw FormatException(
        'Pack format $v is newer than supported $kPackFormatVersion',
      );
    }
    if (v < 1) {
      throw FormatException('Invalid pack format $v');
    }
    var out = json;
    if (v == 1) out = _from1To2(out);
    if (v <= 2) out = _from2To3(out);
    if (v <= 3) out = _from3To4(out, v);
    if (v <= 4) out = _from4To5(out, v);
    if (v <= 5) out = _from5To6(out, v);
    return _retiredClubs(out);
  }

  /// [json] with every league club the game has since renamed
  /// ([ClubService.retiredNames]) under its new name: the keys of `clubs`,
  /// `clubStrengths` and the `clubs.` paths of `localized`, and the club of
  /// every squad and pool player. A key already under the new name wins.
  /// [json] itself when it names none, so a current pack is untouched.
  static Map<String, Object?> _retiredClubs(Map<String, Object?> json) {
    const retired = ClubService.retiredNames;
    var changed = false;

    Object? keys(Object? m, String Function(String) rename) {
      if (m is! Map) return m;
      if (!m.keys.any((k) => k is String && rename(k) != k)) return m;
      changed = true;
      final out = <String, Object?>{};
      for (final e in m.entries) {
        final k = e.key as String;
        if (rename(k) == k) out[k] = e.value;
      }
      for (final e in m.entries) {
        final k = e.key as String;
        if (rename(k) != k) out.putIfAbsent(rename(k), () => e.value);
      }
      return out;
    }

    Object? players(Object? m) {
      if (m is! Map) return m;
      if (!m.values.any(
        (l) =>
            l is List && l.any((p) => p is Map && retired[p['club']] != null),
      )) {
        return m;
      }
      changed = true;
      return {
        for (final e in m.entries)
          e.key: e.value is List
              ? [
                  for (final p in e.value as List)
                    if (p is Map && retired[p['club']] != null)
                      {...p, 'club': retired[p['club']]}
                    else
                      p,
                ]
              : e.value,
      };
    }

    String club(String k) => retired[k] ?? k;
    String path(String k) => k.startsWith('clubs.')
        ? 'clubs.${club(k.substring('clubs.'.length))}'
        : k;

    final out = {
      ...json,
      if (json.containsKey('clubs')) 'clubs': keys(json['clubs'], club),
      if (json.containsKey('clubStrengths'))
        'clubStrengths': keys(json['clubStrengths'], club),
      if (json.containsKey('localized'))
        'localized': keys(json['localized'], path),
      if (json.containsKey('squads')) 'squads': players(json['squads']),
      if (json.containsKey('pools')) 'pools': players(json['pools']),
    };
    return changed ? out : json;
  }

  /// Format 2 to 3: no club strengths set, so a format-2 pack reads as
  /// "every club at its default strength". A format-2 pack that already
  /// holds a format-3 key is not a format-2 file.
  static Map<String, Object?> _from2To3(Map<String, Object?> json) {
    if (json.containsKey('clubStrengths')) {
      throw const FormatException('Format 2 pack has format 3 key');
    }
    final clubs = json['addedClubs'];
    if (clubs is List &&
        clubs.any((c) => c is Map && c.containsKey('strength'))) {
      throw const FormatException('Format 2 pack has a club strength');
    }
    return {
      ...json,
      'clubStrengths': <String, Object?>{},
      'formatVersion': 3,
    };
  }

  /// Format 1 (1.1.0) to 2: every new part empty, so a 1.1.0 pack reads as
  /// "nothing new". A format-1 pack that already holds a format-2 key is
  /// not a 1.1.0 file.
  static Map<String, Object?> _from1To2(Map<String, Object?> json) {
    final added = <String, Object?>{
      'pools': <String, Object?>{},
      'addedClubs': <Object?>[],
      'addedSponsors': <Object?>[],
      'addedYAccounts': <Object?>[],
      'localized': <String, Object?>{},
    };
    for (final k in added.keys) {
      if (json.containsKey(k)) {
        throw FormatException('Format 1 pack has format 2 key "$k"');
      }
    }
    return {...json, ...added, 'formatVersion': 2};
  }

  /// Format 3 to 4: no managers, so the world's day-one managers are all the
  /// game's own. A pack of format [from] (1, 2 or 3) that already holds
  /// `managers` is not a file of that format.
  static Map<String, Object?> _from3To4(Map<String, Object?> json, int from) {
    if (json.containsKey('managers')) {
      throw FormatException(
        'Format $from pack has the format 4 key "managers"',
      );
    }
    return {...json, 'managers': <String, Object?>{}, 'formatVersion': 4};
  }

  static Map<String, Object?> _from4To5(Map<String, Object?> json, int from) {
    if (json.containsKey('sponsorIndustries') || json.containsKey('yHandles')) {
      throw FormatException('Format $from pack has a format 5 key');
    }
    // A format-4 account has no handle key; it reads as it did.
    return {
      ...json,
      'sponsorIndustries': <String, Object?>{},
      'yHandles': <String, Object?>{},
      'formatVersion': 5,
    };
  }

  /// Format 5 to 6: no reporters or stadiums added. A pack of format [from]
  /// that already holds either key is not a file of that format.
  static Map<String, Object?> _from5To6(Map<String, Object?> json, int from) {
    if (json.containsKey('addedReporters') ||
        json.containsKey('addedStadiums')) {
      throw FormatException('Format $from pack has a format 6 key');
    }
    return {
      ...json,
      'addedReporters': <Object?>[],
      'addedStadiums': <Object?>[],
      'formatVersion': 6,
    };
  }

  static ({String name, String nationality}) _manager(Object? raw) {
    final m = _map(raw, 'manager');
    _only(m, const {'name', 'nationality'}, 'manager');
    return (
      name: _str(m['name'], 'name'),
      nationality: _str(m['nationality'], 'nationality'),
    );
  }

  static ({String name, String code}) _nation(Object? raw) {
    final m = _map(raw, 'nation');
    _only(m, const {'name', 'code'}, 'nation');
    return (name: _str(m['name'], 'name'), code: _str(m['code'], 'code'));
  }

  @override
  bool operator ==(Object other) =>
      other is WorldPack && _eq.equals(other.toJson(), toJson());

  @override
  int get hashCode => _eq.hash(toJson());
}

Map<String, Object?> _map(Object? v, String what) {
  if (v is Map<String, Object?>) return v;
  if (v is Map) {
    if (v.keys.every((k) => k is String)) return v.cast<String, Object?>();
  }
  throw FormatException('Expected an object for $what');
}

List<Object?> _list(Object? v, String what) {
  if (v is List) return v.cast<Object?>();
  throw FormatException('Expected a list for $what');
}

String _str(Object? v, String what) {
  if (v is String) return v;
  throw FormatException('Expected a string for $what');
}

String? _strOrNull(Object? v, String what) => v == null ? null : _str(v, what);

final _tokenShape = RegExp(r'^[a-zA-Z][a-zA-Z0-9]{0,39}$');

/// [name] when it is shaped like an enum name (1 to 40 ASCII letters and
/// digits, a letter first: `u21Star`),
/// whether or not this build knows it; a [FormatException] naming [what]
/// otherwise. A name this build does not know is kept and flagged, never
/// refused: files travel between newer and older games.
String _token(String name, String what) => _tokenShape.hasMatch(name)
    ? name
    : throw FormatException('Badly shaped $what');

int _int(Object? v, String what) {
  if (v is int) return v;
  throw FormatException('Expected an integer for $what');
}

/// [k] as an id: only an integer written the one way `toJson` writes it
/// ("7", never "07", "+7" or " 7"), so two keys never name one id.
int _intKey(String k) {
  final n = int.tryParse(k);
  if (n == null || '$n' != k) throw FormatException('Non-numeric key "$k"');
  return n;
}

List<String> _strList(Object? v, String what) => [
  for (final e in _list(v, what)) _str(e, what),
];

Map<String, String> _strMap(Object? v, String what) => {
  for (final e in _map(v, what).entries) e.key: _str(e.value, what),
};

void _only(Map<String, Object?> m, Set<String> allowed, String what) {
  for (final k in m.keys) {
    if (!allowed.contains(k)) {
      throw FormatException('Unknown key "$k" in $what');
    }
  }
}
