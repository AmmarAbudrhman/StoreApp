import 'package:store_app/core/constants/api_constants.dart';
import 'package:store_app/core/constants/sample_images.dart';
import 'package:store_app/core/services/api_service.dart';
import 'package:store_app/features/products/data/models/product_model.dart';

class ProductService {
  final ApiService _api = ApiService();

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _api.get(
        url: '${ApiConstants.baseUrl}${ApiConstants.products}',
      );

      List<ProductModel> products;

      // Check if response has the new API format
      if (response is Map && response['isSuccess'] == true) {
        List<dynamic> data = response['data'];
        products = data.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        // Fallback to old format (direct array)
        List<dynamic> data = response;
        products = data.map((item) => ProductModel.fromJson(item)).toList();
      }

      // Assign sample images if image is empty or null
      for (int i = 0; i < products.length; i++) {
        if (products[i].image.isEmpty || products[i].image == 'null') {
          products[i] = products[i].copyWith(
            image:
                highQualityProductImages[i % highQualityProductImages.length],
          );
        }
      }

      return products;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _api.get(
        url: '${ApiConstants.baseUrl}${ApiConstants.products}/$id',
      );

      ProductModel product;

      // Check if response has the new API format
      if (response is Map && response['isSuccess'] == true) {
        product = ProductModel.fromJson(response['data']);
      } else {
        // Fallback to old format
        product = ProductModel.fromJson(response);
      }

      // Assign sample image if image is empty or null
      if (product.image.isEmpty || product.image == 'null') {
        product = product.copyWith(
          image: highQualityProductImages[id % highQualityProductImages.length],
        );
      }

      return product;
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

      List<ProductModel> products;

      // Check if response has the new API format
      if (response is Map && response['isSuccess'] == true) {
        List<dynamic> data = response['data'];
        products = data.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        // Fallback to old format (direct array)
        List<dynamic> data = response;
        products = data.map((item) => ProductModel.fromJson(item)).toList();
      }

      // Assign sample images if image is empty or null
      for (int i = 0; i < products.length; i++) {
        if (products[i].image.isEmpty || products[i].image == 'null') {
          products[i] = products[i].copyWith(
            image:
                highQualityProductImages[i % highQualityProductImages.length],
          );
        }
      }

      return products;
    } catch (e) {
      throw Exception('Failed to load products by category: $e');
    }
  }

  Future<List<String>> getAllCategories() async {
    try {
      final response = await _api.get(
        url: '${ApiConstants.baseUrl}${ApiConstants.categories}',
      );

      // Check if response has the new API format
      if (response is Map && response['isSuccess'] == true) {
        List<dynamic> data = response['data'];
        return data.map((item) {
          if (item is Map<String, dynamic>) {
            // If item is an object, extract the name property
            return item['name']?.toString() ??
                item['Name']?.toString() ??
                item.toString();
          }
          return item.toString();
        }).toList();
      }

      // Fallback to old format (direct array)
      List<dynamic> data = response as List<dynamic>;
      return data.map((item) {
        if (item is Map<String, dynamic>) {
          // If item is an object, extract the name property
          return item['name']?.toString() ??
              item['Name']?.toString() ??
              item.toString();
        }
        return item.toString();
      }).toList();
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
      if (response == null || response is! Map<String, dynamic>) {
        throw Exception('Invalid response from server');
      }
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
