import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/features/products/data/models/product_model.dart';
import 'package:store_app/features/products/presentation/components/product_card.dart';
import 'package:store_app/features/products/presentation/providers/product_provider.dart';
import 'package:store_app/shared/components/custom_text_field.dart';
import 'package:store_app/shared/components/empty_state.dart';
import 'package:store_app/shared/components/loading_widget.dart';
import 'package:store_app/shared/components/app_header.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _filteredProducts = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(List<ProductModel> allProducts, String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = allProducts;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _filteredProducts = allProducts.where((product) {
        final titleLower = product.title.toLowerCase();
        final descLower = product.description.toLowerCase();
        final categoryLower = product.category.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            descLower.contains(searchLower) ||
            categoryLower.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(allProductsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppHeader(
          title: 'Search Products',
          icon: Icons.search,
          showBackButton: true,
        ),
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF8F9FA),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomTextField(
                  controller: _searchController,
                  labelText: 'Search products...',
                  prefixIcon: Icons.search,
                  onChanged: (query) {
                    productsAsync.whenData((products) {
                      _filterProducts(products, query);
                    });
                  },
                ),
              ),
              Expanded(
                child: productsAsync.when(
                  data: (products) {
                    final displayProducts = _isSearching
                        ? _filteredProducts
                        : products;

                    if (displayProducts.isEmpty) {
                      if (_isSearching) {
                        return EmptyState(
                          icon: Icons.search_off,
                          title: 'No products found',
                          subtitle: 'Try different keywords',
                        );
                      } else {
                        return const EmptyState(
                          icon: Icons.inventory_2_outlined,
                          title: 'No products available',
                        );
                      }
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: displayProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: displayProducts[index],
                          isManageMode: false,
                        );
                      },
                    );
                  },
                  loading: () => const LoadingWidget(),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text('Error loading products: $error'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(allProductsProvider);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
