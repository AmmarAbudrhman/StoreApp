import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/core/constants/app_routes.dart';
import 'package:store_app/features/orders/presentation/providers/order_provider.dart';
import 'package:store_app/shared/components/empty_state.dart';
import 'package:store_app/shared/components/loading_widget.dart';
import 'package:store_app/shared/components/order_card.dart';
import 'package:store_app/shared/components/screen_layout.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderNotifierProvider);

    return ScreenLayout(
      title: 'Orders',
      icon: Icons.shopping_bag,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.addOrder);
          },
        ),
      ],
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'No orders found',
              subtitle: 'Orders will appear here once created',
              action: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.addOrder);
                },
                icon: const Icon(Icons.add),
                label: const Text('Create Order'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(orderNotifierProvider.notifier).loadOrders();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(
                  order: order,
                  onViewDetails: (orderId) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.orderDetails,
                      arguments: orderId,
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading orders: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(orderNotifierProvider.notifier).loadOrders();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
