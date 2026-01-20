import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/core/constants/app_routes.dart';
import 'package:store_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:store_app/shared/components/customer_card.dart';
import 'package:store_app/shared/components/empty_state.dart';
import 'package:store_app/shared/components/loading_widget.dart';
import 'package:store_app/shared/components/screen_layout.dart';

class CustomersScreen extends ConsumerWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customerNotifierProvider);

    return ScreenLayout(
      title: 'Customers',
      icon: Icons.people,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.addCustomer);
          },
        ),
      ],
      body: customersAsync.when(
        data: (customers) {
          if (customers.isEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              title: 'No customers found',
              subtitle: 'Add your first customer to get started',
              action: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.addCustomer);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Customer'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(customerNotifierProvider.notifier).loadCustomers();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return CustomerCard(
                  customer: customer,
                  onEdit: (customerId) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editCustomer,
                      arguments: customer,
                    );
                  },
                  onDelete: (customerId) async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Customer'),
                        content: const Text(
                          'Are you sure you want to delete this customer?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
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
                            .read(customerNotifierProvider.notifier)
                            .deleteCustomer(customerId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Customer deleted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error deleting customer: $e'),
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
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading customers: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(customerNotifierProvider.notifier).loadCustomers();
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
