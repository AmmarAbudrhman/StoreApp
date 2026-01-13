import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/features/orders/data/models/order_item_model.dart';
import 'package:store_app/features/orders/data/models/order_model.dart';
import 'package:store_app/features/orders/data/services/order_service.dart';

final orderServiceProvider = Provider((ref) => OrderService());

final ordersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final orderService = ref.read(orderServiceProvider);
  return orderService.getAllOrders();
});

final orderByIdProvider =
    FutureProvider.family<OrderModel, int>((ref, id) async {
  final orderService = ref.read(orderServiceProvider);
  return orderService.getOrderById(id);
});

class OrderNotifier extends StateNotifier<AsyncValue<List<OrderModel>>> {
  final OrderService _orderService;

  OrderNotifier(this._orderService) : super(const AsyncValue.loading()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    state = const AsyncValue.loading();
    try {
      final orders = await _orderService.getAllOrders();
      state = AsyncValue.data(orders);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createOrder({
    required int customerId,
    required List<OrderItemModel> items,
  }) async {
    try {
      await _orderService.createOrder(
        customerId: customerId,
        items: items,
      );
      await loadOrders();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateOrder({
    required int id,
    required int customerId,
    required List<OrderItemModel> items,
  }) async {
    try {
      await _orderService.updateOrder(
        id: id,
        customerId: customerId,
        items: items,
      );
      await loadOrders();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteOrder(int id) async {
    try {
      await _orderService.deleteOrder(id);
      await loadOrders();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

final orderNotifierProvider =
    StateNotifierProvider<OrderNotifier, AsyncValue<List<OrderModel>>>(
  (ref) {
    final orderService = ref.read(orderServiceProvider);
    return OrderNotifier(orderService);
  },
);
