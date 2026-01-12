import 'package:store_app/constant.dart';
import 'package:store_app/helper/api.dart';
import 'package:store_app/models/p/product_model.dart';

class AllProductsService {
  final Api _api = Api();

  Future<List<ProductModel>> getAllProducts() async {
    try {
      List<dynamic> data = await _api.get(url: '$baseUrl/products');
      List<ProductModel> products = [];

      for (var item in data) {
        products.add(ProductModel.fromJson(item));
      }

      return products;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
