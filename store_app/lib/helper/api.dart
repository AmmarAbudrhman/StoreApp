import 'package:dio/dio.dart';

class Api {
  final Dio _dio = Dio();

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

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'GET request failed with status code: ${response.statusCode}',
        );
      }
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(
          'POST request failed with status code: ${response.statusCode}',
        );
      }
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

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'PUT request failed with status code: ${response.statusCode}',
        );
      }
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

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'DELETE request failed with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error in DELETE request: $e');
    }
  }
}
