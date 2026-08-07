// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_attributes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerAttributes {

 int get physical; int get technical; int get stamina;
/// Create a copy of PlayerAttributes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerAttributesCopyWith<PlayerAttributes> get copyWith => _$PlayerAttributesCopyWithImpl<PlayerAttributes>(this as PlayerAttributes, _$identity);

  /// Serializes this PlayerAttributes to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerAttributes&&(identical(other.physical, physical) || other.physical == physical)&&(identical(other.technical, technical) || other.technical == technical)&&(identical(other.stamina, stamina) || other.stamina == stamina));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,physical,technical,stamina);

@override
String toString() {
  return 'PlayerAttributes(physical: $physical, technical: $technical, stamina: $stamina)';
}


}

/// @nodoc
abstract mixin class $PlayerAttributesCopyWith<$Res>  {
  factory $PlayerAttributesCopyWith(PlayerAttributes value, $Res Function(PlayerAttributes) _then) = _$PlayerAttributesCopyWithImpl;
@useResult
$Res call({
 int physical, int technical, int stamina
});




}
/// @nodoc
class _$PlayerAttributesCopyWithImpl<$Res>
    implements $PlayerAttributesCopyWith<$Res> {
  _$PlayerAttributesCopyWithImpl(this._self, this._then);

  final PlayerAttributes _self;
  final $Res Function(PlayerAttributes) _then;

/// Create a copy of PlayerAttributes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? physical = null,Object? technical = null,Object? stamina = null,}) {
  return _then(_self.copyWith(
physical: null == physical ? _self.physical : physical // ignore: cast_nullable_to_non_nullable
as int,technical: null == technical ? _self.technical : technical // ignore: cast_nullable_to_non_nullable
as int,stamina: null == stamina ? _self.stamina : stamina // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerAttributes].
extension PlayerAttributesPatterns on PlayerAttributes {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerAttributes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerAttributes() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerAttributes value)  $default,){
final _that = this;
switch (_that) {
case _PlayerAttributes():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerAttributes value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerAttributes() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int physical,  int technical,  int stamina)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerAttributes() when $default != null:
return $default(_that.physical,_that.technical,_that.stamina);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int physical,  int technical,  int stamina)  $default,) {final _that = this;
switch (_that) {
case _PlayerAttributes():
return $default(_that.physical,_that.technical,_that.stamina);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int physical,  int technical,  int stamina)?  $default,) {final _that = this;
switch (_that) {
case _PlayerAttributes() when $default != null:
return $default(_that.physical,_that.technical,_that.stamina);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerAttributes extends PlayerAttributes {
  const _PlayerAttributes({required this.physical, required this.technical, required this.stamina}): super._();
  factory _PlayerAttributes.fromJson(Map<String, dynamic> json) => _$PlayerAttributesFromJson(json);

@override final  int physical;
@override final  int technical;
@override final  int stamina;

/// Create a copy of PlayerAttributes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerAttributesCopyWith<_PlayerAttributes> get copyWith => __$PlayerAttributesCopyWithImpl<_PlayerAttributes>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerAttributesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerAttributes&&(identical(other.physical, physical) || other.physical == physical)&&(identical(other.technical, technical) || other.technical == technical)&&(identical(other.stamina, stamina) || other.stamina == stamina));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,physical,technical,stamina);

@override
String toString() {
  return 'PlayerAttributes(physical: $physical, technical: $technical, stamina: $stamina)';
}


}

/// @nodoc
abstract mixin class _$PlayerAttributesCopyWith<$Res> implements $PlayerAttributesCopyWith<$Res> {
  factory _$PlayerAttributesCopyWith(_PlayerAttributes value, $Res Function(_PlayerAttributes) _then) = __$PlayerAttributesCopyWithImpl;
@override @useResult
$Res call({
 int physical, int technical, int stamina
});




}
/// @nodoc
class __$PlayerAttributesCopyWithImpl<$Res>
    implements _$PlayerAttributesCopyWith<$Res> {
  __$PlayerAttributesCopyWithImpl(this._self, this._then);

  final _PlayerAttributes _self;
  final $Res Function(_PlayerAttributes) _then;

/// Create a copy of PlayerAttributes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? physical = null,Object? technical = null,Object? stamina = null,}) {
  return _then(_PlayerAttributes(
physical: null == physical ? _self.physical : physical // ignore: cast_nullable_to_non_nullable
as int,technical: null == technical ? _self.technical : technical // ignore: cast_nullable_to_non_nullable
as int,stamina: null == stamina ? _self.stamina : stamina // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
