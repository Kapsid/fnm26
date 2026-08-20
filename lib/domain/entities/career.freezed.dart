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
 int? get captainPlayerId;/// The in-game date of the newest Y post the manager has seen, or null if
/// he has never opened the feed. Posts are derived rather than stored, so
/// this watermark is what "unread" is counted against.
 DateTime? get yReadAt;/// Real-world seconds spent playing this save. Zero for a save that
/// predates the counter — its earlier hours were never measured, and
/// inventing a number for them would be worse than starting at nothing.
 int get playedSeconds;/// What the manager himself is good at, 1–20 apiece. All four start at
/// [ManagerSkills.starting], which every effect reads as neutral — so a
/// save that predates them is unaffected until a point is spent.
 int get skillManManagement; int get skillTactical; int get skillYouthDevelopment; int get skillNegotiation;/// The staff he has hired. Nobody, by default, which costs nothing.
 StaffTier get staffAssistant; StaffTier get staffScout; StaffTier get staffFitnessCoach;/// WHO is in each job, or null when the post is vacant. The tier above
/// stays the source of truth for every effect; this is the person.
 int? get staffAssistantId; int? get staffScoutId; int? get staffFitnessCoachId;/// Where the board's gauge finished the previous cycle, or null before a
/// cycle has closed.
 int? get lastCycleBoard;/// The international window the current squad was named for, or null when
/// no squad has been named yet.
 String? get callUpWindowId;
/// Create a copy of Career
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareerCopyWith<Career> get copyWith => _$CareerCopyWithImpl<Career>(this as Career, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Career&&(identical(other.id, id) || other.id == id)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.nationId, nationId) || other.nationId == nationId)&&(identical(other.rngSeed, rngSeed) || other.rngSeed == rngSeed)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.inGameDate, inGameDate) || other.inGameDate == inGameDate)&&(identical(other.cyclePointer, cyclePointer) || other.cyclePointer == cyclePointer)&&(identical(other.lastPlayedAt, lastPlayedAt) || other.lastPlayedAt == lastPlayedAt)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.captainPlayerId, captainPlayerId) || other.captainPlayerId == captainPlayerId)&&(identical(other.yReadAt, yReadAt) || other.yReadAt == yReadAt)&&(identical(other.playedSeconds, playedSeconds) || other.playedSeconds == playedSeconds)&&(identical(other.skillManManagement, skillManManagement) || other.skillManManagement == skillManManagement)&&(identical(other.skillTactical, skillTactical) || other.skillTactical == skillTactical)&&(identical(other.skillYouthDevelopment, skillYouthDevelopment) || other.skillYouthDevelopment == skillYouthDevelopment)&&(identical(other.skillNegotiation, skillNegotiation) || other.skillNegotiation == skillNegotiation)&&(identical(other.staffAssistant, staffAssistant) || other.staffAssistant == staffAssistant)&&(identical(other.staffScout, staffScout) || other.staffScout == staffScout)&&(identical(other.staffFitnessCoach, staffFitnessCoach) || other.staffFitnessCoach == staffFitnessCoach)&&(identical(other.staffAssistantId, staffAssistantId) || other.staffAssistantId == staffAssistantId)&&(identical(other.staffScoutId, staffScoutId) || other.staffScoutId == staffScoutId)&&(identical(other.staffFitnessCoachId, staffFitnessCoachId) || other.staffFitnessCoachId == staffFitnessCoachId)&&(identical(other.lastCycleBoard, lastCycleBoard) || other.lastCycleBoard == lastCycleBoard)&&(identical(other.callUpWindowId, callUpWindowId) || other.callUpWindowId == callUpWindowId));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,managerName,nationId,rngSeed,createdAt,inGameDate,cyclePointer,lastPlayedAt,budget,captainPlayerId,yReadAt,playedSeconds,skillManManagement,skillTactical,skillYouthDevelopment,skillNegotiation,staffAssistant,staffScout,staffFitnessCoach,staffAssistantId,staffScoutId,staffFitnessCoachId,lastCycleBoard,callUpWindowId]);

