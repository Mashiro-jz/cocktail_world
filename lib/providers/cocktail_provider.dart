import 'package:coctail_world/models/cocktail.dart';
import 'package:coctail_world/services/cocktail_repository.dart';
import 'package:flutter/material.dart';

class CocktailProvider extends ChangeNotifier {
  CocktailProvider() {
    fetchCategories();
  }

  final CocktailRepository _cocktailRepository = CocktailRepository();

  final List<Cocktail> _cocktails = [];
  List<String> _categories = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  int _currentPage = 1;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  String? _selectedCategory;
  bool? _alcoholicFilter;
  String? _sortBy;

  String? get sort => _sortBy;
  bool? get alcoholicFilter => _alcoholicFilter;
  List<Cocktail> get list => _cocktails;
  List<String> get categories => _categories;
  String? get category => _selectedCategory;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  String? get error => _error;
  String? get query => _searchQuery;

  Future<List<String>> fetchCategories() async {
    try {
      _categories = await _cocktailRepository.getCategories();
    } catch (e) {
      _error = e.toString();
      return [];
    } finally {
      notifyListeners();
    }
    return _categories;
  }

  void setSortBy(String? sort) {
    if (_sortBy == sort) return;

    _sortBy = sort;
    _cocktails.clear();
    _currentPage = 1;
    _hasMore = true;
    fetchCocktails();
  }

  void setAlcoholicFilter(bool? value) {
    if (_alcoholicFilter == value) {
      return;
    }

    _alcoholicFilter = value;
    _cocktails.clear();
    _currentPage = 1;
    _hasMore = true;
    fetchCocktails();
  }

  void setCategory(String category) {
    if (_selectedCategory == category) {
      _selectedCategory = null;
    } else {
      _selectedCategory = category;
    }

    _cocktails.clear();
    _currentPage = 1;
    _hasMore = true;
    fetchCocktails();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;

    _searchQuery = query;
    _cocktails.clear();
    _currentPage = 1;
    _hasMore = true;
    fetchCategories();
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
      final newCocktails = await _cocktailRepository.getCocktails(
        _currentPage,
        _selectedCategory,
        _alcoholicFilter,
        _searchQuery,
        _sortBy,
      );
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
