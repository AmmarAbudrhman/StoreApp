import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/core/constants/app_colors.dart';
import 'package:store_app/features/products/presentation/components/product_card.dart';
import 'package:store_app/features/products/presentation/providers/product_provider.dart';
import 'package:store_app/shared/components/empty_state.dart';
import 'package:store_app/shared/components/screen_layout.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return ScreenLayout(
      title: 'My Favorites',
      icon: Icons.favorite,
      body: Container(
        color: AppColors.background,
        child: favorites.isEmpty
            ? const EmptyState(
                icon: Icons.favorite_border,
                title: 'No favorites yet',
                subtitle: 'Start adding products to your favorites',
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: favorites[index],
                    isManageMode: false,
                  );
                },
              ),
      ),
    );
  }
}
