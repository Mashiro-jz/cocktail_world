import 'package:coctail_world/models/cocktail.dart';
import 'package:coctail_world/screens/cocktail_details_screen.dart';
import 'package:coctail_world/services/cocktail_repository.dart';
import 'package:flutter/material.dart';

class CoctailScreen extends StatefulWidget {
  const CoctailScreen({super.key});

  @override
  State<CoctailScreen> createState() => _CoctailScreenState();
}

class _CoctailScreenState extends State<CoctailScreen> {
  final CocktailRepository _cocktailRepository = CocktailRepository();
  List<Cocktail> cocktails = [];
  bool _isLoading = true;

  Future<void> _loadCocktails() async {
    final loadedCocktails = await _cocktailRepository.getCocktails();
    setState(() {
      cocktails = loadedCocktails;
      _isLoading = false;
    });
  }

  @override
  initState() {
    super.initState();
    _loadCocktails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cocktail Details')),
      body: Column(
        children: [
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
                trailing: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => controller.clear(),
                  ),
                ],
                hintText: 'Search cocktails',
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
                  return cocktails
                      .where(
                        (cocktail) => cocktail.name.toLowerCase().contains(
                          controller.text.toLowerCase(),
                        ),
                      )
                      .map((Cocktail cocktail) {
                        return ListTile(
                          title: Text(cocktail.name),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CocktailDetailsScreen(
                                  coctailId: cocktail.id.toString(),
                                ),
                              ),
                            );
                          },
                        );
                      })
                      .toList();
                },
          ),

          Expanded(
            child: Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: cocktails.length,
                      itemBuilder: (context, index) {
                        final cocktail = cocktails[index];
                        return ListTile(
                          title: Text(cocktail.name),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CocktailDetailsScreen(
                                  coctailId: cocktail.id.toString(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
