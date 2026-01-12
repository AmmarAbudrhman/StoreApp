import 'package:store_app/constant.dart';
import 'package:store_app/helper/api.dart';

class AllCategoriesService {
  final Api _api = Api();

  Future<List<String>> getAllCategories() async {
    try {
      List<dynamic> data = await _api.get(url: '$baseUrl/products/categories');

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
