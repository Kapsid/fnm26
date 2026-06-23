// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tactics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TacticalInstructions {

 int get mentality;// defensive ↔ attacking
 int get pressing;// low block ↔ high press
 int get tempo;// patient ↔ fast
 int get width;// narrow ↔ wide
 int get defensiveLine;// deep ↔ high
 int get directness;
/// Create a copy of TacticalInstructions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TacticalInstructionsCopyWith<TacticalInstructions> get copyWith => _$TacticalInstructionsCopyWithImpl<TacticalInstructions>(this as TacticalInstructions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TacticalInstructions&&(identical(other.mentality, mentality) || other.mentality == mentality)&&(identical(other.pressing, pressing) || other.pressing == pressing)&&(identical(other.tempo, tempo) || other.tempo == tempo)&&(identical(other.width, width) || other.width == width)&&(identical(other.defensiveLine, defensiveLine) || other.defensiveLine == defensiveLine)&&(identical(other.directness, directness) || other.directness == directness));
}


@override
int get hashCode => Object.hash(runtimeType,mentality,pressing,tempo,width,defensiveLine,directness);

@override
String toString() {
  return 'TacticalInstructions(mentality: $mentality, pressing: $pressing, tempo: $tempo, width: $width, defensiveLine: $defensiveLine, directness: $directness)';
}


}

/// @nodoc
abstract mixin class $TacticalInstructionsCopyWith<$Res>  {
  factory $TacticalInstructionsCopyWith(TacticalInstructions value, $Res Function(TacticalInstructions) _then) = _$TacticalInstructionsCopyWithImpl;
@useResult
$Res call({
 int mentality, int pressing, int tempo, int width, int defensiveLine, int directness
});




}
/// @nodoc
class _$TacticalInstructionsCopyWithImpl<$Res>
    implements $TacticalInstructionsCopyWith<$Res> {
  _$TacticalInstructionsCopyWithImpl(this._self, this._then);

  final TacticalInstructions _self;
  final $Res Function(TacticalInstructions) _then;

/// Create a copy of TacticalInstructions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mentality = null,Object? pressing = null,Object? tempo = null,Object? width = null,Object? defensiveLine = null,Object? directness = null,}) {
  return _then(_self.copyWith(
mentality: null == mentality ? _self.mentality : mentality // ignore: cast_nullable_to_non_nullable
as int,pressing: null == pressing ? _self.pressing : pressing // ignore: cast_nullable_to_non_nullable
as int,tempo: null == tempo ? _self.tempo : tempo // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,defensiveLine: null == defensiveLine ? _self.defensiveLine : defensiveLine // ignore: cast_nullable_to_non_nullable
as int,directness: null == directness ? _self.directness : directness // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TacticalInstructions].
extension TacticalInstructionsPatterns on TacticalInstructions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TacticalInstructions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TacticalInstructions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TacticalInstructions value)  $default,){
final _that = this;
switch (_that) {
case _TacticalInstructions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TacticalInstructions value)?  $default,){
final _that = this;
switch (_that) {
case _TacticalInstructions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int mentality,  int pressing,  int tempo,  int width,  int defensiveLine,  int directness)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TacticalInstructions() when $default != null:
return $default(_that.mentality,_that.pressing,_that.tempo,_that.width,_that.defensiveLine,_that.directness);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int mentality,  int pressing,  int tempo,  int width,  int defensiveLine,  int directness)  $default,) {final _that = this;
switch (_that) {
case _TacticalInstructions():
return $default(_that.mentality,_that.pressing,_that.tempo,_that.width,_that.defensiveLine,_that.directness);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int mentality,  int pressing,  int tempo,  int width,  int defensiveLine,  int directness)?  $default,) {final _that = this;
switch (_that) {
case _TacticalInstructions() when $default != null:
return $default(_that.mentality,_that.pressing,_that.tempo,_that.width,_that.defensiveLine,_that.directness);case _:
  return null;

}
}

}

/// @nodoc


