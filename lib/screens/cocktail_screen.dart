import 'package:coctail_world/models/cocktail.dart';
import 'package:coctail_world/providers/cocktail_provider.dart';
import 'package:coctail_world/screens/cocktail_details_screen.dart';
import 'package:coctail_world/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoctailScreen extends StatefulWidget {
  const CoctailScreen({super.key});

  @override
  State<CoctailScreen> createState() => _CoctailScreenState();
}

class _CoctailScreenState extends State<CoctailScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final provider = context.read<CocktailProvider>();
    provider.setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final cocktailProvider = Provider.of<CocktailProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cocktails'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: Provider.of<ThemeProvider>(
              context,
              listen: false,
            ).toggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: SearchBar(
                    controller: _searchController,
                    hintText: 'Search cocktails',
                    leading: const Icon(Icons.search),
                    trailing: [
                      if (cocktailProvider.query?.isNotEmpty == true)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: _buildCocktailList(cocktailProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildCocktailList(CocktailProvider cocktailProvider) {
    if (cocktailProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (cocktailProvider.error != null) {
      return _Message(
        icon: Icons.error,
        text: 'Wystąpił błąd: ${cocktailProvider.error}',
        onRetry: () => cocktailProvider.fetchCocktails(),
      );
    }
    if (cocktailProvider.list.isEmpty) {
      return const _Message(icon: Icons.search_off, text: 'Brak wyników');
    }

    return GridView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      // Liczba kolumn dopasowuje się do szerokości ekranu
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: cocktailProvider.list.length,
      itemBuilder: (context, index) {
        final cocktail = cocktailProvider.list[index];
        return _CocktailCard(
          cocktail: cocktail,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CocktailDetailsScreen(coctailId: cocktail.id.toString()),
            ),
          ),
        );
      },
    );
  }
}

class _CocktailCard extends StatelessWidget {
  final Cocktail cocktail;
  final VoidCallback onTap;

  const _CocktailCard({required this.cocktail, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accent = cocktail.alcoholic ? scheme.primary : Colors.green.shade600;

    final placeholder = ColoredBox(
      color: scheme.primaryContainer,
      child: Center(
        child: Icon(
          Icons.local_bar,
          size: 40,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  cocktail.imageUrl == null
                      ? placeholder
                      : Image.network(
                          cocktail.imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) =>
                              progress == null ? child : placeholder,
                          errorBuilder: (context, error, stackTrace) =>
                              placeholder,
                        ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        cocktail.alcoholic ? 'Alcoholic' : 'Non-alcoholic',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cocktail.name,
                    style: textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cocktail.category ?? 'N/A',
                    style: textTheme.bodySmall?.copyWith(color: scheme.primary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  const _Message({required this.icon, required this.text, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48),
          const SizedBox(height: 12),
          Text(text),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Spróbuj ponownie'),
            ),
          ],
        ],
      ),
    );
  }
}
