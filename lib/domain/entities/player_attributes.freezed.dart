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

// Technical
 int get passing; int get shooting; int get dribbling; int get tackling;// Mental
 int get positioning; int get composure; int get decisions;// Physical
 int get pace; int get stamina; int get strength;
/// Create a copy of PlayerAttributes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerAttributesCopyWith<PlayerAttributes> get copyWith => _$PlayerAttributesCopyWithImpl<PlayerAttributes>(this as PlayerAttributes, _$identity);

  /// Serializes this PlayerAttributes to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerAttributes&&(identical(other.passing, passing) || other.passing == passing)&&(identical(other.shooting, shooting) || other.shooting == shooting)&&(identical(other.dribbling, dribbling) || other.dribbling == dribbling)&&(identical(other.tackling, tackling) || other.tackling == tackling)&&(identical(other.positioning, positioning) || other.positioning == positioning)&&(identical(other.composure, composure) || other.composure == composure)&&(identical(other.decisions, decisions) || other.decisions == decisions)&&(identical(other.pace, pace) || other.pace == pace)&&(identical(other.stamina, stamina) || other.stamina == stamina)&&(identical(other.strength, strength) || other.strength == strength));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,passing,shooting,dribbling,tackling,positioning,composure,decisions,pace,stamina,strength);

@override
String toString() {
  return 'PlayerAttributes(passing: $passing, shooting: $shooting, dribbling: $dribbling, tackling: $tackling, positioning: $positioning, composure: $composure, decisions: $decisions, pace: $pace, stamina: $stamina, strength: $strength)';
}


}

