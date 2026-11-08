import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../../entities/enums.dart';
import '../../entities/player_attributes.dart';
import '../federation/sponsors.dart';
import '../player/player_traits.dart';
import '../press/y_feed.dart';

/// Current on-disk format of a world pack. Format 2 (editor 2) adds
/// [WorldPack.pools], the added clubs, sponsors and Y accounts,
/// [WorldPack.localized] and [PackPlayer.traits]; [WorldPack.migrate] lifts
/// a format-1 (1.1.0) pack to it. Format 3 (world managers) adds
/// [WorldPack.managers]. Format 4 is reserved for clubs.
const int kPackFormatVersion = 3;

/// Ids at or above this belong to players created in a pack.
const int kPackPlayerIdBase = 800000000;

/// The id range of the clubs, sponsors and Y accounts a pack adds.
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

/// A club a pack adds. [country] is a lower-case FIFA code.
@immutable
class PackClub {
  const PackClub({required this.id, required this.name, required this.country});

  final int id;
  final String name;
  final String country;

  Map<String, Object?> toJson() => {'id': id, 'name': name, 'country': country};

  static PackClub fromJson(Object? raw) {
    final m = _map(raw, 'club');
    _only(m, const {'id', 'name', 'country'}, 'club');
    return PackClub(
      id: _int(m['id'], 'id'),
      name: _str(m['name'], 'name'),
      country: _str(m['country'], 'country'),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PackClub &&
      other.id == id &&
      other.name == name &&
      other.country == country;

  @override
  int get hashCode => Object.hash(id, name, country);
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
  });

  final int id;
  final String name;
  final YVoice voice;
  final int? nationId;

  /// The voice name the file gave when it is not one of [kPackYVoices] in
  /// this build, kept so the file travels on unchanged; [voice] is then
  /// [fallbackVoice]. The editor flags it (`PackRules.compatibility`), and
  /// Remove keeps [fallbackVoice] ([withoutUnknown]).
  final String? unknownVoice;

  /// The voice an unknown one reads as: the plain observer's.
  static const YVoice fallbackVoice = YVoice.neutral;

  /// This account with [unknownVoice] dropped: its voice is [voice].
  PackYAccount withoutUnknown() =>
      PackYAccount(id: id, name: name, voice: voice, nationId: nationId);

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'voice': unknownVoice ?? voice.name,
    'nationId': nationId,
  };

  static PackYAccount fromJson(Object? raw) {
    final m = _map(raw, 'yAccount');
    _only(m, const {'id', 'name', 'voice', 'nationId'}, 'yAccount');
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
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PackYAccount &&
      other.id == id &&
      other.name == name &&
      other.voice == voice &&
      other.nationId == nationId &&
      other.unknownVoice == unknownVoice;

  @override
  int get hashCode => Object.hash(id, name, voice, nationId, unknownVoice);
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

  WorldPack copyWith({
    String? uuid,
    String? name,
    String? author,
    int? formatVersion,
    String? madeWithVersion,
    Map<int, List<PackPlayer>>? squads,
    Map<int, ({String name, String code})>? nations,
    Map<String, String>? clubs,
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
  }) => WorldPack(
    uuid: uuid ?? this.uuid,
    name: name ?? this.name,
    author: author ?? this.author,
    formatVersion: formatVersion ?? this.formatVersion,
    madeWithVersion: madeWithVersion ?? this.madeWithVersion,
    squads: squads ?? this.squads,
    nations: nations ?? this.nations,
    clubs: clubs ?? this.clubs,
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
    'managers': {
      for (final e in managers.entries)
        '${e.key}': {
          'name': e.value.name,
          'nationality': e.value.nationality,
        },
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
    );
  }

  /// Upgrades older JSON step by step to [kPackFormatVersion]. Identity at v3.
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
    return out;
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

  /// Format 2 to 3: no managers, so the world's day-one managers are all the
  /// game's own. A format-2 pack that already holds `managers` is not a
  /// format-2 file.
  static Map<String, Object?> _from2To3(Map<String, Object?> json) {
    if (json.containsKey('managers')) {
      throw const FormatException('Format 2 pack has format 3 key "managers"');
    }
    return {...json, 'managers': <String, Object?>{}, 'formatVersion': 3};
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
