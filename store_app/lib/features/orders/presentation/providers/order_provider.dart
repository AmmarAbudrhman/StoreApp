import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/features/orders/data/models/order_item_model.dart';
import 'package:store_app/features/orders/data/models/order_model.dart';
import 'package:store_app/features/orders/data/services/order_service.dart';

final orderServiceProvider = Provider((ref) => OrderService());

final ordersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final orderService = ref.read(orderServiceProvider);
  return orderService.getAllOrders();
});

final orderByIdProvider = FutureProvider.family<OrderModel, int>((
  ref,
  id,
) async {
  final orderService = ref.read(orderServiceProvider);
  return orderService.getOrderById(id);
});

class OrderNotifier extends AsyncNotifier<List<OrderModel>> {
  @override
  Future<List<OrderModel>> build() async {
    return loadOrders();
  }

  Future<List<OrderModel>> loadOrders() async {
    state = const AsyncValue.loading();
    try {
      final orderService = ref.read(orderServiceProvider);
      final orders = await orderService.getAllOrders();
      state = AsyncValue.data(orders);
      return orders;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> createOrder({
    required int customerId,
    required List<OrderItemModel> items,
  }) async {
    try {
      final orderService = ref.read(orderServiceProvider);
      await orderService.createOrder(customerId: customerId, items: items);
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
      final orderService = ref.read(orderServiceProvider);
      await orderService.updateOrder(
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
      final orderService = ref.read(orderServiceProvider);
      await orderService.deleteOrder(id);
      await loadOrders();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

final orderNotifierProvider =
    AsyncNotifierProvider<OrderNotifier, List<OrderModel>>(OrderNotifier.new);
