// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cocktail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Cocktail {

 int get id; String get name; String? get category; String get instructions; String? get imageUrl; bool get alcoholic; List<Ingredient>? get ingredients;
/// Create a copy of Cocktail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CocktailCopyWith<Cocktail> get copyWith => _$CocktailCopyWithImpl<Cocktail>(this as Cocktail, _$identity);

  /// Serializes this Cocktail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Cocktail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cocktail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.instructions, _this.instructions) || other.instructions == _this.instructions)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.alcoholic, _this.alcoholic) || other.alcoholic == _this.alcoholic)&&const DeepCollectionEquality().equals(other.ingredients, _this.ingredients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Cocktail;
  return Object.hash(runtimeType,_this.id,_this.name,_this.category,_this.instructions,_this.imageUrl,_this.alcoholic,const DeepCollectionEquality().hash(_this.ingredients));
}

@override
String toString() {
  final _this = this as Cocktail;
  return 'Cocktail(id: ${_this.id}, name: ${_this.name}, category: ${_this.category}, instructions: ${_this.instructions}, imageUrl: ${_this.imageUrl}, alcoholic: ${_this.alcoholic}, ingredients: ${_this.ingredients})';
}


}

/// @nodoc
abstract mixin class $CocktailCopyWith<$Res>  {
  factory $CocktailCopyWith(Cocktail value, $Res Function(Cocktail) _then) = _$CocktailCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? category, String instructions, String? imageUrl, bool alcoholic, List<Ingredient>? ingredients
});




}
/// @nodoc
class _$CocktailCopyWithImpl<$Res>
    implements $CocktailCopyWith<$Res> {
  _$CocktailCopyWithImpl(this._self, this._then);

  final Cocktail _self;
  final $Res Function(Cocktail) _then;

/// Create a copy of Cocktail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = freezed,Object? instructions = null,Object? imageUrl = freezed,Object? alcoholic = null,Object? ingredients = freezed,}) {
  return _then(Cocktail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,alcoholic: null == alcoholic ? _self.alcoholic : alcoholic // ignore: cast_nullable_to_non_nullable
as bool,ingredients: freezed == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Ingredient>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Cocktail].
extension CocktailPatterns on Cocktail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cocktail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cocktail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cocktail value)  $default,){
final _that = this;
switch (_that) {
case _Cocktail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cocktail value)?  $default,){
final _that = this;
switch (_that) {
case _Cocktail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? category,  String instructions,  String? imageUrl,  bool alcoholic,  List<Ingredient>? ingredients)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cocktail() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.instructions,_that.imageUrl,_that.alcoholic,_that.ingredients);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? category,  String instructions,  String? imageUrl,  bool alcoholic,  List<Ingredient>? ingredients)  $default,) {final _that = this;
switch (_that) {
case _Cocktail():
return $default(_that.id,_that.name,_that.category,_that.instructions,_that.imageUrl,_that.alcoholic,_that.ingredients);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? category,  String instructions,  String? imageUrl,  bool alcoholic,  List<Ingredient>? ingredients)?  $default,) {final _that = this;
switch (_that) {
case _Cocktail() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.instructions,_that.imageUrl,_that.alcoholic,_that.ingredients);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cocktail implements Cocktail {
  const _Cocktail({required this.id, required this.name, this.category, required this.instructions, this.imageUrl, required this.alcoholic,  List<Ingredient>? ingredients}): _ingredients = ingredients;
  factory _Cocktail.fromJson(Map<String, dynamic> json) => _$CocktailFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? category;
@override final  String instructions;
@override final  String? imageUrl;
@override final  bool alcoholic;
 final  List<Ingredient>? _ingredients;
@override List<Ingredient>? get ingredients {
  final value = _ingredients;
  if (value == null) return null;
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Cocktail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CocktailCopyWith<_Cocktail> get copyWith => __$CocktailCopyWithImpl<_Cocktail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CocktailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cocktail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.alcoholic, alcoholic) || other.alcoholic == alcoholic)&&const DeepCollectionEquality().equals(other.ingredients, _ingredients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,category,instructions,imageUrl,alcoholic,const DeepCollectionEquality().hash(_ingredients));
}

@override
String toString() {
    return 'Cocktail(id: $id, name: $name, category: $category, instructions: $instructions, imageUrl: $imageUrl, alcoholic: $alcoholic, ingredients: $ingredients)';
}


}

/// @nodoc
abstract mixin class _$CocktailCopyWith<$Res> implements $CocktailCopyWith<$Res> {
  factory _$CocktailCopyWith(_Cocktail value, $Res Function(_Cocktail) _then) = __$CocktailCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? category, String instructions, String? imageUrl, bool alcoholic, List<Ingredient>? ingredients
});




}
/// @nodoc
class __$CocktailCopyWithImpl<$Res>
    implements _$CocktailCopyWith<$Res> {
  __$CocktailCopyWithImpl(this._self, this._then);

  final _Cocktail _self;
  final $Res Function(_Cocktail) _then;

/// Create a copy of Cocktail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = freezed,Object? instructions = null,Object? imageUrl = freezed,Object? alcoholic = null,Object? ingredients = freezed,}) {
  return _then(_Cocktail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,alcoholic: null == alcoholic ? _self.alcoholic : alcoholic // ignore: cast_nullable_to_non_nullable
as bool,ingredients: freezed == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Ingredient>?,
  ));
}


}

// dart format on
