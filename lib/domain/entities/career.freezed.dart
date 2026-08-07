// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'career.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Career {

 int get id; String get managerName; int get nationId; int get rngSeed; DateTime get createdAt; DateTime get inGameDate; int get cyclePointer;/// Real-world timestamp of the last time this save was opened. Drives the
/// "last played" line on the saves list and its most-recent-first order.
/// Null only for saves written before the field existed.
 DateTime? get lastPlayedAt;/// The federation's cash balance (euros), spent on department investments
/// and replenished each cycle by central funding, prize money and
/// commercial returns. Player-driven mutable state (not seed-derived).
 int get budget;/// The player wearing the armband, or null if the manager has not named a
/// captain. Only ever a player in the current squad — see `Captaincy`.
 int? get captainPlayerId;
/// Create a copy of Career
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareerCopyWith<Career> get copyWith => _$CareerCopyWithImpl<Career>(this as Career, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Career&&(identical(other.id, id) || other.id == id)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.nationId, nationId) || other.nationId == nationId)&&(identical(other.rngSeed, rngSeed) || other.rngSeed == rngSeed)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.inGameDate, inGameDate) || other.inGameDate == inGameDate)&&(identical(other.cyclePointer, cyclePointer) || other.cyclePointer == cyclePointer)&&(identical(other.lastPlayedAt, lastPlayedAt) || other.lastPlayedAt == lastPlayedAt)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.captainPlayerId, captainPlayerId) || other.captainPlayerId == captainPlayerId));
}


@override
int get hashCode => Object.hash(runtimeType,id,managerName,nationId,rngSeed,createdAt,inGameDate,cyclePointer,lastPlayedAt,budget,captainPlayerId);

@override
String toString() {
  return 'Career(id: $id, managerName: $managerName, nationId: $nationId, rngSeed: $rngSeed, createdAt: $createdAt, inGameDate: $inGameDate, cyclePointer: $cyclePointer, lastPlayedAt: $lastPlayedAt, budget: $budget, captainPlayerId: $captainPlayerId)';
}


}

/// @nodoc
abstract mixin class $CareerCopyWith<$Res>  {
  factory $CareerCopyWith(Career value, $Res Function(Career) _then) = _$CareerCopyWithImpl;
@useResult
$Res call({
 int id, String managerName, int nationId, int rngSeed, DateTime createdAt, DateTime inGameDate, int cyclePointer, DateTime? lastPlayedAt, int budget, int? captainPlayerId
});




}
/// @nodoc
class _$CareerCopyWithImpl<$Res>
    implements $CareerCopyWith<$Res> {
  _$CareerCopyWithImpl(this._self, this._then);

  final Career _self;
  final $Res Function(Career) _then;

/// Create a copy of Career
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? managerName = null,Object? nationId = null,Object? rngSeed = null,Object? createdAt = null,Object? inGameDate = null,Object? cyclePointer = null,Object? lastPlayedAt = freezed,Object? budget = null,Object? captainPlayerId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,managerName: null == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String,nationId: null == nationId ? _self.nationId : nationId // ignore: cast_nullable_to_non_nullable
as int,rngSeed: null == rngSeed ? _self.rngSeed : rngSeed // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,inGameDate: null == inGameDate ? _self.inGameDate : inGameDate // ignore: cast_nullable_to_non_nullable
as DateTime,cyclePointer: null == cyclePointer ? _self.cyclePointer : cyclePointer // ignore: cast_nullable_to_non_nullable
as int,lastPlayedAt: freezed == lastPlayedAt ? _self.lastPlayedAt : lastPlayedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int,captainPlayerId: freezed == captainPlayerId ? _self.captainPlayerId : captainPlayerId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Career].
extension CareerPatterns on Career {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Career value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Career() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Career value)  $default,){
final _that = this;
switch (_that) {
case _Career():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Career value)?  $default,){
final _that = this;
switch (_that) {
case _Career() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String managerName,  int nationId,  int rngSeed,  DateTime createdAt,  DateTime inGameDate,  int cyclePointer,  DateTime? lastPlayedAt,  int budget,  int? captainPlayerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Career() when $default != null:
return $default(_that.id,_that.managerName,_that.nationId,_that.rngSeed,_that.createdAt,_that.inGameDate,_that.cyclePointer,_that.lastPlayedAt,_that.budget,_that.captainPlayerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String managerName,  int nationId,  int rngSeed,  DateTime createdAt,  DateTime inGameDate,  int cyclePointer,  DateTime? lastPlayedAt,  int budget,  int? captainPlayerId)  $default,) {final _that = this;
switch (_that) {
case _Career():
return $default(_that.id,_that.managerName,_that.nationId,_that.rngSeed,_that.createdAt,_that.inGameDate,_that.cyclePointer,_that.lastPlayedAt,_that.budget,_that.captainPlayerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String managerName,  int nationId,  int rngSeed,  DateTime createdAt,  DateTime inGameDate,  int cyclePointer,  DateTime? lastPlayedAt,  int budget,  int? captainPlayerId)?  $default,) {final _that = this;
switch (_that) {
case _Career() when $default != null:
return $default(_that.id,_that.managerName,_that.nationId,_that.rngSeed,_that.createdAt,_that.inGameDate,_that.cyclePointer,_that.lastPlayedAt,_that.budget,_that.captainPlayerId);case _:
  return null;

}
}

}

/// @nodoc


class _Career implements Career {
  const _Career({required this.id, required this.managerName, required this.nationId, required this.rngSeed, required this.createdAt, required this.inGameDate, this.cyclePointer = 0, this.lastPlayedAt, this.budget = 0, this.captainPlayerId});
  

@override final  int id;
@override final  String managerName;
@override final  int nationId;
@override final  int rngSeed;
@override final  DateTime createdAt;
@override final  DateTime inGameDate;
@override@JsonKey() final  int cyclePointer;
/// Real-world timestamp of the last time this save was opened. Drives the
/// "last played" line on the saves list and its most-recent-first order.
/// Null only for saves written before the field existed.
@override final  DateTime? lastPlayedAt;
/// The federation's cash balance (euros), spent on department investments
/// and replenished each cycle by central funding, prize money and
/// commercial returns. Player-driven mutable state (not seed-derived).
@override@JsonKey() final  int budget;
/// The player wearing the armband, or null if the manager has not named a
/// captain. Only ever a player in the current squad — see `Captaincy`.
@override final  int? captainPlayerId;

/// Create a copy of Career
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareerCopyWith<_Career> get copyWith => __$CareerCopyWithImpl<_Career>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Career&&(identical(other.id, id) || other.id == id)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.nationId, nationId) || other.nationId == nationId)&&(identical(other.rngSeed, rngSeed) || other.rngSeed == rngSeed)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.inGameDate, inGameDate) || other.inGameDate == inGameDate)&&(identical(other.cyclePointer, cyclePointer) || other.cyclePointer == cyclePointer)&&(identical(other.lastPlayedAt, lastPlayedAt) || other.lastPlayedAt == lastPlayedAt)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.captainPlayerId, captainPlayerId) || other.captainPlayerId == captainPlayerId));
}


