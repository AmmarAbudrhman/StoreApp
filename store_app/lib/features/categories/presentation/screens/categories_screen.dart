import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/core/constants/app_routes.dart';
import 'package:store_app/features/categories/presentation/providers/category_provider.dart';
import 'package:store_app/features/categories/presentation/components/category_card.dart';
import 'package:store_app/shared/components/empty_state.dart';
import 'package:store_app/shared/components/loading_widget.dart';
import 'package:store_app/shared/components/screen_layout.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryNotifierProvider);

    return ScreenLayout(
      title: 'Categories',
      icon: Icons.category,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.addCategory);
          },
        ),
      ],
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return EmptyState(
              icon: Icons.category_outlined,
              title: 'No categories found',
              subtitle: 'Add your first category to get started',
              action: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.addCategory);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Category'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(categoryNotifierProvider.notifier).loadCategories();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  category: category,
                  onEdit: (categoryId) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editCategory,
                      arguments: category,
                    );
                  },
                  onDelete: (int categoryId) async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Category'),
                        content: const Text(
                          'Are you sure you want to delete this category?',
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
                            .read(categoryNotifierProvider.notifier)
                            .deleteCategory(categoryId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Category deleted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error deleting category: $e'),
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
              Text('Error loading categories: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(categoryNotifierProvider.notifier).loadCategories();
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