/// @nodoc
abstract mixin class $PlayerAttributesCopyWith<$Res>  {
  factory $PlayerAttributesCopyWith(PlayerAttributes value, $Res Function(PlayerAttributes) _then) = _$PlayerAttributesCopyWithImpl;
@useResult
$Res call({
 int passing, int shooting, int dribbling, int tackling, int positioning, int composure, int decisions, int pace, int stamina, int strength
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
@pragma('vm:prefer-inline') @override $Res call({Object? passing = null,Object? shooting = null,Object? dribbling = null,Object? tackling = null,Object? positioning = null,Object? composure = null,Object? decisions = null,Object? pace = null,Object? stamina = null,Object? strength = null,}) {
  return _then(_self.copyWith(
passing: null == passing ? _self.passing : passing // ignore: cast_nullable_to_non_nullable
as int,shooting: null == shooting ? _self.shooting : shooting // ignore: cast_nullable_to_non_nullable
as int,dribbling: null == dribbling ? _self.dribbling : dribbling // ignore: cast_nullable_to_non_nullable
as int,tackling: null == tackling ? _self.tackling : tackling // ignore: cast_nullable_to_non_nullable
as int,positioning: null == positioning ? _self.positioning : positioning // ignore: cast_nullable_to_non_nullable
as int,composure: null == composure ? _self.composure : composure // ignore: cast_nullable_to_non_nullable
as int,decisions: null == decisions ? _self.decisions : decisions // ignore: cast_nullable_to_non_nullable
as int,pace: null == pace ? _self.pace : pace // ignore: cast_nullable_to_non_nullable
as int,stamina: null == stamina ? _self.stamina : stamina // ignore: cast_nullable_to_non_nullable
as int,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int passing,  int shooting,  int dribbling,  int tackling,  int positioning,  int composure,  int decisions,  int pace,  int stamina,  int strength)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerAttributes() when $default != null:
return $default(_that.passing,_that.shooting,_that.dribbling,_that.tackling,_that.positioning,_that.composure,_that.decisions,_that.pace,_that.stamina,_that.strength);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int passing,  int shooting,  int dribbling,  int tackling,  int positioning,  int composure,  int decisions,  int pace,  int stamina,  int strength)  $default,) {final _that = this;
switch (_that) {
case _PlayerAttributes():
return $default(_that.passing,_that.shooting,_that.dribbling,_that.tackling,_that.positioning,_that.composure,_that.decisions,_that.pace,_that.stamina,_that.strength);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int passing,  int shooting,  int dribbling,  int tackling,  int positioning,  int composure,  int decisions,  int pace,  int stamina,  int strength)?  $default,) {final _that = this;
switch (_that) {
case _PlayerAttributes() when $default != null:
return $default(_that.passing,_that.shooting,_that.dribbling,_that.tackling,_that.positioning,_that.composure,_that.decisions,_that.pace,_that.stamina,_that.strength);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerAttributes extends PlayerAttributes {
  const _PlayerAttributes({required this.passing, required this.shooting, required this.dribbling, required this.tackling, required this.positioning, required this.composure, required this.decisions, required this.pace, required this.stamina, required this.strength}): super._();
  factory _PlayerAttributes.fromJson(Map<String, dynamic> json) => _$PlayerAttributesFromJson(json);

// Technical
@override final  int passing;
@override final  int shooting;
@override final  int dribbling;
@override final  int tackling;
// Mental
@override final  int positioning;
@override final  int composure;
@override final  int decisions;
// Physical
@override final  int pace;
@override final  int stamina;
@override final  int strength;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerAttributes&&(identical(other.passing, passing) || other.passing == passing)&&(identical(other.shooting, shooting) || other.shooting == shooting)&&(identical(other.dribbling, dribbling) || other.dribbling == dribbling)&&(identical(other.tackling, tackling) || other.tackling == tackling)&&(identical(other.positioning, positioning) || other.positioning == positioning)&&(identical(other.composure, composure) || other.composure == composure)&&(identical(other.decisions, decisions) || other.decisions == decisions)&&(identical(other.pace, pace) || other.pace == pace)&&(identical(other.stamina, stamina) || other.stamina == stamina)&&(identical(other.strength, strength) || other.strength == strength));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,passing,shooting,dribbling,tackling,positioning,composure,decisions,pace,stamina,strength);

@override
String toString() {
  return 'PlayerAttributes(passing: $passing, shooting: $shooting, dribbling: $dribbling, tackling: $tackling, positioning: $positioning, composure: $composure, decisions: $decisions, pace: $pace, stamina: $stamina, strength: $strength)';
}


}

/// @nodoc
abstract mixin class _$PlayerAttributesCopyWith<$Res> implements $PlayerAttributesCopyWith<$Res> {
  factory _$PlayerAttributesCopyWith(_PlayerAttributes value, $Res Function(_PlayerAttributes) _then) = __$PlayerAttributesCopyWithImpl;
@override @useResult
$Res call({
 int passing, int shooting, int dribbling, int tackling, int positioning, int composure, int decisions, int pace, int stamina, int strength
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
@override @pragma('vm:prefer-inline') $Res call({Object? passing = null,Object? shooting = null,Object? dribbling = null,Object? tackling = null,Object? positioning = null,Object? composure = null,Object? decisions = null,Object? pace = null,Object? stamina = null,Object? strength = null,}) {
  return _then(_PlayerAttributes(
passing: null == passing ? _self.passing : passing // ignore: cast_nullable_to_non_nullable
as int,shooting: null == shooting ? _self.shooting : shooting // ignore: cast_nullable_to_non_nullable
as int,dribbling: null == dribbling ? _self.dribbling : dribbling // ignore: cast_nullable_to_non_nullable
as int,tackling: null == tackling ? _self.tackling : tackling // ignore: cast_nullable_to_non_nullable
as int,positioning: null == positioning ? _self.positioning : positioning // ignore: cast_nullable_to_non_nullable
as int,composure: null == composure ? _self.composure : composure // ignore: cast_nullable_to_non_nullable
as int,decisions: null == decisions ? _self.decisions : decisions // ignore: cast_nullable_to_non_nullable
as int,pace: null == pace ? _self.pace : pace // ignore: cast_nullable_to_non_nullable
as int,stamina: null == stamina ? _self.stamina : stamina // ignore: cast_nullable_to_non_nullable
as int,strength: null == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
