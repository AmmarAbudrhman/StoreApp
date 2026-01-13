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

class CategoryNotifier extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  final CategoryService _categoryService;

  CategoryNotifier(this._categoryService) : super(const AsyncValue.loading()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    state = const AsyncValue.loading();
    try {
      final categories = await _categoryService.getAllCategories();
      state = AsyncValue.data(categories);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createCategory({
    required String name,
    required String description,
    required String imageUrl,
  }) async {
    try {
      await _categoryService.createCategory(
        name: name,
        description: description,
        imageUrl: imageUrl,
      );
      await loadCategories();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateCategory({
    required int id,
    required String name,
    required String description,
    required String imageUrl,
  }) async {
    try {
      await _categoryService.updateCategory(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
      );
      await loadCategories();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _categoryService.deleteCategory(id);
      await loadCategories();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

final categoryNotifierProvider =
    StateNotifierProvider<CategoryNotifier, AsyncValue<List<CategoryModel>>>((
      ref,
    ) {
      final categoryService = ref.read(categoryServiceProvider);
      return CategoryNotifier(categoryService);
    });
