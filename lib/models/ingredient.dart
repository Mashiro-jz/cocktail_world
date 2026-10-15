import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

@freezed
class Ingridient with _$Ingridient {
  const factory Ingridient({
    required int id,
    required String name,
    String? description,
    required bool alcohol,
    required String type,
    int? percentage;
  required String? imageUrl;
  }) = _Ingridient;
}
  final int? percentage;
  final String? imageUrl;
  Ingridient({
    required this.id,
    required this.name,
    this.description,
    required this.alcohol,
    required this.type,
    this.percentage,
    this.imageUrl,
  });
}
