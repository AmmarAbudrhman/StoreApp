import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/features/customers/data/models/customer_model.dart';
import 'package:store_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:store_app/features/orders/data/models/order_item_model.dart';
import 'package:store_app/features/orders/presentation/providers/order_provider.dart';
import 'package:store_app/features/products/data/models/product_model.dart';
import 'package:store_app/features/products/presentation/providers/product_provider.dart';
import 'package:store_app/shared/components/screen_layout.dart';

class AddOrderScreen extends ConsumerStatefulWidget {
  const AddOrderScreen({super.key});

  @override
  ConsumerState<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends ConsumerState<AddOrderScreen> {
  CustomerModel? _selectedCustomer;
  final List<OrderItemModel> _orderItems = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customerNotifierProvider);
    final productsAsync = ref.watch(allProductsProvider);

    return ScreenLayout(
      title: 'Add Order',
      icon: Icons.add_shopping_cart,
      body: customersAsync.when(
        data: (customers) => productsAsync.when(
          data: (products) => _buildForm(customers, products),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildForm(
    List<CustomerModel> customers,
    List<ProductModel> products,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Selection
          const Text(
            'Select Customer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<CustomerModel>(
            value: _selectedCustomer,
            hint: const Text('Choose a customer'),
            items: customers.map((customer) {
              return DropdownMenuItem(
                value: customer,
                child: Text(customer.fullName),
              );
            }).toList(),
            onChanged: (customer) {
              setState(() {
                _selectedCustomer = customer;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a customer';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Order Items
          const Text(
            'Order Items',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._orderItems.map((item) => _buildOrderItemTile(item, products)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showAddProductDialog(products),
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
          ),
          const SizedBox(height: 24),

          // Total
          if (_orderItems.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_calculateTotal().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitOrder,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Create Order'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemTile(OrderItemModel item, List<ProductModel> products) {
    final product = products.firstWhere((p) => p.id == item.productId);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(product.title),
        subtitle: Text('Quantity: ${item.quantity}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('\$${item.totalPrice.toStringAsFixed(2)}'),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  _orderItems.remove(item);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(List<ProductModel> products) {
    ProductModel? selectedProduct;
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<ProductModel>(
                value: selectedProduct,
                hint: const Text('Select product'),
                items: products.map((product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Text(product.title),
                  );
                }).toList(),
                onChanged: (product) {
                  setState(() {
                    selectedProduct = product;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Quantity:'),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: quantity > 1
                        ? () {
                            setState(() {
                              quantity--;
                            });
                          }
                        : null,
                  ),
                  Text('$quantity'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedProduct == null
                  ? null
                  : () {
                      final existingItem = _orderItems.indexWhere(
                        (item) => item.productId == selectedProduct!.id,
                      );
                      if (existingItem != -1) {
                        // Update quantity
                        setState(() {
                          _orderItems[existingItem] = OrderItemModel(
                            id: _orderItems[existingItem].id,
                            productId: selectedProduct!.id,
                            productName: selectedProduct!.title,
                            quantity:
                                _orderItems[existingItem].quantity + quantity,
                            unitPrice: selectedProduct!.price,
                          );
                        });
                      } else {
                        // Add new item
                        setState(() {
                          _orderItems.add(
                            OrderItemModel(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch, // temp id
                              productId: selectedProduct!.id,
                              productName: selectedProduct!.title,
                              quantity: quantity,
                              unitPrice: selectedProduct!.price,
                            ),
                          );
                        });
                      }
                      Navigator.pop(context);
                    },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotal() {
    return _orderItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> _submitOrder() async {
    if (_selectedCustomer == null || _orderItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a customer and add items'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(orderNotifierProvider.notifier)
          .createOrder(customerId: _selectedCustomer!.id, items: _orderItems);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
