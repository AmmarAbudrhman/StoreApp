import 'package:store_app/core/constants/api_constants.dart';
import 'package:store_app/core/services/api_service.dart';
import 'package:store_app/features/customers/data/models/customer_model.dart';

class CustomerService {
  final ApiService _api = ApiService();
  static const String _customersEndpoint = '/api/v1/customers';

  Future<List<CustomerModel>> getAllCustomers() async {
    final response = await _api.get(
      url: '${ApiConstants.baseUrl}$_customersEndpoint',
    );

    if (response is Map &&
        response['isSuccess'] == true &&
        response['data'] != null) {
      final List<dynamic> data = response['data'];
      return data.map((json) => CustomerModel.fromJson(json)).toList();
    }
    // Fallback to direct array
    if (response is List) {
      return response.map((json) => CustomerModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load customers');
  }

  Future<CustomerModel> getCustomerById(int id) async {
    final response = await _api.get(
      url: '${ApiConstants.baseUrl}$_customersEndpoint/$id',
    );

    if (response is Map &&
        response['isSuccess'] == true &&
        response['data'] != null) {
      return CustomerModel.fromJson(response['data']);
    }
    // Fallback to direct object
    if (response is Map) {
      return CustomerModel.fromJson(response as Map<String, dynamic>);
    }
    throw Exception('Failed to load customer');
  }

  Future<CustomerModel> createCustomer({
    required String fullName,
    required String email,
    required String phone,
    required String address,
  }) async {
    final response = await _api.post(
      url: '${ApiConstants.baseUrl}$_customersEndpoint',
      body: {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'address': address,
      },
    );

    if (response is Map &&
        response['isSuccess'] == true &&
        response['data'] != null) {
      return CustomerModel.fromJson(response['data']);
    }
    // Fallback to direct object
    if (response is Map) {
      return CustomerModel.fromJson(response as Map<String, dynamic>);
    }
    throw Exception('Failed to create customer');
  }

  Future<CustomerModel> updateCustomer({
    required int id,
    required String fullName,
    required String email,
    required String phone,
    required String address,
  }) async {
    final response = await _api.put(
      url: '${ApiConstants.baseUrl}$_customersEndpoint/$id',
      body: {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'address': address,
      },
    );

    if (response is Map &&
        response['isSuccess'] == true &&
        response['data'] != null) {
      return CustomerModel.fromJson(response['data']);
    }
    // Fallback to direct object
    if (response is Map) {
      return CustomerModel.fromJson(response as Map<String, dynamic>);
    }
    throw Exception('Failed to update customer');
  }

  Future<bool> deleteCustomer(int id) async {
    final response = await _api.delete(
      url: '${ApiConstants.baseUrl}$_customersEndpoint/$id',
    );

    if (response is Map && response['isSuccess'] == true) {
      return response['data'] ?? true;
    }
    // Fallback to true if direct response
    return true;
  }
}
