import 'package:store_app/constant.dart';
import 'package:store_app/helper/api.dart';

class DeleteProductService {
  final Api _api = Api();

  Future<Map<String, dynamic>> deleteProduct({required int id}) async {
    try {
      Map<String, dynamic> data = await _api.delete(
        url: '$baseUrl/products/$id',
      );

      return data;
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
