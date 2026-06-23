// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fixture.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Fixture {

 int get id; int get careerId; int get competitionId; int get matchday; DateTime get date; int get homeNationId; int get awayNationId; int? get groupId; int? get homeScore; int? get awayScore; bool get played;
/// Create a copy of Fixture
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FixtureCopyWith<Fixture> get copyWith => _$FixtureCopyWithImpl<Fixture>(this as Fixture, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Fixture&&(identical(other.id, id) || other.id == id)&&(identical(other.careerId, careerId) || other.careerId == careerId)&&(identical(other.competitionId, competitionId) || other.competitionId == competitionId)&&(identical(other.matchday, matchday) || other.matchday == matchday)&&(identical(other.date, date) || other.date == date)&&(identical(other.homeNationId, homeNationId) || other.homeNationId == homeNationId)&&(identical(other.awayNationId, awayNationId) || other.awayNationId == awayNationId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.homeScore, homeScore) || other.homeScore == homeScore)&&(identical(other.awayScore, awayScore) || other.awayScore == awayScore)&&(identical(other.played, played) || other.played == played));
}


@override
int get hashCode => Object.hash(runtimeType,id,careerId,competitionId,matchday,date,homeNationId,awayNationId,groupId,homeScore,awayScore,played);

@override
String toString() {
  return 'Fixture(id: $id, careerId: $careerId, competitionId: $competitionId, matchday: $matchday, date: $date, homeNationId: $homeNationId, awayNationId: $awayNationId, groupId: $groupId, homeScore: $homeScore, awayScore: $awayScore, played: $played)';
}


}

/// @nodoc
abstract mixin class $FixtureCopyWith<$Res>  {
  factory $FixtureCopyWith(Fixture value, $Res Function(Fixture) _then) = _$FixtureCopyWithImpl;
@useResult
$Res call({
 int id, int careerId, int competitionId, int matchday, DateTime date, int homeNationId, int awayNationId, int? groupId, int? homeScore, int? awayScore, bool played
});




}
/// @nodoc
class _$FixtureCopyWithImpl<$Res>
    implements $FixtureCopyWith<$Res> {
  _$FixtureCopyWithImpl(this._self, this._then);

  final Fixture _self;
  final $Res Function(Fixture) _then;

/// Create a copy of Fixture
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? careerId = null,Object? competitionId = null,Object? matchday = null,Object? date = null,Object? homeNationId = null,Object? awayNationId = null,Object? groupId = freezed,Object? homeScore = freezed,Object? awayScore = freezed,Object? played = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,careerId: null == careerId ? _self.careerId : careerId // ignore: cast_nullable_to_non_nullable
as int,competitionId: null == competitionId ? _self.competitionId : competitionId // ignore: cast_nullable_to_non_nullable
as int,matchday: null == matchday ? _self.matchday : matchday // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,homeNationId: null == homeNationId ? _self.homeNationId : homeNationId // ignore: cast_nullable_to_non_nullable
as int,awayNationId: null == awayNationId ? _self.awayNationId : awayNationId // ignore: cast_nullable_to_non_nullable
as int,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,homeScore: freezed == homeScore ? _self.homeScore : homeScore // ignore: cast_nullable_to_non_nullable
as int?,awayScore: freezed == awayScore ? _self.awayScore : awayScore // ignore: cast_nullable_to_non_nullable
as int?,played: null == played ? _self.played : played // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Fixture].
extension FixturePatterns on Fixture {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Fixture value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Fixture() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Fixture value)  $default,){
final _that = this;
switch (_that) {
case _Fixture():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Fixture value)?  $default,){
final _that = this;
switch (_that) {
case _Fixture() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int careerId,  int competitionId,  int matchday,  DateTime date,  int homeNationId,  int awayNationId,  int? groupId,  int? homeScore,  int? awayScore,  bool played)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Fixture() when $default != null:
return $default(_that.id,_that.careerId,_that.competitionId,_that.matchday,_that.date,_that.homeNationId,_that.awayNationId,_that.groupId,_that.homeScore,_that.awayScore,_that.played);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int careerId,  int competitionId,  int matchday,  DateTime date,  int homeNationId,  int awayNationId,  int? groupId,  int? homeScore,  int? awayScore,  bool played)  $default,) {final _that = this;
switch (_that) {
case _Fixture():
return $default(_that.id,_that.careerId,_that.competitionId,_that.matchday,_that.date,_that.homeNationId,_that.awayNationId,_that.groupId,_that.homeScore,_that.awayScore,_that.played);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int careerId,  int competitionId,  int matchday,  DateTime date,  int homeNationId,  int awayNationId,  int? groupId,  int? homeScore,  int? awayScore,  bool played)?  $default,) {final _that = this;
switch (_that) {
case _Fixture() when $default != null:
return $default(_that.id,_that.careerId,_that.competitionId,_that.matchday,_that.date,_that.homeNationId,_that.awayNationId,_that.groupId,_that.homeScore,_that.awayScore,_that.played);case _:
  return null;

}
}

}

