import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/features/auth/data/models/user_model.dart';
import 'package:store_app/features/auth/data/services/auth_service.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Auth State Notifier Provider
final authStateProvider =
    NotifierProvider<AuthNotifier, AsyncValue<UserModel?>>(() {
      return AuthNotifier();
    });

class AuthNotifier extends Notifier<AsyncValue<UserModel?>> {
  @override
  AsyncValue<UserModel?> build() {
    loadUser();
    return const AsyncValue.loading();
  }

  AuthService get _authService => ref.read(authServiceProvider);

  Future<void> loadUser() async {
    try {
      state = const AsyncValue.loading();
      final token = await _authService.getToken();
      if (token == null) {
        state = const AsyncValue.data(null);
        return;
      }
      final user = await _authService.getProfile();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authService.login(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authService.register(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        address: address,
      );
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String phone,
    required String address,
    String? imageUrl,
  }) async {
    try {
      final user = await _authService.updateProfile(
        fullName: fullName,
        phone: phone,
        address: address,
        imageUrl: imageUrl,
      );
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AsyncValue.data(null);
  }
}

// Helper provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(data: (user) => user != null, orElse: () => false);
});
