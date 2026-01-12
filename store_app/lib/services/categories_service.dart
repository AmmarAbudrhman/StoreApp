import 'package:store_app/constant.dart';
import 'package:store_app/helper/api.dart';

class CategoriesService {
  final Api _api = Api();

  Future<List<String>> getAllCategories({required String categoryName}) async {
    try {
      List<dynamic> data = await _api.get(
        url: '$baseUrl/products/category/$categoryName',
      );

      List<String> categories = [];
      for (var item in data) {
        categories.add(item.toString());
      }
      return categories;
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
