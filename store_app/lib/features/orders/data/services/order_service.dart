import 'package:store_app/core/constants/api_constants.dart';
import 'package:store_app/core/services/api_service.dart';
import 'package:store_app/features/orders/data/models/order_model.dart';
import 'package:store_app/features/orders/data/models/order_item_model.dart';

class OrderService {
  final ApiService _api = ApiService();
  static const String _ordersEndpoint = '/api/v1/orders';

  Future<List<OrderModel>> getAllOrders() async {
    final response = await _api.get(
      url: '${ApiConstants.baseUrl}$_ordersEndpoint',
    );

    if (response is Map &&
        response['isSuccess'] == true &&
        response['data'] != null) {
      final List<dynamic> data = response['data'];
      return data.map((json) => OrderModel.fromJson(json)).toList();
    }
    // Fallback to direct array
    if (response is List) {
      return response.map((json) => OrderModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load orders');
  }

  Future<OrderModel> getOrderById(int id) async {
    final response = await _api.get(
      url: '${ApiConstants.baseUrl}$_ordersEndpoint/$id',
    );

    if (response is Map &&
        response['isSuccess'] == true &&
        response['data'] != null) {
      return OrderModel.fromJson(response['data']);
    }
    // Fallback to direct object
    if (response is Map) {
      return OrderModel.fromJson(response as Map<String, dynamic>);
    }
    throw Exception('Failed to load order');
  }

  Future<OrderModel> createOrder({
    required int customerId,
    required List<OrderItemModel> items,
  }) async {
    final response = await _api.post(
      url: '${ApiConstants.baseUrl}$_ordersEndpoint',
      body: {
        'customerId': customerId,
        'items': items.map((item) => item.toCreateJson()).toList(),
      },
    );

    if (response is Map &&
        response['isSuccess'] == true &&
        response['data'] != null) {
      return OrderModel.fromJson(response['data']);
    }
    // Fallback to direct object
    if (response is Map) {
      return OrderModel.fromJson(response as Map<String, dynamic>);
    }
    throw Exception('Failed to create order');
  }

  Future<OrderModel> updateOrder({
    required int id,
    required int customerId,
    required List<OrderItemModel> items,
  }) async {
    final response = await _api.put(
      url: '${ApiConstants.baseUrl}$_ordersEndpoint/$id',
      body: {
        'customerId': customerId,
        'items': items.map((item) => item.toCreateJson()).toList(),
      },
    );

    if (response is Map &&
        response['isSuccess'] == true &&
        response['data'] != null) {
      return OrderModel.fromJson(response['data']);
    }
    // Fallback to direct object
    if (response is Map) {
      return OrderModel.fromJson(response as Map<String, dynamic>);
    }
    throw Exception('Failed to update order');
  }

  Future<OrderModel> updateOrderStatus({
    required int id,
    required String status,
  }) async {
    final response = await _api.put(
      url: '${ApiConstants.baseUrl}$_ordersEndpoint/$id/status',
      body: {'status': status},
    );

    if (response is Map &&
        response['isSuccess'] == true &&
        response['data'] != null) {
      return OrderModel.fromJson(response['data']);
    }
    // Fallback to direct object
    if (response is Map) {
      return OrderModel.fromJson(response as Map<String, dynamic>);
    }
    throw Exception('Failed to update order status');
  }

  Future<bool> deleteOrder(int id) async {
    final response = await _api.delete(
      url: '${ApiConstants.baseUrl}$_ordersEndpoint/$id',
    );

    if (response is Map && response['isSuccess'] == true) {
      return response['data'] ?? true;
    }
    // Fallback to true if direct response
    return true;
  }
}
