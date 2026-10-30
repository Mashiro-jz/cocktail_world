import 'package:coctail_world/models/cocktail.dart';
import 'package:coctail_world/models/ingredient.dart';
import 'package:coctail_world/providers/theme_provider.dart';
import 'package:coctail_world/services/cocktail_repository.dart';
import 'package:coctail_world/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CocktailDetailsScreen extends StatefulWidget {
  final String coctailId;

  const CocktailDetailsScreen({super.key, required this.coctailId});

  @override
  State<CocktailDetailsScreen> createState() => _CocktailDetailsScreenState();
}

class _CocktailDetailsScreenState extends State<CocktailDetailsScreen> {
  final CocktailRepository _cocktailRepository = CocktailRepository();
  late Future<Cocktail?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Cocktail?> _load() =>
      _cocktailRepository.getCocktailDetails(widget.coctailId);

  void _retry() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Cocktail?>(
          future: _future,
          builder: (context, snapshot) =>
              Text(snapshot.data?.name ?? 'Cocktail Details'),
        ),
        actions: [
          FavoriteButton(id: widget.coctailId),
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
      body: FutureBuilder<Cocktail?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final cocktail = snapshot.data;
          if (snapshot.hasError || cocktail == null) {
            return _ErrorView(onRetry: _retry);
          }
          return _CocktailContent(cocktail: cocktail);
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 12),
          const Text('Nie udało się wczytać koktajlu'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Spróbuj ponownie'),
          ),
        ],
      ),
    );
  }
}

class _CocktailContent extends StatelessWidget {
  final Cocktail cocktail;

  const _CocktailContent({required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 600;
                final image = _CocktailImage(url: cocktail.imageUrl);
                final info = _CocktailInfo(cocktail: cocktail);

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: image),
                      const SizedBox(width: 24),
                      Expanded(flex: 3, child: info),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [image, const SizedBox(height: 16), info],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CocktailImage extends StatelessWidget {
  final String? url;

  const _CocktailImage({required this.url});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = ColoredBox(
      color: scheme.primaryContainer,
      child: Center(
        child: Icon(
          Icons.local_bar,
          size: 64,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 1,
        child: url == null
            ? placeholder
            : Image.network(
                url!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const Center(child: CircularProgressIndicator()),
                errorBuilder: (context, error, stackTrace) => placeholder,
              ),
      ),
    );
  }
}

class _CocktailInfo extends StatelessWidget {
  final Cocktail cocktail;

  const _CocktailInfo({required this.cocktail});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accent = cocktail.alcoholic ? scheme.primary : Colors.green.shade600;
    final ingredients = cocktail.ingredients ?? const <Ingredient>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(cocktail.name, style: textTheme.headlineSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (cocktail.category != null)
              Chip(
                backgroundColor: scheme.primaryContainer,
                side: BorderSide.none,
                avatar: Icon(
                  Icons.category_outlined,
                  size: 18,
                  color: scheme.onPrimaryContainer,
                ),
                label: Text(
                  cocktail.category!,
                  style: TextStyle(color: scheme.onPrimaryContainer),
                ),
              ),
            Chip(
              backgroundColor: accent,
              side: BorderSide.none,
              avatar: Icon(
                cocktail.alcoholic ? Icons.wine_bar : Icons.no_drinks,
                size: 18,
                color: Colors.white,
              ),
              label: Text(
                cocktail.alcoholic ? 'Alcoholic' : 'Non-alcoholic',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Instructions',
          style: textTheme.titleMedium?.copyWith(color: scheme.primary),
        ),
        const SizedBox(height: 8),
        Text(cocktail.instructions, style: textTheme.bodyLarge),
        if (ingredients.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Ingredients',
            style: textTheme.titleMedium?.copyWith(color: scheme.primary),
          ),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < ingredients.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  _IngredientTile(ingredient: ingredients[i]),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _IngredientTile extends StatelessWidget {
  final Ingredient ingredient;

  const _IngredientTile({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final icon = Icon(Icons.liquor, color: scheme.primary);

    return ListTile(
      leading: SizedBox(
        width: 48,
        height: 48,
        child: ingredient.imageUrl == null
            ? icon
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  ingredient.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => icon,
                ),
              ),
      ),
      title: Text(ingredient.name),
      subtitle: ingredient.type != null ? Text(ingredient.type!) : null,
      trailing: ingredient.percentage != null
          ? Text(
              '${ingredient.percentage}%',
              style: TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}