class _TacticalInstructions implements TacticalInstructions {
  const _TacticalInstructions({this.mentality = 50, this.pressing = 50, this.tempo = 50, this.width = 50, this.defensiveLine = 50, this.directness = 50});
  

@override@JsonKey() final  int mentality;
// defensive ↔ attacking
@override@JsonKey() final  int pressing;
// low block ↔ high press
@override@JsonKey() final  int tempo;
// patient ↔ fast
@override@JsonKey() final  int width;
// narrow ↔ wide
@override@JsonKey() final  int defensiveLine;
// deep ↔ high
@override@JsonKey() final  int directness;

/// Create a copy of TacticalInstructions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TacticalInstructionsCopyWith<_TacticalInstructions> get copyWith => __$TacticalInstructionsCopyWithImpl<_TacticalInstructions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TacticalInstructions&&(identical(other.mentality, mentality) || other.mentality == mentality)&&(identical(other.pressing, pressing) || other.pressing == pressing)&&(identical(other.tempo, tempo) || other.tempo == tempo)&&(identical(other.width, width) || other.width == width)&&(identical(other.defensiveLine, defensiveLine) || other.defensiveLine == defensiveLine)&&(identical(other.directness, directness) || other.directness == directness));
}


@override
int get hashCode => Object.hash(runtimeType,mentality,pressing,tempo,width,defensiveLine,directness);

@override
String toString() {
  return 'TacticalInstructions(mentality: $mentality, pressing: $pressing, tempo: $tempo, width: $width, defensiveLine: $defensiveLine, directness: $directness)';
}


}

/// @nodoc
abstract mixin class _$TacticalInstructionsCopyWith<$Res> implements $TacticalInstructionsCopyWith<$Res> {
  factory _$TacticalInstructionsCopyWith(_TacticalInstructions value, $Res Function(_TacticalInstructions) _then) = __$TacticalInstructionsCopyWithImpl;
@override @useResult
$Res call({
 int mentality, int pressing, int tempo, int width, int defensiveLine, int directness
});




}
/// @nodoc
class __$TacticalInstructionsCopyWithImpl<$Res>
    implements _$TacticalInstructionsCopyWith<$Res> {
  __$TacticalInstructionsCopyWithImpl(this._self, this._then);

  final _TacticalInstructions _self;
  final $Res Function(_TacticalInstructions) _then;

/// Create a copy of TacticalInstructions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mentality = null,Object? pressing = null,Object? tempo = null,Object? width = null,Object? defensiveLine = null,Object? directness = null,}) {
  return _then(_TacticalInstructions(
mentality: null == mentality ? _self.mentality : mentality // ignore: cast_nullable_to_non_nullable
as int,pressing: null == pressing ? _self.pressing : pressing // ignore: cast_nullable_to_non_nullable
as int,tempo: null == tempo ? _self.tempo : tempo // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,defensiveLine: null == defensiveLine ? _self.defensiveLine : defensiveLine // ignore: cast_nullable_to_non_nullable
as int,directness: null == directness ? _self.directness : directness // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Tactic {

 Formation get formation; List<int?> get lineup;// length 11, slot order matches the formation
 TacticalInstructions get instructions;
/// Create a copy of Tactic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TacticCopyWith<Tactic> get copyWith => _$TacticCopyWithImpl<Tactic>(this as Tactic, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tactic&&(identical(other.formation, formation) || other.formation == formation)&&const DeepCollectionEquality().equals(other.lineup, lineup)&&(identical(other.instructions, instructions) || other.instructions == instructions));
}


@override
int get hashCode => Object.hash(runtimeType,formation,const DeepCollectionEquality().hash(lineup),instructions);

@override
String toString() {
  return 'Tactic(formation: $formation, lineup: $lineup, instructions: $instructions)';
}


}

/// @nodoc
abstract mixin class $TacticCopyWith<$Res>  {
  factory $TacticCopyWith(Tactic value, $Res Function(Tactic) _then) = _$TacticCopyWithImpl;
@useResult
$Res call({
 Formation formation, List<int?> lineup, TacticalInstructions instructions
});


$TacticalInstructionsCopyWith<$Res> get instructions;

}
/// @nodoc
class _$TacticCopyWithImpl<$Res>
    implements $TacticCopyWith<$Res> {
  _$TacticCopyWithImpl(this._self, this._then);

  final Tactic _self;
  final $Res Function(Tactic) _then;

/// Create a copy of Tactic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formation = null,Object? lineup = null,Object? instructions = null,}) {
  return _then(_self.copyWith(
formation: null == formation ? _self.formation : formation // ignore: cast_nullable_to_non_nullable
as Formation,lineup: null == lineup ? _self.lineup : lineup // ignore: cast_nullable_to_non_nullable
as List<int?>,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as TacticalInstructions,
  ));
}
/// Create a copy of Tactic
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TacticalInstructionsCopyWith<$Res> get instructions {
  
  return $TacticalInstructionsCopyWith<$Res>(_self.instructions, (value) {
    return _then(_self.copyWith(instructions: value));
  });
}
}


