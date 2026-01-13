import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('isSuccess')) {
        if (data['isSuccess'] == true) {
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'Request failed');
        }
      }
      return data;
    } else {
      throw Exception(
        'Request failed with status code: ${response.statusCode}',
      );
    }
  }

  Future<dynamic> get({required String url, String? token}) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      Response response = await _dio.get(
        url,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error in GET request: $e');
    }
  }

  Future<dynamic> post({
    required String url,
    dynamic body,
    String? token,
  }) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      Response response = await _dio.post(
        url,
        data: body,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error in POST request: $e');
    }
  }

  Future<dynamic> put({
    required String url,
    dynamic body,
    String? token,
  }) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      Response response = await _dio.put(
        url,
        data: body,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error in PUT request: $e');
    }
  }

  Future<dynamic> delete({
    required String url,
    dynamic body,
    String? token,
  }) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      Response response = await _dio.delete(
        url,
        data: body,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error in DELETE request: $e');
    }
  }
}
