import 'dart:convert';

import 'package:coctail_world/models/cocktail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

    final String cacheKey = url.toString();
    final prefs = await SharedPreferences.getInstance();

    final cachedData = prefs.getString(cacheKey);
    final cacheTimeStr = prefs.getString('${cacheKey}_time');

    if (cachedData != null && cacheTimeStr != null) {
      final cacheTime = DateTime.parse(cacheTimeStr);
      final difference = DateTime.now().difference(cacheTime);

      // jeżeli nie mineło 30 minut od ostatniego pobrania to pobieram dane z cache'u
      if (difference.inMinutes < 30) {
        return (jsonDecode(cachedData)['data'] as List)
            .map((e) => Cocktail.fromJson(e))
            .toList();
      }
    }

    // a jeśli mienło to pobieram z sieci
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, response.body);
        await prefs.setString(
          '${cacheKey}_time',
          DateTime.now().toIso8601String(),
        );

        return (jsonDecode(response.body)['data'] as List)
            .map((e) => Cocktail.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load cocktails');
      }
    } catch (e) {
      if (cachedData != null) {
        return (jsonDecode(cachedData)['data'] as List)
            .map((e) => Cocktail.fromJson(e))
            .toList();
      }
      rethrow;
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
