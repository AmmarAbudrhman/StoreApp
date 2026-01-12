import 'package:dio/dio.dart';
import 'package:store_app/constant.dart';
import 'package:store_app/models/p/product_model.dart';

class AllProductsService {
  final Dio _dio = Dio();

  Future<List<ProductModel>> getAllProducts() async {
    try {
      Response response = await _dio.get('$baseUrl/products');

      List<dynamic> data = response.data;
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