/// @nodoc


class _Fixture extends Fixture {
  const _Fixture({required this.id, required this.careerId, required this.competitionId, required this.matchday, required this.date, required this.homeNationId, required this.awayNationId, this.groupId, this.homeScore, this.awayScore, this.played = false}): super._();
  

@override final  int id;
@override final  int careerId;
@override final  int competitionId;
@override final  int matchday;
@override final  DateTime date;
@override final  int homeNationId;
@override final  int awayNationId;
@override final  int? groupId;
@override final  int? homeScore;
@override final  int? awayScore;
@override@JsonKey() final  bool played;

/// Create a copy of Fixture
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FixtureCopyWith<_Fixture> get copyWith => __$FixtureCopyWithImpl<_Fixture>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Fixture&&(identical(other.id, id) || other.id == id)&&(identical(other.careerId, careerId) || other.careerId == careerId)&&(identical(other.competitionId, competitionId) || other.competitionId == competitionId)&&(identical(other.matchday, matchday) || other.matchday == matchday)&&(identical(other.date, date) || other.date == date)&&(identical(other.homeNationId, homeNationId) || other.homeNationId == homeNationId)&&(identical(other.awayNationId, awayNationId) || other.awayNationId == awayNationId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.homeScore, homeScore) || other.homeScore == homeScore)&&(identical(other.awayScore, awayScore) || other.awayScore == awayScore)&&(identical(other.played, played) || other.played == played));
}


@override
int get hashCode => Object.hash(runtimeType,id,careerId,competitionId,matchday,date,homeNationId,awayNationId,groupId,homeScore,awayScore,played);

@override
String toString() {
  return 'Fixture(id: $id, careerId: $careerId, competitionId: $competitionId, matchday: $matchday, date: $date, homeNationId: $homeNationId, awayNationId: $awayNationId, groupId: $groupId, homeScore: $homeScore, awayScore: $awayScore, played: $played)';
}


}

/// @nodoc
abstract mixin class _$FixtureCopyWith<$Res> implements $FixtureCopyWith<$Res> {
  factory _$FixtureCopyWith(_Fixture value, $Res Function(_Fixture) _then) = __$FixtureCopyWithImpl;
@override @useResult
$Res call({
 int id, int careerId, int competitionId, int matchday, DateTime date, int homeNationId, int awayNationId, int? groupId, int? homeScore, int? awayScore, bool played
});




}
/// @nodoc
class __$FixtureCopyWithImpl<$Res>
    implements _$FixtureCopyWith<$Res> {
  __$FixtureCopyWithImpl(this._self, this._then);

  final _Fixture _self;
  final $Res Function(_Fixture) _then;

/// Create a copy of Fixture
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? careerId = null,Object? competitionId = null,Object? matchday = null,Object? date = null,Object? homeNationId = null,Object? awayNationId = null,Object? groupId = freezed,Object? homeScore = freezed,Object? awayScore = freezed,Object? played = null,}) {
  return _then(_Fixture(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,careerId: null == careerId ? _self.careerId : careerId // ignore: cast_nullable_to_non_nullable
as int,competitionId: null == competitionId ? _self.competitionId : competitionId // ignore: cast_nullable_to_non_nullable
as int,matchday: null == matchday ? _self.matchday : matchday // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,homeNationId: null == homeNationId ? _self.homeNationId : homeNationId // ignore: cast_nullable_to_non_nullable
as int,awayNationId: null == awayNationId ? _self.awayNationId : awayNationId // ignore: cast_nullable_to_non_nullable
as int,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int?,homeScore: freezed == homeScore ? _self.homeScore : homeScore // ignore: cast_nullable_to_non_nullable
as int?,awayScore: freezed == awayScore ? _self.awayScore : awayScore // ignore: cast_nullable_to_non_nullable
as int?,played: null == played ? _self.played : played // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
