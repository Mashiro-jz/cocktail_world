import 'dart:convert';

import 'package:coctail_world/models/cocktail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum FetchStatus { initial, loading, success, failure }

class CoctailScreen extends StatefulWidget {
  final String coctailId;

  const CoctailScreen({super.key, required this.coctailId});

  @override
  State<CoctailScreen> createState() => _CoctailScreenState();
}

class _CoctailScreenState extends State<CoctailScreen> {
  FetchStatus _fetchStatus = FetchStatus.initial;
  Cocktail? _cocktail;

  Future<bool> fetchCocktailDetails() async {
    setState(() {
      _fetchStatus = FetchStatus.loading;
    });
    // Simulate a network request or database query
    var url = Uri.https(
      'cocktails.solvro.pl',
      '/api/v1/cocktails/${widget.coctailId}',
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final cocktail = Cocktail.fromJson(jsonDecode(response.body)['data']);

      setState(() {
        _fetchStatus = FetchStatus.success;
        _cocktail = cocktail;
      });

      return true;
    } else {
      setState(() {
        _fetchStatus = FetchStatus.failure;
        if (kDebugMode) {
          print('Failed to fetch cocktail details: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cocktail Details')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Details for cocktail ID: ${widget.coctailId}'),
              ElevatedButton(
                onPressed: fetchCocktailDetails,
                child: const Text('Fetch Cocktail Details'),
              ),
              const SizedBox(height: 20),
              if (_fetchStatus == FetchStatus.loading) ...[
                const CircularProgressIndicator(),
              ] else if (_fetchStatus == FetchStatus.success &&
                  _cocktail != null) ...[
                Text('Cocktail Name: ${_cocktail!.name}'),
                Text('Category: ${_cocktail!.category ?? 'N/A'}'),
                Text('Instructions: ${_cocktail!.instructions}'),
                Text('Alcoholic: ${_cocktail!.alcoholic ? 'Yes' : 'No'}'),
                if (_cocktail!.imageUrl != null) ...[
                  Image.network(_cocktail!.imageUrl!),
                ],
                const SizedBox(height: 20),
                const Text(
                  'Ingredients:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                for (var ingredient in _cocktail!.ingredients) ...[
                  Text(
                    '${ingredient.name} - Type:  ${ingredient.type ?? 'N/A'}',
                  ),
                ],
              ] else if (_fetchStatus == FetchStatus.failure) ...[
                const Text(
                  'Failed to fetch cocktail details. Please try again.',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
