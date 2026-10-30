import 'package:coctail_world/models/cocktail.dart';
import 'package:coctail_world/providers/cocktail_provider.dart';
import 'package:coctail_world/providers/favorites_provider.dart';
import 'package:coctail_world/providers/theme_provider.dart';
import 'package:coctail_world/screens/cocktail_details_screen.dart';
import 'package:coctail_world/services/cocktail_repository.dart';
import 'package:coctail_world/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:provider/provider.dart';

class CoctailScreen extends StatefulWidget {
  const CoctailScreen({super.key});

  @override
  State<CoctailScreen> createState() => _CoctailScreenState();
}

class _CoctailScreenState extends State<CoctailScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CocktailRepository _repository = CocktailRepository();

  // Cache koktajli ulubionych (id -> koktajl), żeby nie pobierać ich co chwilę
  final Map<String, Cocktail> _favoritesCache = {};
  bool _onlyFavorites = false;
  bool _loadingFavorites = false;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  void _onSearchChanged() {
    final provider = context.read<CocktailProvider>();
    provider.setSearchQuery(_searchController.text);
  }

  void _onScroll() {
    // W trybie ulubionych nie dociągamy kolejnych stron z API
    if (_onlyFavorites) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CocktailProvider>().fetchCocktails();
    }
  }

  void _toggleFavoritesOnly() {
    setState(() => _onlyFavorites = !_onlyFavorites);
    if (_onlyFavorites) _loadMissingFavorites();
  }

  /// Ulubione mogą nie być jeszcze na liście (paginacja), więc brakujące
  /// doładowujemy po id.
  Future<void> _loadMissingFavorites() async {
    final ids = context.read<FavoritesProvider>().favoriteIds;

    // Najpierw wykorzystaj to, co już jest załadowane na głównej liście
    for (final c in context.read<CocktailProvider>().list) {
      final id = c.id.toString();
      if (ids.contains(id)) _favoritesCache[id] = c;
    }

    final missing = ids
        .where((id) => !_favoritesCache.containsKey(id))
        .toList();
    if (missing.isEmpty) return;

    setState(() => _loadingFavorites = true);
    final results = await Future.wait(
      missing.map((id) async {
        try {
          return await _repository.getCocktailDetails(id);
        } catch (_) {
          return null;
        }
      }),
    );
    for (final c in results) {
      if (c != null) _favoritesCache[c.id.toString()] = c;
    }
    if (mounted) setState(() => _loadingFavorites = false);
  }

  @override
  Widget build(BuildContext context) {
    final cocktailProvider = Provider.of<CocktailProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cocktails'),
        actions: [
          IconButton(
            tooltip: _onlyFavorites ? 'Pokaż wszystkie' : 'Tylko ulubione',
            icon: Icon(
              _onlyFavorites ? Icons.favorite : Icons.favorite_border,
              color: _onlyFavorites ? Colors.red : null,
            ),
            onPressed: _toggleFavoritesOnly,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_by_alpha),
            tooltip: 'Sortuj',
            // initialValue podświetli opcję, która jest aktualnie wybrana w Providerze
            initialValue:
                cocktailProvider.sort, // upewnij się, że tak nazwałeś getter!
            // onSelected odpali się, gdy użytkownik kliknie jedną z opcji
            onSelected: (String value) {
              cocktailProvider.setSortBy(value);
            },

            // itemBuilder buduje listę dostępnych opcji w menu
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: '+name', child: Text('Nazwa (A-Z)')),
              const PopupMenuItem(value: '-name', child: Text('Nazwa (Z-A)')),
              const PopupMenuItem(
                value: '+category',
                child: Text('Kategoria (A-Z)'),
              ),
              const PopupMenuItem(
                value: '-category',
                child: Text('Kategoria (Z-A)'),
              ),
            ],
          ),
          IconButton(
            icon: Theme.of(context).brightness == Brightness.dark
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.dark_mode),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width:
                    double.infinity, // Rozciąga przełącznik na całą szerokość
                child: SegmentedButton<bool?>(
                  segments: const [
                    ButtonSegment<bool?>(
                      value: null,
                      label: Text('Wszystkie'),
                      icon: Icon(Icons.list),
                    ),
                    ButtonSegment<bool?>(
                      value: true,
                      label: Text('Z alkoholem'),
                      icon: Icon(Icons.wine_bar),
                    ),
                    ButtonSegment<bool?>(
                      value: false,
                      label: Text('Bez alkoholu'),
                      icon: Icon(Icons.no_drinks),
                    ),
                  ],
                  // SegmentedButton wymaga Seta (zbioru), więc owijamy wartość w {}
                  selected: {cocktailProvider.alcoholicFilter},
                  onSelectionChanged: (Set<bool?> newSelection) {
                    // newSelection.first wyciąga pierwszą (i jedyną) klikniętą wartość
                    cocktailProvider.setAlcoholicFilter(newSelection.first);
                  },
                ),
              ),
            ),
            ChipsChoice<String?>.single(
              value: cocktailProvider.category,
              onChanged: (value) => cocktailProvider.setCategory(value!),
              choiceItems: C2Choice.listFrom<String, String>(
                source: cocktailProvider
                    .categories, // Używamy dynamicznej listy z API!
                value: (index, item) => item,
                label: (index, item) => item,
              ),
              wrapped: false,
            ),
            Expanded(
              child: _onlyFavorites
                  ? _buildFavoritesList(cocktailProvider)
                  : _buildCocktailList(cocktailProvider),
            ),
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

    return _buildGrid(cocktailProvider.list);
  }

  Widget _buildFavoritesList(CocktailProvider cocktailProvider) {
    return Consumer<FavoritesProvider>(
      builder: (context, favorites, _) {
        final query = _searchController.text.trim().toLowerCase();
        final items = favorites.favoriteIds
            .map((id) => _favoritesCache[id])
            .whereType<Cocktail>()
            .where((c) => query.isEmpty || c.name.toLowerCase().contains(query))
            .where(
              (c) =>
                  cocktailProvider.alcoholicFilter == null ||
                  c.alcoholic == cocktailProvider.alcoholicFilter,
            )
            .toList();

        if (_loadingFavorites && items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (items.isEmpty) {
          return const _Message(
            icon: Icons.favorite_border,
            text: 'Brak ulubionych',
          );
        }
        return _buildGrid(items);
      },
    );
  }

  Widget _buildGrid(List<Cocktail> items) {
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
      itemCount: items.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        final cocktail = items[index];
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
                    top: 4,
                    left: 4,
                    child: FavoriteButton(
                      id: cocktail.id.toString(),
                      overlay: true,
                    ),
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
