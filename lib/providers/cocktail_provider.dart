import 'package:coctail_world/models/cocktail.dart';
import 'package:coctail_world/services/cocktail_repository.dart';
import 'package:flutter/material.dart';

class CocktailProvider extends ChangeNotifier {
  final CocktailRepository _cocktailRepository = CocktailRepository();

  List<Cocktail> _cocktails = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  List<Cocktail> get list {
    if (_searchQuery.isEmpty) {
      return _cocktails;
    } else {
      return _cocktails
          .where(
            (cocktail) => cocktail.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get query => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<List<Cocktail>> fetchCocktails() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cocktails = await _cocktailRepository.getCocktails();
      _isLoading = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      return [];
    } finally {
      notifyListeners();
    }
    return _cocktails;
  }
}
