import 'package:dio/dio.dart';
import 'package:store_app/constant.dart';

class AllCategoriesService {
    final Dio _dio = Dio();


  
  Future<List<String>> getAllCategories() async {
     try {
      final response = await _dio.get(
        '$baseUrl/products/categories',
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<String> categories = [];
        for (var item in data) {
          categories.add(item.toString());
        }
        return categories;
      } else {
        throw Exception(
          'Failed to load categories. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}