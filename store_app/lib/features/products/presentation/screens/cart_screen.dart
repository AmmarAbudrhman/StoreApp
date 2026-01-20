import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/core/constants/app_colors.dart';
import 'package:store_app/features/products/presentation/components/cart_item_card.dart';
import 'package:store_app/features/products/presentation/providers/product_provider.dart';
import 'package:store_app/shared/components/custom_button.dart';
import 'package:store_app/shared/components/empty_state.dart';
import 'package:store_app/shared/components/screen_layout.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartTotal = ref.watch(cartTotalProvider);

    return ScreenLayout(
      title: 'My Cart',
      icon: Icons.shopping_cart,
      body: Container(
        color: AppColors.background,
        child: cartItems.isEmpty
            ? const EmptyState(
                icon: Icons.shopping_cart_outlined,
                title: 'Your cart is empty',
                subtitle: 'Add some products to get started',
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final product = cartItems[index];
                        return CartItemCard(
                          product: product,
                          onRemove: () {
                            ref
                                .read(cartProvider.notifier)
                                .removeFromCart(index);
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total: \$${cartTotal.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'Checkout',
                          onPressed: () {
                            // TODO: Implement checkout functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Checkout feature coming soon!'),
                              ),
                            );
                          },
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
