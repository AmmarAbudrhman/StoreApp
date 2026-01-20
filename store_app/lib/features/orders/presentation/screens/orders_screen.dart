import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/core/constants/app_routes.dart';
import 'package:store_app/features/orders/presentation/providers/order_provider.dart';
import 'package:store_app/shared/components/empty_state.dart';
import 'package:store_app/shared/components/loading_widget.dart';
import 'package:store_app/features/orders/presentation/components/order_card.dart';
import 'package:store_app/shared/components/screen_layout.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          // Filter orders based on search query
          final filteredOrders = orders.where((order) {
            if (_searchQuery.isEmpty) return true;

            final query = _searchQuery.toLowerCase();
            final customerName = order.customerName.toLowerCase();
            final orderId = order.id.toString().toLowerCase();

            return customerName.contains(query) || orderId.contains(query);
          }).toList();

          return Column(
            children: [
              // Search TextField
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by customer name or order ID',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              // Orders List
              Expanded(
                child: filteredOrders.isEmpty && _searchQuery.isNotEmpty
                    ? EmptyState(
                        icon: Icons.search_off,
                        title: 'No orders found',
                        subtitle: 'Try adjusting your search terms',
                      )
                    : filteredOrders.isEmpty
                    ? EmptyState(
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
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          ref.read(orderNotifierProvider.notifier).loadOrders();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            return OrderCard(
                              order: order,
                              onViewDetails: (orderId) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.orderDetails,
                                  arguments: orderId,
                                );
                              },
                              onEdit: (orderId) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.editOrder,
                                  arguments: order,
                                );
                              },
                              onDelete: (orderId) async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Order'),
                                    content: const Text(
                                      'Are you sure you want to delete this order?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed == true) {
                                  try {
                                    await ref
                                        .read(orderNotifierProvider.notifier)
                                        .deleteOrder(orderId);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Order deleted successfully',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error deleting order: $e',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
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
