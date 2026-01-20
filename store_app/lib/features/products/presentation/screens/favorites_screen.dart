import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/features/products/presentation/components/product_card.dart';
import 'package:store_app/features/products/presentation/providers/product_provider.dart';
import 'package:store_app/shared/components/empty_state.dart';
import 'package:store_app/shared/components/app_header.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppHeader(
          title: 'My Favorites',
          icon: Icons.favorite,
          showBackButton: true,
        ),
      ),
      body: SafeArea(
        child: favorites.isEmpty
            ? Container(
                color: const Color(0xFFF8F9FA),
                child: const EmptyState(
                  icon: Icons.favorite_border,
                  title: 'No favorites yet',
                  subtitle: 'Start adding products to your favorites',
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
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
      ),
    );
  }
}
