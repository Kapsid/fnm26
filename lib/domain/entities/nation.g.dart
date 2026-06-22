// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Nation _$NationFromJson(Map<String, dynamic> json) => _Nation(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  code: json['code'] as String,
  confederation: $enumDecode(_$ConfederationEnumMap, json['confederation']),
  ranking: (json['ranking'] as num).toInt(),
  isFreeDemo: json['isFreeDemo'] as bool? ?? false,
);

Map<String, dynamic> _$NationToJson(_Nation instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
  'confederation': _$ConfederationEnumMap[instance.confederation]!,
  'ranking': instance.ranking,
  'isFreeDemo': instance.isFreeDemo,
};

const _$ConfederationEnumMap = {
  Confederation.europe: 'europe',
  Confederation.southAmerica: 'southAmerica',
  Confederation.northAmerica: 'northAmerica',
  Confederation.africa: 'africa',
  Confederation.asia: 'asia',
  Confederation.oceania: 'oceania',
};
