import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoctailScreen extends StatefulWidget {
  final String coctailId;

  const CoctailScreen({super.key, required this.coctailId});

  @override
  State<CoctailScreen> createState() => _CoctailScreenState();
}

class _CoctailScreenState extends State<CoctailScreen> {
  bool _isSuccess = false;

  Future<bool> fetchCocktailDetails() async {
    setState(() {
      _isSuccess = false;
    });
    // Simulate a network request or database query
    var url = Uri.https(
      'cocktails.solvro.pl',
      '/api/v1/cocktails/${widget.coctailId}',
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _isSuccess = true;
      });
      var cocktailName = jsonDecode(response.body)['data']['name'];

      if (kDebugMode) {
        print('Response code: ${response.statusCode}');
        print('Cocktail name: $cocktailName');
      }

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cocktail Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Details for cocktail ID: ${widget.coctailId}'),
            ElevatedButton(
              onPressed: fetchCocktailDetails,
              child: const Text('Fetch Cocktail Details'),
            ),
            if (_isSuccess)
              const Text('Cocktail details fetched successfully!')
            else
              const Text('Failed to fetch cocktail details.'),
          ],
        ),
      ),
    );
  }
}
