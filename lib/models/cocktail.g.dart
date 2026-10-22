// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cocktail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Cocktail _$CocktailFromJson(Map<String, dynamic> json) => _Cocktail(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  category: json['category'] as String?,
  instructions: json['instructions'] as String,
  imageUrl: json['imageUrl'] as String?,
  alcoholic: json['alcoholic'] as bool,
  ingredients: (json['ingredients'] as List<dynamic>?)
      ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CocktailToJson(_Cocktail instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'instructions': instance.instructions,
  'imageUrl': instance.imageUrl,
  'alcoholic': instance.alcoholic,
  'ingredients': instance.ingredients,
};
