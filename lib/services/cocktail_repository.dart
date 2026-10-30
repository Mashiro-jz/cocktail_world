import 'dart:convert';

import 'package:coctail_world/models/cocktail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CocktailRepository {
  final String baseUrl = 'https://cocktails.solvro.pl/api/v1/cocktails';
  final int perPage = 30;
  final Duration timeout = const Duration(seconds: 10);

  Future<List<String>> getCategories() async {
    var url = Uri.https('cocktails.solvro.pl', '/api/v1/cocktails/categories');
    var response = await http.get(url).timeout(timeout);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body)['data'] as List)
          .map((e) => e.toString())
          .toList();
    } else {
      throw Exception(
        'Failed to load cocktails categories (${response.statusCode})',
      );
    }
  }

  Future<List<Cocktail>> getCocktails(
    int page,
    String? category,
    bool? alcoholic,
    String? search,
    String? sort,
  ) async {
    final String? query = search?.trim();
    final bool useCache = query == null || query.isEmpty;

    final Map<String, String> queryParams = {
      'page': page.toString(),
      'perPage': perPage.toString(),
    };

    if (category != null) queryParams['category'] = category;
    if (alcoholic != null) queryParams['alcoholic'] = alcoholic.toString();
    if (query != null && query.isNotEmpty) queryParams['name'] = query;
    if (sort != null) queryParams['sort'] = sort;

    var url = Uri.https(
      'cocktails.solvro.pl',
      '/api/v1/cocktails',
      queryParams,
    );

    final String cacheKey = url.toString();
    final prefs = await SharedPreferences.getInstance();

    final cachedData = useCache ? prefs.getString(cacheKey) : null;
    final cacheTimeStr = useCache ? prefs.getString('${cacheKey}_time') : null;

    if (cachedData != null && cacheTimeStr != null) {
      try {
        final cacheTime = DateTime.parse(cacheTimeStr);
        final difference = DateTime.now().difference(cacheTime);

        // jeżeli nie mineło 30 minut od ostatniego pobrania to pobieram dane z cache'u
        if (difference.inMinutes < 30) {
          return (jsonDecode(cachedData)['data'] as List)
              .map((e) => Cocktail.fromJson(e))
              .toList();
        }
      } catch (_) {}
    }

    // a jeśli mienło to pobieram z sieci
    try {
      var response = await http.get(url).timeout(timeout);
      if (response.statusCode == 200) {
        final cocktails = (jsonDecode(response.body)['data'] as List)
            .map((e) => Cocktail.fromJson(e))
            .toList();

        if (useCache) {
          try {
            await prefs.setString(cacheKey, response.body);
            await prefs.setString(
              '${cacheKey}_time',
              DateTime.now().toIso8601String(),
            );
          } catch (_) {}
        }

        return cocktails;
      } else {
        throw Exception('Failed to load cocktails (${response.statusCode})');
      }
    } catch (e) {
      if (cachedData != null) {
        try {
          return (jsonDecode(cachedData)['data'] as List)
              .map((e) => Cocktail.fromJson(e))
              .toList();
        } catch (_) {}
      }
      rethrow;
    }
  }

  Future<Cocktail> getCocktailDetails(String cocktailId) async {
    var url = Uri.https('cocktails.solvro.pl', '/api/v1/cocktails/$cocktailId');
    var response = await http.get(url).timeout(timeout);
    if (response.statusCode == 200) {
      final cocktail = Cocktail.fromJson(jsonDecode(response.body)['data']);
      return cocktail;
    } else {
      throw Exception(
        'Failed to load cocktail details (${response.statusCode})',
      );
    }
  }
}
