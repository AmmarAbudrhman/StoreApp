import 'package:store_app/constant.dart';
import 'package:store_app/helper/api.dart';
import 'package:store_app/models/products/product_model.dart';

class UpdateProductService {
  final Api _api = Api();

  Future<ProductModel> updateProduct({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
  }) async {
    try {
      Map<String, dynamic> data = await _api.put(
        url: '$baseUrl/products/$id',
        body: {
          'title': title,
          'price': price,
          'description': description,
          'category': category,
          'image': image,
        },
      );

      return ProductModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
}
