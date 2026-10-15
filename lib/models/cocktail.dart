import 'package:coctail_world/models/ingredient.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cocktail.freezed.dart';
part 'cocktail.g.dart';

@freezed
class Cocktail with _$Cocktail {
  const factory Cocktail({
    required int id,
    required String name,
    String? category,
    required String instructions,
    String? imageUrl,
    required bool alcoholic,
    required List<Ingridient> ingredients,
    required this.instructions,
    this.imageUrl,
    required this.alcoholic,
    required this.ingredients,
  });
  }) = _Cocktail;
