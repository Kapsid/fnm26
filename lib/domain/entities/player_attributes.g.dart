// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerAttributes _$PlayerAttributesFromJson(Map<String, dynamic> json) =>
    _PlayerAttributes(
      physical: (json['physical'] as num).toInt(),
      technical: (json['technical'] as num).toInt(),
      stamina: (json['stamina'] as num).toInt(),
    );

Map<String, dynamic> _$PlayerAttributesToJson(_PlayerAttributes instance) =>
    <String, dynamic>{
      'physical': instance.physical,
      'technical': instance.technical,
      'stamina': instance.stamina,
    };
