// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Nation {

 int get id; String get name;/// Short country code (e.g. `BRA`, `ENG`).
 String get code; Confederation get confederation;/// FIFA-style ranking position (lower is stronger).
 int get ranking;/// Whether this nation is available in the free demo.
 bool get isFreeDemo;/// The national team's home-kit colours as `#RRGGBB` hex — primary (shirt)
/// and secondary (trim). Defined for every FIFA nation; the defaults are
/// only a fallback for a nation constructed without them (e.g. in tests).
 String get primaryColor; String get secondaryColor;
/// Create a copy of Nation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NationCopyWith<Nation> get copyWith => _$NationCopyWithImpl<Nation>(this as Nation, _$identity);

  /// Serializes this Nation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nation&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.confederation, confederation) || other.confederation == confederation)&&(identical(other.ranking, ranking) || other.ranking == ranking)&&(identical(other.isFreeDemo, isFreeDemo) || other.isFreeDemo == isFreeDemo)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.secondaryColor, secondaryColor) || other.secondaryColor == secondaryColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code,confederation,ranking,isFreeDemo,primaryColor,secondaryColor);

@override
String toString() {
  return 'Nation(id: $id, name: $name, code: $code, confederation: $confederation, ranking: $ranking, isFreeDemo: $isFreeDemo, primaryColor: $primaryColor, secondaryColor: $secondaryColor)';
}


}

/// @nodoc
abstract mixin class $NationCopyWith<$Res>  {
  factory $NationCopyWith(Nation value, $Res Function(Nation) _then) = _$NationCopyWithImpl;
@useResult
$Res call({
 int id, String name, String code, Confederation confederation, int ranking, bool isFreeDemo, String primaryColor, String secondaryColor
});




}
/// @nodoc
class _$NationCopyWithImpl<$Res>
    implements $NationCopyWith<$Res> {
  _$NationCopyWithImpl(this._self, this._then);

  final Nation _self;
  final $Res Function(Nation) _then;

/// Create a copy of Nation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? code = null,Object? confederation = null,Object? ranking = null,Object? isFreeDemo = null,Object? primaryColor = null,Object? secondaryColor = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,confederation: null == confederation ? _self.confederation : confederation // ignore: cast_nullable_to_non_nullable
as Confederation,ranking: null == ranking ? _self.ranking : ranking // ignore: cast_nullable_to_non_nullable
as int,isFreeDemo: null == isFreeDemo ? _self.isFreeDemo : isFreeDemo // ignore: cast_nullable_to_non_nullable
as bool,primaryColor: null == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String,secondaryColor: null == secondaryColor ? _self.secondaryColor : secondaryColor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Nation].
extension NationPatterns on Nation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Nation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Nation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Nation value)  $default,){
final _that = this;
switch (_that) {
case _Nation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Nation value)?  $default,){
final _that = this;
switch (_that) {
case _Nation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String code,  Confederation confederation,  int ranking,  bool isFreeDemo,  String primaryColor,  String secondaryColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Nation() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.confederation,_that.ranking,_that.isFreeDemo,_that.primaryColor,_that.secondaryColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String code,  Confederation confederation,  int ranking,  bool isFreeDemo,  String primaryColor,  String secondaryColor)  $default,) {final _that = this;
switch (_that) {
case _Nation():
return $default(_that.id,_that.name,_that.code,_that.confederation,_that.ranking,_that.isFreeDemo,_that.primaryColor,_that.secondaryColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String code,  Confederation confederation,  int ranking,  bool isFreeDemo,  String primaryColor,  String secondaryColor)?  $default,) {final _that = this;
switch (_that) {
case _Nation() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.confederation,_that.ranking,_that.isFreeDemo,_that.primaryColor,_that.secondaryColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Nation implements Nation {
  const _Nation({required this.id, required this.name, required this.code, required this.confederation, required this.ranking, this.isFreeDemo = false, this.primaryColor = '#1E88E5', this.secondaryColor = '#FFFFFF'});
  factory _Nation.fromJson(Map<String, dynamic> json) => _$NationFromJson(json);

@override final  int id;
@override final  String name;
/// Short country code (e.g. `BRA`, `ENG`).
@override final  String code;
@override final  Confederation confederation;
/// FIFA-style ranking position (lower is stronger).
@override final  int ranking;
/// Whether this nation is available in the free demo.
@override@JsonKey() final  bool isFreeDemo;
/// The national team's home-kit colours as `#RRGGBB` hex — primary (shirt)
/// and secondary (trim). Defined for every FIFA nation; the defaults are
/// only a fallback for a nation constructed without them (e.g. in tests).
@override@JsonKey() final  String primaryColor;
@override@JsonKey() final  String secondaryColor;

/// Create a copy of Nation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NationCopyWith<_Nation> get copyWith => __$NationCopyWithImpl<_Nation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Nation&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.confederation, confederation) || other.confederation == confederation)&&(identical(other.ranking, ranking) || other.ranking == ranking)&&(identical(other.isFreeDemo, isFreeDemo) || other.isFreeDemo == isFreeDemo)&&(identical(other.primaryColor, primaryColor) || other.primaryColor == primaryColor)&&(identical(other.secondaryColor, secondaryColor) || other.secondaryColor == secondaryColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code,confederation,ranking,isFreeDemo,primaryColor,secondaryColor);

@override
String toString() {
  return 'Nation(id: $id, name: $name, code: $code, confederation: $confederation, ranking: $ranking, isFreeDemo: $isFreeDemo, primaryColor: $primaryColor, secondaryColor: $secondaryColor)';
}


}

/// @nodoc
abstract mixin class _$NationCopyWith<$Res> implements $NationCopyWith<$Res> {
  factory _$NationCopyWith(_Nation value, $Res Function(_Nation) _then) = __$NationCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String code, Confederation confederation, int ranking, bool isFreeDemo, String primaryColor, String secondaryColor
});




}
/// @nodoc
class __$NationCopyWithImpl<$Res>
    implements _$NationCopyWith<$Res> {
  __$NationCopyWithImpl(this._self, this._then);

  final _Nation _self;
  final $Res Function(_Nation) _then;

/// Create a copy of Nation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? code = null,Object? confederation = null,Object? ranking = null,Object? isFreeDemo = null,Object? primaryColor = null,Object? secondaryColor = null,}) {
  return _then(_Nation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,confederation: null == confederation ? _self.confederation : confederation // ignore: cast_nullable_to_non_nullable
as Confederation,ranking: null == ranking ? _self.ranking : ranking // ignore: cast_nullable_to_non_nullable
as int,isFreeDemo: null == isFreeDemo ? _self.isFreeDemo : isFreeDemo // ignore: cast_nullable_to_non_nullable
as bool,primaryColor: null == primaryColor ? _self.primaryColor : primaryColor // ignore: cast_nullable_to_non_nullable
as String,secondaryColor: null == secondaryColor ? _self.secondaryColor : secondaryColor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
