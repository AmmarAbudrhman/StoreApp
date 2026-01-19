import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/core/constants/app_colors.dart';
import 'package:store_app/core/constants/app_routes.dart';
import 'package:store_app/features/products/data/models/product_model.dart';
import 'package:store_app/features/products/data/services/product_service.dart';
import 'package:store_app/features/products/presentation/providers/product_provider.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;
  final bool isManageMode;

  const ProductCard({
    super.key,
    required this.product,
    this.isManageMode = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: isManageMode
          ? null
          : () {
              Navigator.pushNamed(
                context,
                AppRoutes.productDetails,
                arguments: product,
              );
            },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  product.rating.rate.toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${product.rating.count})',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isManageMode)
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.updateProduct,
                        arguments: product,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Product'),
                          content: const Text(
                            'Are you sure you want to delete this product?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        try {
                          final productService = ref.read(
                            productServiceProvider,
                          );
                          await productService.deleteProduct(product.id);
                          ref.invalidate(allProductsProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product deleted successfully'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete product: $e'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
