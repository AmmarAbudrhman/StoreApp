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

class CustomerNotifier extends AsyncNotifier<List<CustomerModel>> {
  @override
  Future<List<CustomerModel>> build() async {
    return loadCustomers();
  }

  Future<List<CustomerModel>> loadCustomers() async {
    state = const AsyncValue.loading();
    try {
      final customerService = ref.read(customerServiceProvider);
      final customers = await customerService.getAllCustomers();
      state = AsyncValue.data(customers);
      return customers;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> createCustomer({
    required String fullName,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      final customerService = ref.read(customerServiceProvider);
      await customerService.createCustomer(
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
      final customerService = ref.read(customerServiceProvider);
      await customerService.updateCustomer(
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
      final customerService = ref.read(customerServiceProvider);
      await customerService.deleteCustomer(id);
      await loadCustomers();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

final customerNotifierProvider =
    AsyncNotifierProvider<CustomerNotifier, List<CustomerModel>>(
      CustomerNotifier.new,
    );
