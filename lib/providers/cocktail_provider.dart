import 'package:coctail_world/models/cocktail.dart';
import 'package:coctail_world/services/cocktail_repository.dart';
import 'package:flutter/material.dart';

class CocktailProvider extends ChangeNotifier {
  final CocktailRepository _cocktailRepository = CocktailRepository();

  final List<Cocktail> _cocktails = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  int _currentPage = 1;
  bool _isFetchingMore = false;
  bool _hasMore = true;

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
  bool get isFetchingMore => _isFetchingMore;
  String? get error => _error;
  String? get query => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<List<Cocktail>> fetchCocktails() async {
    if (!_hasMore || _isFetchingMore) return _cocktails;

    _error = null;

    if (_currentPage == 1) {
      _isLoading = true;
    } else {
      _isFetchingMore = true;
    }

    notifyListeners();

    try {
      final newCocktails = await _cocktailRepository.getCocktails(_currentPage);
      _cocktails.addAll(newCocktails);
      if (newCocktails.length < _cocktailRepository.perPage) _hasMore = false;
      _error = null;
      _currentPage++;
    } catch (e) {
      _error = e.toString();
      return [];
    } finally {
      _isLoading = false;
      _isFetchingMore = false;
      notifyListeners();
    }
    return _cocktails;
  }
}
