import 'package:store_app/core/constants/api_constants.dart';
import 'package:store_app/core/services/api_service.dart';
import 'package:store_app/features/categories/data/models/category_model.dart';

class CategoryService {
  final ApiService _api = ApiService();

  Future<List<CategoryModel>> getAllCategories() async {
    final response = await _api.get(
      url: '${ApiConstants.baseUrl}${ApiConstants.categories}',
    );

    if (response['isSuccess'] == true && response['data'] != null) {
      final List<dynamic> data = response['data'];
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    }
    throw Exception(response['message'] ?? 'Failed to load categories');
  }

  Future<CategoryModel> getCategoryById(int id) async {
    final response = await _api.get(
      url: '${ApiConstants.baseUrl}${ApiConstants.categories}/$id',
    );

    if (response['isSuccess'] == true && response['data'] != null) {
      return CategoryModel.fromJson(response['data']);
    }
    throw Exception(response['message'] ?? 'Failed to load category');
  }

  Future<CategoryModel> createCategory({
    required String name,
    required String description,
    required String imageUrl,
  }) async {
    final response = await _api.post(
      url: '${ApiConstants.baseUrl}${ApiConstants.categories}',
      body: {'name': name, 'description': description, 'imageUrl': imageUrl},
    );

    if (response['isSuccess'] == true && response['data'] != null) {
      return CategoryModel.fromJson(response['data']);
    }
    throw Exception(response['message'] ?? 'Failed to create category');
  }

  Future<CategoryModel> updateCategory({
    required int id,
    required String name,
    required String description,
    required String imageUrl,
  }) async {
    final response = await _api.put(
      url: '${ApiConstants.baseUrl}${ApiConstants.categories}/$id',
      body: {'name': name, 'description': description, 'imageUrl': imageUrl},
    );

    if (response['isSuccess'] == true && response['data'] != null) {
      return CategoryModel.fromJson(response['data']);
    }
    throw Exception(response['message'] ?? 'Failed to update category');
  }

  Future<bool> deleteCategory(int id) async {
    final response = await _api.delete(
      url: '${ApiConstants.baseUrl}${ApiConstants.categories}/$id',
    );

    if (response['isSuccess'] == true) {
      return response['data'] ?? true;
    }
    throw Exception(response['message'] ?? 'Failed to delete category');
  }
}