@override
String toString() {
  return 'Career(id: $id, managerName: $managerName, nationId: $nationId, rngSeed: $rngSeed, createdAt: $createdAt, inGameDate: $inGameDate, cyclePointer: $cyclePointer, lastPlayedAt: $lastPlayedAt, budget: $budget, captainPlayerId: $captainPlayerId, yReadAt: $yReadAt, playedSeconds: $playedSeconds, skillManManagement: $skillManManagement, skillTactical: $skillTactical, skillYouthDevelopment: $skillYouthDevelopment, skillNegotiation: $skillNegotiation, staffAssistant: $staffAssistant, staffScout: $staffScout, staffFitnessCoach: $staffFitnessCoach, staffAssistantId: $staffAssistantId, staffScoutId: $staffScoutId, staffFitnessCoachId: $staffFitnessCoachId, lastCycleBoard: $lastCycleBoard, callUpWindowId: $callUpWindowId)';
}


}

/// @nodoc
abstract mixin class $CareerCopyWith<$Res>  {
  factory $CareerCopyWith(Career value, $Res Function(Career) _then) = _$CareerCopyWithImpl;
@useResult
$Res call({
 int id, String managerName, int nationId, int rngSeed, DateTime createdAt, DateTime inGameDate, int cyclePointer, DateTime? lastPlayedAt, int budget, int? captainPlayerId, DateTime? yReadAt, int playedSeconds, int skillManManagement, int skillTactical, int skillYouthDevelopment, int skillNegotiation, StaffTier staffAssistant, StaffTier staffScout, StaffTier staffFitnessCoach, int? staffAssistantId, int? staffScoutId, int? staffFitnessCoachId, int? lastCycleBoard, String? callUpWindowId
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? managerName = null,Object? nationId = null,Object? rngSeed = null,Object? createdAt = null,Object? inGameDate = null,Object? cyclePointer = null,Object? lastPlayedAt = freezed,Object? budget = null,Object? captainPlayerId = freezed,Object? yReadAt = freezed,Object? playedSeconds = null,Object? skillManManagement = null,Object? skillTactical = null,Object? skillYouthDevelopment = null,Object? skillNegotiation = null,Object? staffAssistant = null,Object? staffScout = null,Object? staffFitnessCoach = null,Object? staffAssistantId = freezed,Object? staffScoutId = freezed,Object? staffFitnessCoachId = freezed,Object? lastCycleBoard = freezed,Object? callUpWindowId = freezed,}) {
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
as int?,yReadAt: freezed == yReadAt ? _self.yReadAt : yReadAt // ignore: cast_nullable_to_non_nullable
as DateTime?,playedSeconds: null == playedSeconds ? _self.playedSeconds : playedSeconds // ignore: cast_nullable_to_non_nullable
as int,skillManManagement: null == skillManManagement ? _self.skillManManagement : skillManManagement // ignore: cast_nullable_to_non_nullable
as int,skillTactical: null == skillTactical ? _self.skillTactical : skillTactical // ignore: cast_nullable_to_non_nullable
as int,skillYouthDevelopment: null == skillYouthDevelopment ? _self.skillYouthDevelopment : skillYouthDevelopment // ignore: cast_nullable_to_non_nullable
as int,skillNegotiation: null == skillNegotiation ? _self.skillNegotiation : skillNegotiation // ignore: cast_nullable_to_non_nullable
as int,staffAssistant: null == staffAssistant ? _self.staffAssistant : staffAssistant // ignore: cast_nullable_to_non_nullable
as StaffTier,staffScout: null == staffScout ? _self.staffScout : staffScout // ignore: cast_nullable_to_non_nullable
as StaffTier,staffFitnessCoach: null == staffFitnessCoach ? _self.staffFitnessCoach : staffFitnessCoach // ignore: cast_nullable_to_non_nullable
as StaffTier,staffAssistantId: freezed == staffAssistantId ? _self.staffAssistantId : staffAssistantId // ignore: cast_nullable_to_non_nullable
as int?,staffScoutId: freezed == staffScoutId ? _self.staffScoutId : staffScoutId // ignore: cast_nullable_to_non_nullable
as int?,staffFitnessCoachId: freezed == staffFitnessCoachId ? _self.staffFitnessCoachId : staffFitnessCoachId // ignore: cast_nullable_to_non_nullable
as int?,lastCycleBoard: freezed == lastCycleBoard ? _self.lastCycleBoard : lastCycleBoard // ignore: cast_nullable_to_non_nullable
as int?,callUpWindowId: freezed == callUpWindowId ? _self.callUpWindowId : callUpWindowId // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String managerName,  int nationId,  int rngSeed,  DateTime createdAt,  DateTime inGameDate,  int cyclePointer,  DateTime? lastPlayedAt,  int budget,  int? captainPlayerId,  DateTime? yReadAt,  int playedSeconds,  int skillManManagement,  int skillTactical,  int skillYouthDevelopment,  int skillNegotiation,  StaffTier staffAssistant,  StaffTier staffScout,  StaffTier staffFitnessCoach,  int? staffAssistantId,  int? staffScoutId,  int? staffFitnessCoachId,  int? lastCycleBoard,  String? callUpWindowId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Career() when $default != null:
return $default(_that.id,_that.managerName,_that.nationId,_that.rngSeed,_that.createdAt,_that.inGameDate,_that.cyclePointer,_that.lastPlayedAt,_that.budget,_that.captainPlayerId,_that.yReadAt,_that.playedSeconds,_that.skillManManagement,_that.skillTactical,_that.skillYouthDevelopment,_that.skillNegotiation,_that.staffAssistant,_that.staffScout,_that.staffFitnessCoach,_that.staffAssistantId,_that.staffScoutId,_that.staffFitnessCoachId,_that.lastCycleBoard,_that.callUpWindowId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String managerName,  int nationId,  int rngSeed,  DateTime createdAt,  DateTime inGameDate,  int cyclePointer,  DateTime? lastPlayedAt,  int budget,  int? captainPlayerId,  DateTime? yReadAt,  int playedSeconds,  int skillManManagement,  int skillTactical,  int skillYouthDevelopment,  int skillNegotiation,  StaffTier staffAssistant,  StaffTier staffScout,  StaffTier staffFitnessCoach,  int? staffAssistantId,  int? staffScoutId,  int? staffFitnessCoachId,  int? lastCycleBoard,  String? callUpWindowId)  $default,) {final _that = this;
switch (_that) {
case _Career():
return $default(_that.id,_that.managerName,_that.nationId,_that.rngSeed,_that.createdAt,_that.inGameDate,_that.cyclePointer,_that.lastPlayedAt,_that.budget,_that.captainPlayerId,_that.yReadAt,_that.playedSeconds,_that.skillManManagement,_that.skillTactical,_that.skillYouthDevelopment,_that.skillNegotiation,_that.staffAssistant,_that.staffScout,_that.staffFitnessCoach,_that.staffAssistantId,_that.staffScoutId,_that.staffFitnessCoachId,_that.lastCycleBoard,_that.callUpWindowId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String managerName,  int nationId,  int rngSeed,  DateTime createdAt,  DateTime inGameDate,  int cyclePointer,  DateTime? lastPlayedAt,  int budget,  int? captainPlayerId,  DateTime? yReadAt,  int playedSeconds,  int skillManManagement,  int skillTactical,  int skillYouthDevelopment,  int skillNegotiation,  StaffTier staffAssistant,  StaffTier staffScout,  StaffTier staffFitnessCoach,  int? staffAssistantId,  int? staffScoutId,  int? staffFitnessCoachId,  int? lastCycleBoard,  String? callUpWindowId)?  $default,) {final _that = this;
switch (_that) {
case _Career() when $default != null:
return $default(_that.id,_that.managerName,_that.nationId,_that.rngSeed,_that.createdAt,_that.inGameDate,_that.cyclePointer,_that.lastPlayedAt,_that.budget,_that.captainPlayerId,_that.yReadAt,_that.playedSeconds,_that.skillManManagement,_that.skillTactical,_that.skillYouthDevelopment,_that.skillNegotiation,_that.staffAssistant,_that.staffScout,_that.staffFitnessCoach,_that.staffAssistantId,_that.staffScoutId,_that.staffFitnessCoachId,_that.lastCycleBoard,_that.callUpWindowId);case _:
  return null;

}
}

}

/// @nodoc


class _Career implements Career {
  const _Career({required this.id, required this.managerName, required this.nationId, required this.rngSeed, required this.createdAt, required this.inGameDate, this.cyclePointer = 0, this.lastPlayedAt, this.budget = 0, this.captainPlayerId, this.yReadAt, this.playedSeconds = 0, this.skillManManagement = ManagerSkills.starting, this.skillTactical = ManagerSkills.starting, this.skillYouthDevelopment = ManagerSkills.starting, this.skillNegotiation = ManagerSkills.starting, this.staffAssistant = StaffTier.none, this.staffScout = StaffTier.none, this.staffFitnessCoach = StaffTier.none, this.staffAssistantId, this.staffScoutId, this.staffFitnessCoachId, this.lastCycleBoard, this.callUpWindowId});
  

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
/// The in-game date of the newest Y post the manager has seen, or null if
/// he has never opened the feed. Posts are derived rather than stored, so
/// this watermark is what "unread" is counted against.
@override final  DateTime? yReadAt;
/// Real-world seconds spent playing this save. Zero for a save that
/// predates the counter — its earlier hours were never measured, and
/// inventing a number for them would be worse than starting at nothing.
@override@JsonKey() final  int playedSeconds;
/// What the manager himself is good at, 1–20 apiece. All four start at
/// [ManagerSkills.starting], which every effect reads as neutral — so a
/// save that predates them is unaffected until a point is spent.
@override@JsonKey() final  int skillManManagement;
@override@JsonKey() final  int skillTactical;
@override@JsonKey() final  int skillYouthDevelopment;
@override@JsonKey() final  int skillNegotiation;
/// The staff he has hired. Nobody, by default, which costs nothing.
@override@JsonKey() final  StaffTier staffAssistant;
@override@JsonKey() final  StaffTier staffScout;
@override@JsonKey() final  StaffTier staffFitnessCoach;
/// WHO is in each job, or null when the post is vacant. The tier above
/// stays the source of truth for every effect; this is the person.
@override final  int? staffAssistantId;
@override final  int? staffScoutId;
@override final  int? staffFitnessCoachId;
/// Where the board's gauge finished the previous cycle, or null before a
/// cycle has closed.
@override final  int? lastCycleBoard;
/// The international window the current squad was named for, or null when
/// no squad has been named yet.
@override final  String? callUpWindowId;

/// Create a copy of Career
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareerCopyWith<_Career> get copyWith => __$CareerCopyWithImpl<_Career>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Career&&(identical(other.id, id) || other.id == id)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.nationId, nationId) || other.nationId == nationId)&&(identical(other.rngSeed, rngSeed) || other.rngSeed == rngSeed)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.inGameDate, inGameDate) || other.inGameDate == inGameDate)&&(identical(other.cyclePointer, cyclePointer) || other.cyclePointer == cyclePointer)&&(identical(other.lastPlayedAt, lastPlayedAt) || other.lastPlayedAt == lastPlayedAt)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.captainPlayerId, captainPlayerId) || other.captainPlayerId == captainPlayerId)&&(identical(other.yReadAt, yReadAt) || other.yReadAt == yReadAt)&&(identical(other.playedSeconds, playedSeconds) || other.playedSeconds == playedSeconds)&&(identical(other.skillManManagement, skillManManagement) || other.skillManManagement == skillManManagement)&&(identical(other.skillTactical, skillTactical) || other.skillTactical == skillTactical)&&(identical(other.skillYouthDevelopment, skillYouthDevelopment) || other.skillYouthDevelopment == skillYouthDevelopment)&&(identical(other.skillNegotiation, skillNegotiation) || other.skillNegotiation == skillNegotiation)&&(identical(other.staffAssistant, staffAssistant) || other.staffAssistant == staffAssistant)&&(identical(other.staffScout, staffScout) || other.staffScout == staffScout)&&(identical(other.staffFitnessCoach, staffFitnessCoach) || other.staffFitnessCoach == staffFitnessCoach)&&(identical(other.staffAssistantId, staffAssistantId) || other.staffAssistantId == staffAssistantId)&&(identical(other.staffScoutId, staffScoutId) || other.staffScoutId == staffScoutId)&&(identical(other.staffFitnessCoachId, staffFitnessCoachId) || other.staffFitnessCoachId == staffFitnessCoachId)&&(identical(other.lastCycleBoard, lastCycleBoard) || other.lastCycleBoard == lastCycleBoard)&&(identical(other.callUpWindowId, callUpWindowId) || other.callUpWindowId == callUpWindowId));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,managerName,nationId,rngSeed,createdAt,inGameDate,cyclePointer,lastPlayedAt,budget,captainPlayerId,yReadAt,playedSeconds,skillManManagement,skillTactical,skillYouthDevelopment,skillNegotiation,staffAssistant,staffScout,staffFitnessCoach,staffAssistantId,staffScoutId,staffFitnessCoachId,lastCycleBoard,callUpWindowId]);