@override
int get hashCode => Object.hash(runtimeType,id,managerName,nationId,rngSeed,createdAt,inGameDate,cyclePointer,lastPlayedAt,budget,captainPlayerId);

@override
String toString() {
  return 'Career(id: $id, managerName: $managerName, nationId: $nationId, rngSeed: $rngSeed, createdAt: $createdAt, inGameDate: $inGameDate, cyclePointer: $cyclePointer, lastPlayedAt: $lastPlayedAt, budget: $budget, captainPlayerId: $captainPlayerId)';
}


}

/// @nodoc
abstract mixin class _$CareerCopyWith<$Res> implements $CareerCopyWith<$Res> {
  factory _$CareerCopyWith(_Career value, $Res Function(_Career) _then) = __$CareerCopyWithImpl;
@override @useResult
$Res call({
 int id, String managerName, int nationId, int rngSeed, DateTime createdAt, DateTime inGameDate, int cyclePointer, DateTime? lastPlayedAt, int budget, int? captainPlayerId
});




}
/// @nodoc
class __$CareerCopyWithImpl<$Res>
    implements _$CareerCopyWith<$Res> {
  __$CareerCopyWithImpl(this._self, this._then);

  final _Career _self;
  final $Res Function(_Career) _then;

/// Create a copy of Career
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? managerName = null,Object? nationId = null,Object? rngSeed = null,Object? createdAt = null,Object? inGameDate = null,Object? cyclePointer = null,Object? lastPlayedAt = freezed,Object? budget = null,Object? captainPlayerId = freezed,}) {
  return _then(_Career(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,managerName: null == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String,nationId: null == nationId ? _self.nationId : nationId // ignore: cast_nullable_to_non_nullable
as int,rngSeed: null == rngSeed ? _self.rngSeed : rngSeed // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,inGameDate: null == inGameDate ? _self.inGameDate : inGameDate // ignore: cast_nullable_to_non_nullable
as DateTime,cyclePointer: null == cyclePointer ? _self.cyclePointer : cyclePointer // ignore: cast_nullable_to_non_nullable
as int,lastPlayedAt: freezed == lastPlayedAt ? _self.lastPlayedAt : lastPlayedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int,captainPlayerId: freezed == captainPlayerId ? _self.captainPlayerId : captainPlayerId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
