// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Player _$PlayerFromJson(Map<String, dynamic> json) => _Player(
  id: (json['id'] as num).toInt(),
  nationId: (json['nationId'] as num).toInt(),
  name: json['name'] as String,
  age: (json['age'] as num).toInt(),
  position: $enumDecode(_$PlayerPositionEnumMap, json['position']),
  attributes: PlayerAttributes.fromJson(
    json['attributes'] as Map<String, dynamic>,
  ),
  club: json['club'] as String? ?? 'Free agent',
  clubCountry: json['clubCountry'] as String? ?? '',
  clubStars: (json['clubStars'] as num?)?.toInt() ?? 0,
  fixedTraits: (json['fixedTraits'] as List<dynamic>?)
      ?.map((e) => $enumDecode(_$PlayerTraitEnumMap, e))
      .toList(),
);

Map<String, dynamic> _$PlayerToJson(_Player instance) => <String, dynamic>{
  'id': instance.id,
  'nationId': instance.nationId,
  'name': instance.name,
  'age': instance.age,
  'position': _$PlayerPositionEnumMap[instance.position]!,
  'attributes': instance.attributes,
  'club': instance.club,
  'clubCountry': instance.clubCountry,
  'clubStars': instance.clubStars,
  'fixedTraits': ?instance.fixedTraits
      ?.map((e) => _$PlayerTraitEnumMap[e]!)
      .toList(),
};

const _$PlayerPositionEnumMap = {
  PlayerPosition.gk: 'gk',
  PlayerPosition.lb: 'lb',
  PlayerPosition.cb: 'cb',
  PlayerPosition.rb: 'rb',
  PlayerPosition.dm: 'dm',
  PlayerPosition.cm: 'cm',
  PlayerPosition.am: 'am',
  PlayerPosition.lm: 'lm',
  PlayerPosition.rm: 'rm',
  PlayerPosition.lw: 'lw',
  PlayerPosition.rw: 'rw',
  PlayerPosition.st: 'st',
};

const _$PlayerTraitEnumMap = {
  PlayerTrait.bigGame: 'bigGame',
  PlayerTrait.setPiece: 'setPiece',
  PlayerTrait.hothead: 'hothead',
  PlayerTrait.ironMan: 'ironMan',
  PlayerTrait.wonderkid: 'wonderkid',
  PlayerTrait.leader: 'leader',
  PlayerTrait.pacey: 'pacey',
  PlayerTrait.oldHead: 'oldHead',
  PlayerTrait.wasteful: 'wasteful',
};
