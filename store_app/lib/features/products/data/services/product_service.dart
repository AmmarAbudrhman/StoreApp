import 'package:store_app/core/constants/api_constants.dart';
import 'package:store_app/core/services/api_service.dart';
import 'package:store_app/features/products/data/models/product_model.dart';

class ProductService {
  final ApiService _api = ApiService();

  Future<List<ProductModel>> getAllProducts() async {
    try {
      List<dynamic> data = await _api.get(
        url: '${ApiConstants.baseUrl}${ApiConstants.products}',
      );
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final data = await _api.get(
        url: '${ApiConstants.baseUrl}${ApiConstants.products}/$id',
      );
      return ProductModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      List<dynamic> data = await _api.get(
        url:
            '${ApiConstants.baseUrl}${ApiConstants.products}/category/$category',
      );
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

  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      final data = await _api.post(
        url: '${ApiConstants.baseUrl}${ApiConstants.products}',
        body: product.toJson(),
      );
      return ProductModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<ProductModel> updateProduct(int id, ProductModel product) async {
    try {
      final data = await _api.put(
        url: '${ApiConstants.baseUrl}${ApiConstants.products}/$id',
        body: product.toJson(),
      );
      return ProductModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
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
}
