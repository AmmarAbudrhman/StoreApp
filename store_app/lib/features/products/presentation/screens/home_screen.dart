import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/core/constants/app_colors.dart';
import 'package:store_app/core/constants/app_routes.dart';
import 'package:store_app/features/products/presentation/components/product_card.dart';
import 'package:store_app/features/products/presentation/providers/product_provider.dart';
import 'package:store_app/shared/components/badge_icon.dart';
import 'package:store_app/shared/components/loading_widget.dart';

class HomeScreen extends ConsumerWidget {
  final bool isManageMode;

  const HomeScreen({super.key, this.isManageMode = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(allProductsProvider);
    final cartCount = ref.watch(cartCountProvider);
    final favoritesCount = ref.watch(favoritesCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        title: Text('Store', style: Theme.of(context).textTheme.displaySmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.search);
            },
          ),
          BadgeIcon(
            icon: Icons.favorite_border,
            count: favoritesCount,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.favorites);
            },
          ),
          BadgeIcon(
            icon: Icons.shopping_cart_outlined,
            count: cartCount,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
                isManageMode: isManageMode,
              );
            },
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Error: $error',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(allProductsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isManageMode
          ? FloatingActionButton.large(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addProduct);
              },
              child: const Icon(Icons.add, size: 36),
            )
          : null,
    );
  }
}
