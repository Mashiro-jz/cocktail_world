import 'dart:convert';

import 'package:coctail_world/models/cocktail.dart';
import 'package:http/http.dart' as http;

class CocktailRepository {
  final String baseUrl = 'https://cocktails.solvro.pl/api/v1/cocktails';
  final int perPage = 45;

  Future<List<Cocktail>> getCocktails(int page) async {
    List<Cocktail> cocktails = [];

    var url = Uri.https('cocktails.solvro.pl', '/api/v1/cocktails', {
      'page': page.toString(),
      'perPage': perPage.toString(),
    });
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
