// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerAttributes _$PlayerAttributesFromJson(Map<String, dynamic> json) =>
    _PlayerAttributes(
      passing: (json['passing'] as num).toInt(),
      shooting: (json['shooting'] as num).toInt(),
      dribbling: (json['dribbling'] as num).toInt(),
      tackling: (json['tackling'] as num).toInt(),
      positioning: (json['positioning'] as num).toInt(),
      composure: (json['composure'] as num).toInt(),
      decisions: (json['decisions'] as num).toInt(),
      pace: (json['pace'] as num).toInt(),
      stamina: (json['stamina'] as num).toInt(),
      strength: (json['strength'] as num).toInt(),
    );

Map<String, dynamic> _$PlayerAttributesToJson(_PlayerAttributes instance) =>
    <String, dynamic>{
      'passing': instance.passing,
      'shooting': instance.shooting,
      'dribbling': instance.dribbling,
      'tackling': instance.tackling,
      'positioning': instance.positioning,
      'composure': instance.composure,
      'decisions': instance.decisions,
      'pace': instance.pace,
      'stamina': instance.stamina,
      'strength': instance.strength,
    };
