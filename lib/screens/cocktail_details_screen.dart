import 'package:coctail_world/models/cocktail.dart';
import 'package:flutter/material.dart';
import 'package:coctail_world/services/cocktail_repository.dart';

class CocktailDetailsScreen extends StatefulWidget {
  final String coctailId;

  const CocktailDetailsScreen({super.key, required this.coctailId});

  @override
  State<CocktailDetailsScreen> createState() => _CocktailDetailsScreenState();
}

class _CocktailDetailsScreenState extends State<CocktailDetailsScreen> {
  final CocktailRepository _cocktailRepository = CocktailRepository();
  Cocktail? _cocktail;

  Future<void> _loadCocktail() async {
    final loadedCocktail = await _cocktailRepository.getCocktailDetails(
      widget.coctailId,
    );
    setState(() {
      _cocktail = loadedCocktail;
    });
  }

  @override
  initState() {
    super.initState();
    _loadCocktail();
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
              const SizedBox(height: 5),
              if (_cocktail == null) ...[
                const CircularProgressIndicator(),
              ] else ...[
                Text('Cocktail Name: ${_cocktail?.name}'),
                Text('Category: ${_cocktail?.category ?? 'N/A'}'),
                Text('Instructions: ${_cocktail?.instructions}'),
                Text('Alcoholic: ${_cocktail!.alcoholic ? 'Yes' : 'No'}'),
                if (_cocktail?.imageUrl != null) ...[
                  Image.network(_cocktail!.imageUrl!),
                ],
                const SizedBox(height: 20),
                const Text(
                  'Ingredients:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                for (var ingredient in _cocktail?.ingredients ?? const []) ...[
                  Text('${ingredient.name} ${ingredient.type ?? ''}'),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
