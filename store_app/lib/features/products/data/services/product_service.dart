import 'package:store_app/core/constants/api_constants.dart';
import 'package:store_app/core/services/api_service.dart';
import 'package:store_app/features/products/data/models/product_model.dart';

class ProductService {
  final ApiService _api = ApiService();

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _api.get(
        url: '${ApiConstants.baseUrl}${ApiConstants.products}',
      );

      // Check if response has the new API format
      if (response is Map && response['isSuccess'] == true) {
        List<dynamic> data = response['data'];
        return data.map((item) => ProductModel.fromJson(item)).toList();
      }

      // Fallback to old format (direct array)
      List<dynamic> data = response;
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _api.get(
        url: '${ApiConstants.baseUrl}${ApiConstants.products}/$id',
      );

      // Check if response has the new API format
      if (response is Map && response['isSuccess'] == true) {
        return ProductModel.fromJson(response['data']);
      }

      // Fallback to old format
      return ProductModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _api.get(
        url:
            '${ApiConstants.baseUrl}${ApiConstants.products}/category/$category',
      );

      // Check if response has the new API format
      if (response is Map && response['isSuccess'] == true) {
        List<dynamic> data = response['data'];
        return data.map((item) => ProductModel.fromJson(item)).toList();
      }

      // Fallback to old format (direct array)
      List<dynamic> data = response;
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load products by category: $e');
    }
  }

  Future<List<String>> getAllCategories() async {
    try {
      List<dynamic> data = await _api.get(
        url: '${ApiConstants.baseUrl}${ApiConstants.categories}',
      );
      return data.map((item) => item.toString()).toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }



 

  Future<void> deleteProduct(int id) async {
    try {
      await _api.delete(
        url: '${ApiConstants.baseUrl}${ApiConstants.products}/$id',
      );
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Future<ProductModel> addProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _api.post(
        url: '${ApiConstants.baseUrl}${ApiConstants.products}',
        body: productData,
      );
      return ProductModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<ProductModel> updateProduct(
    int id,
    Map<String, dynamic> productData,
  ) async {
    try {
      final response = await _api.put(
        url: '${ApiConstants.baseUrl}${ApiConstants.products}/$id',
        body: productData,
      );
      return ProductModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
}
