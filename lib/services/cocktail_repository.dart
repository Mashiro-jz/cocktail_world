import 'dart:convert';

import 'package:coctail_world/models/cocktail.dart';
import 'package:http/http.dart' as http;

class CocktailRepository {
  final String baseUrl = 'https://cocktails.solvro.pl/api/v1/cocktails';
  final int perPage = 45;

  Future<List<String>> getCategories() async {
    var url = Uri.https('cocktails.solvro.pl', '/api/v1/cocktails/categories');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)['data'] as List)
          .map((e) => e.toString())
          .toList();
    } else {
      throw Exception('Failed to load cocktails categories');
    }
  }

  Future<List<Cocktail>> getCocktails(
    int page,
    String? category,
    bool? alcoholic,
    String? search,
    String? sort,
  ) async {
    List<Cocktail> cocktails = [];

    final Map<String, String> queryParams = {
      'page': page.toString(),
      'perPage': perPage.toString(),
    };

    if (category != null) queryParams['category'] = category;
    if (alcoholic != null) queryParams['alcoholic'] = alcoholic.toString();
    if (search != null && search.isNotEmpty) queryParams['name'] = search;
    if (sort != null) queryParams['sort'] = sort;

    var url = Uri.https(
      'cocktails.solvro.pl',
      '/api/v1/cocktails',
      queryParams,
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      cocktails = (jsonDecode(response.body)['data'] as List)
          .map((e) => Cocktail.fromJson(e))
          .toList();

      return cocktails;
    } else {
      throw Exception('Failed to load cocktails');
    }
  }

  Future<Cocktail> getCocktailDetails(String cocktailId) async {
    var url = Uri.https('cocktails.solvro.pl', '/api/v1/cocktails/$cocktailId');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final cocktail = Cocktail.fromJson(jsonDecode(response.body)['data']);
      return cocktail;
    } else {
      throw Exception('Failed to load cocktail details');
    }
  }
}
