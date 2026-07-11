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
);

Map<String, dynamic> _$PlayerToJson(_Player instance) => <String, dynamic>{
  'id': instance.id,
  'nationId': instance.nationId,
  'name': instance.name,
  'age': instance.age,
  'position': _$PlayerPositionEnumMap[instance.position]!,
  'attributes': instance.attributes,
  'club': instance.club,
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