@override
String toString() {
  return 'Career(id: $id, managerName: $managerName, nationId: $nationId, rngSeed: $rngSeed, createdAt: $createdAt, inGameDate: $inGameDate, cyclePointer: $cyclePointer, lastPlayedAt: $lastPlayedAt, budget: $budget, captainPlayerId: $captainPlayerId, yReadAt: $yReadAt, playedSeconds: $playedSeconds, skillManManagement: $skillManManagement, skillTactical: $skillTactical, skillYouthDevelopment: $skillYouthDevelopment, skillNegotiation: $skillNegotiation, staffAssistant: $staffAssistant, staffScout: $staffScout, staffFitnessCoach: $staffFitnessCoach, staffAssistantId: $staffAssistantId, staffScoutId: $staffScoutId, staffFitnessCoachId: $staffFitnessCoachId, lastCycleBoard: $lastCycleBoard, callUpWindowId: $callUpWindowId)';
}


}

/// @nodoc
abstract mixin class _$CareerCopyWith<$Res> implements $CareerCopyWith<$Res> {
  factory _$CareerCopyWith(_Career value, $Res Function(_Career) _then) = __$CareerCopyWithImpl;
@override @useResult
$Res call({
 int id, String managerName, int nationId, int rngSeed, DateTime createdAt, DateTime inGameDate, int cyclePointer, DateTime? lastPlayedAt, int budget, int? captainPlayerId, DateTime? yReadAt, int playedSeconds, int skillManManagement, int skillTactical, int skillYouthDevelopment, int skillNegotiation, StaffTier staffAssistant, StaffTier staffScout, StaffTier staffFitnessCoach, int? staffAssistantId, int? staffScoutId, int? staffFitnessCoachId, int? lastCycleBoard, String? callUpWindowId
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? managerName = null,Object? nationId = null,Object? rngSeed = null,Object? createdAt = null,Object? inGameDate = null,Object? cyclePointer = null,Object? lastPlayedAt = freezed,Object? budget = null,Object? captainPlayerId = freezed,Object? yReadAt = freezed,Object? playedSeconds = null,Object? skillManManagement = null,Object? skillTactical = null,Object? skillYouthDevelopment = null,Object? skillNegotiation = null,Object? staffAssistant = null,Object? staffScout = null,Object? staffFitnessCoach = null,Object? staffAssistantId = freezed,Object? staffScoutId = freezed,Object? staffFitnessCoachId = freezed,Object? lastCycleBoard = freezed,Object? callUpWindowId = freezed,}) {
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
as int?,yReadAt: freezed == yReadAt ? _self.yReadAt : yReadAt // ignore: cast_nullable_to_non_nullable
as DateTime?,playedSeconds: null == playedSeconds ? _self.playedSeconds : playedSeconds // ignore: cast_nullable_to_non_nullable
as int,skillManManagement: null == skillManManagement ? _self.skillManManagement : skillManManagement // ignore: cast_nullable_to_non_nullable
as int,skillTactical: null == skillTactical ? _self.skillTactical : skillTactical // ignore: cast_nullable_to_non_nullable
as int,skillYouthDevelopment: null == skillYouthDevelopment ? _self.skillYouthDevelopment : skillYouthDevelopment // ignore: cast_nullable_to_non_nullable
as int,skillNegotiation: null == skillNegotiation ? _self.skillNegotiation : skillNegotiation // ignore: cast_nullable_to_non_nullable
as int,staffAssistant: null == staffAssistant ? _self.staffAssistant : staffAssistant // ignore: cast_nullable_to_non_nullable
as StaffTier,staffScout: null == staffScout ? _self.staffScout : staffScout // ignore: cast_nullable_to_non_nullable
as StaffTier,staffFitnessCoach: null == staffFitnessCoach ? _self.staffFitnessCoach : staffFitnessCoach // ignore: cast_nullable_to_non_nullable
as StaffTier,staffAssistantId: freezed == staffAssistantId ? _self.staffAssistantId : staffAssistantId // ignore: cast_nullable_to_non_nullable
as int?,staffScoutId: freezed == staffScoutId ? _self.staffScoutId : staffScoutId // ignore: cast_nullable_to_non_nullable
as int?,staffFitnessCoachId: freezed == staffFitnessCoachId ? _self.staffFitnessCoachId : staffFitnessCoachId // ignore: cast_nullable_to_non_nullable
as int?,lastCycleBoard: freezed == lastCycleBoard ? _self.lastCycleBoard : lastCycleBoard // ignore: cast_nullable_to_non_nullable
as int?,callUpWindowId: freezed == callUpWindowId ? _self.callUpWindowId : callUpWindowId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
