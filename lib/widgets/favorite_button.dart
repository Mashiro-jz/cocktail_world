import 'package:coctail_world/providers/favorites_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  final String id;
  final bool overlay;

  const FavoriteButton({super.key, required this.id, this.overlay = false});

  @override
  Widget build(BuildContext context) {
    final isFav = context.select<FavoritesProvider, bool>(
      (f) => f.isFavorite(id),
    );

    return IconButton(
      tooltip: isFav ? 'deleteFavorite'.tr() : 'addFavorite'.tr(),
      visualDensity: overlay ? VisualDensity.compact : null,
      style: overlay
          ? IconButton.styleFrom(
              backgroundColor: Colors.black38,
              foregroundColor: Colors.white,
            )
          : null,
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? Colors.red : null,
      ),
      onPressed: () => context.read<FavoritesProvider>().toggleFavorite(id),
    );
  }
}
