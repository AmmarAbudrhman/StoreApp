import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/features/categories/data/models/category_model.dart';
import 'package:store_app/features/categories/data/services/category_service.dart';

final categoryServiceProvider = Provider((ref) => CategoryService());

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final categoryService = ref.read(categoryServiceProvider);
  return categoryService.getAllCategories();
});

final categoryByIdProvider = FutureProvider.family<CategoryModel, int>((
  ref,
  id,
) async {
  final categoryService = ref.read(categoryServiceProvider);
  return categoryService.getCategoryById(id);
});

class CategoryNotifier extends AsyncNotifier<List<CategoryModel>> {
  @override
  Future<List<CategoryModel>> build() async {
    return loadCategories();
  }

  Future<List<CategoryModel>> loadCategories() async {
    state = const AsyncValue.loading();
    try {
      final categoryService = ref.read(categoryServiceProvider);
      final categories = await categoryService.getAllCategories();
      state = AsyncValue.data(categories);
      return categories;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      throw Exception(
        'Failed to load categories. Please check your internet connection and try again.',
      );
    }
  }

  Future<void> createCategory({
    required String name,
    required String description,
    required String imageUrl,
  }) async {
    try {
      final categoryService = ref.read(categoryServiceProvider);
      await categoryService.createCategory(
        name: name,
        description: description,
        imageUrl: imageUrl,
      );
      await loadCategories();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      throw Exception(
        'Failed to create category. Please check your input and try again.',
      );
    }
  }

  Future<void> updateCategory({
    required int id,
    required String name,
    required String description,
    required String imageUrl,
  }) async {
    try {
      final categoryService = ref.read(categoryServiceProvider);
      await categoryService.updateCategory(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
      );
      await loadCategories();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      throw Exception(
        'Failed to update category. Please check your changes and try again.',
      );
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final categoryService = ref.read(categoryServiceProvider);
      await categoryService.deleteCategory(id);
      await loadCategories();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      throw Exception('Failed to delete category. Please try again.');
    }
  }
}

final categoryNotifierProvider =
    AsyncNotifierProvider<CategoryNotifier, List<CategoryModel>>(
      CategoryNotifier.new,
    );
