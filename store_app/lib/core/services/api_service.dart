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

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection and try again.',
        );
      case DioExceptionType.badResponse:
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          final data = e.response!.data;
          if (data is Map<String, dynamic>) {
            if (data.containsKey('message')) {
              return Exception(data['message']);
            } else if (data.containsKey('error')) {
              return Exception(data['error']);
            } else if (data.containsKey('errors') && data['errors'] is Map) {
              // For validation errors like {"errors": {"email": ["already exists"]}}
              final errors = data['errors'] as Map<String, dynamic>;
              final errorMessages = errors.values
                  .expand((list) => list)
                  .join(', ');
              return Exception(errorMessages);
            }
          }
          return Exception('Request failed with status code: $statusCode');
        } else {
          return Exception('Server error. Please try again later.');
        }
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      case DioExceptionType.connectionError:
        return Exception(
          'Connection error. Please check your internet connection.',
        );
      case DioExceptionType.badCertificate:
        return Exception('Certificate error. Please contact support.');
      case DioExceptionType.unknown:
        return Exception('An unexpected error occurred. Please try again.');
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
      if (e is DioException) {
        throw _handleDioException(e);
      } else {
        throw Exception('An unexpected error occurred: $e');
      }
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
      if (e is DioException) {
        throw _handleDioException(e);
      } else {
        throw Exception('An unexpected error occurred: $e');
      }
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
      if (e is DioException) {
        throw _handleDioException(e);
      } else {
        throw Exception('An unexpected error occurred: $e');
      }
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
      if (e is DioException) {
        throw _handleDioException(e);
      } else {
        throw Exception('An unexpected error occurred: $e');
      }
    }
  }
}
