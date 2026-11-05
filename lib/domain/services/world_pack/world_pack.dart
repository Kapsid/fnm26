import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../../entities/enums.dart';
import '../../entities/player_attributes.dart';

/// Current on-disk format of a world pack.
const int kPackFormatVersion = 1;

/// Ids at or above this belong to players created in a pack.
const int kPackPlayerIdBase = 800000000;

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
  });

  final int id;
  final String name;
  final int age;
  final PlayerPosition position;
  final PlayerAttributes attributes;
  final int potential;
  final String? club;
  final String? clubCountry;

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
    }, 'player');
    final a = _map(m['attributes'], 'attributes');
    _only(a, const {'physical', 'technical', 'stamina'}, 'attributes');
    final positionName = _str(m['position'], 'position');
    final position = PlayerPosition.values.asNameMap()[positionName];
    if (position == null) {
      throw FormatException('Unknown position "$positionName"');
    }
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
      other.clubCountry == clubCountry;

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
  );
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
    );
  }

  /// Upgrades older JSON step by step to [kPackFormatVersion]. Identity at v1.
  /// Throws [FormatException] for a missing or newer version.
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
    // Future steps: while (v < kPackFormatVersion) { json = _fromNToN1(json); }
    return json;
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

int _int(Object? v, String what) {
  if (v is int) return v;
  throw FormatException('Expected an integer for $what');
}

int _intKey(String k) {
  final n = int.tryParse(k);
  if (n == null) throw FormatException('Non-numeric key "$k"');
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