/// Adds pattern-matching-related methods to [Tactic].
extension TacticPatterns on Tactic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tactic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tactic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tactic value)  $default,){
final _that = this;
switch (_that) {
case _Tactic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tactic value)?  $default,){
final _that = this;
switch (_that) {
case _Tactic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Formation formation,  List<int?> lineup,  TacticalInstructions instructions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tactic() when $default != null:
return $default(_that.formation,_that.lineup,_that.instructions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Formation formation,  List<int?> lineup,  TacticalInstructions instructions)  $default,) {final _that = this;
switch (_that) {
case _Tactic():
return $default(_that.formation,_that.lineup,_that.instructions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Formation formation,  List<int?> lineup,  TacticalInstructions instructions)?  $default,) {final _that = this;
switch (_that) {
case _Tactic() when $default != null:
return $default(_that.formation,_that.lineup,_that.instructions);case _:
  return null;

}
}

}

/// @nodoc


class _Tactic implements Tactic {
  const _Tactic({required this.formation, required final  List<int?> lineup, this.instructions = const TacticalInstructions()}): _lineup = lineup;
  

@override final  Formation formation;
 final  List<int?> _lineup;
@override List<int?> get lineup {
  if (_lineup is EqualUnmodifiableListView) return _lineup;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lineup);
}

// length 11, slot order matches the formation
@override@JsonKey() final  TacticalInstructions instructions;

/// Create a copy of Tactic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TacticCopyWith<_Tactic> get copyWith => __$TacticCopyWithImpl<_Tactic>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tactic&&(identical(other.formation, formation) || other.formation == formation)&&const DeepCollectionEquality().equals(other._lineup, _lineup)&&(identical(other.instructions, instructions) || other.instructions == instructions));
}


@override
int get hashCode => Object.hash(runtimeType,formation,const DeepCollectionEquality().hash(_lineup),instructions);

@override
String toString() {
  return 'Tactic(formation: $formation, lineup: $lineup, instructions: $instructions)';
}


}

/// @nodoc
abstract mixin class _$TacticCopyWith<$Res> implements $TacticCopyWith<$Res> {
  factory _$TacticCopyWith(_Tactic value, $Res Function(_Tactic) _then) = __$TacticCopyWithImpl;
@override @useResult
$Res call({
 Formation formation, List<int?> lineup, TacticalInstructions instructions
});


@override $TacticalInstructionsCopyWith<$Res> get instructions;

}
/// @nodoc
class __$TacticCopyWithImpl<$Res>
    implements _$TacticCopyWith<$Res> {
  __$TacticCopyWithImpl(this._self, this._then);

  final _Tactic _self;
  final $Res Function(_Tactic) _then;

/// Create a copy of Tactic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formation = null,Object? lineup = null,Object? instructions = null,}) {
  return _then(_Tactic(
formation: null == formation ? _self.formation : formation // ignore: cast_nullable_to_non_nullable
as Formation,lineup: null == lineup ? _self._lineup : lineup // ignore: cast_nullable_to_non_nullable
as List<int?>,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as TacticalInstructions,
  ));
}

/// Create a copy of Tactic
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TacticalInstructionsCopyWith<$Res> get instructions {
  
  return $TacticalInstructionsCopyWith<$Res>(_self.instructions, (value) {
    return _then(_self.copyWith(instructions: value));
  });
}
}

// dart format on
