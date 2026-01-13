import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/features/customers/data/models/customer_model.dart';
import 'package:store_app/features/customers/data/services/customer_service.dart';

final customerServiceProvider = Provider((ref) => CustomerService());

final customersProvider = FutureProvider<List<CustomerModel>>((ref) async {
  final customerService = ref.read(customerServiceProvider);
  return customerService.getAllCustomers();
});

final customerByIdProvider = FutureProvider.family<CustomerModel, int>((
  ref,
  id,
) async {
  final customerService = ref.read(customerServiceProvider);
  return customerService.getCustomerById(id);
});

class CustomerNotifier extends StateNotifier<AsyncValue<List<CustomerModel>>> {
  final CustomerService _customerService;

  CustomerNotifier(this._customerService) : super(const AsyncValue.loading()) {
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    state = const AsyncValue.loading();
    try {
      final customers = await _customerService.getAllCustomers();
      state = AsyncValue.data(customers);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createCustomer({
    required String fullName,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      await _customerService.createCustomer(
        fullName: fullName,
        email: email,
        phone: phone,
        address: address,
      );
      await loadCustomers();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateCustomer({
    required int id,
    required String fullName,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      await _customerService.updateCustomer(
        id: id,
        fullName: fullName,
        email: email,
        phone: phone,
        address: address,
      );
      await loadCustomers();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      await _customerService.deleteCustomer(id);
      await loadCustomers();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

final customerNotifierProvider =
    StateNotifierProvider<CustomerNotifier, AsyncValue<List<CustomerModel>>>((
      ref,
    ) {
      final customerService = ref.read(customerServiceProvider);
      return CustomerNotifier(customerService);
    });
