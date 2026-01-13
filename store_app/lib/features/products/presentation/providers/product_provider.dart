import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/features/products/data/models/product_model.dart';
import 'package:store_app/features/products/data/services/product_service.dart';

// Product Service Provider
final productServiceProvider = Provider<ProductService>(
  (ref) => ProductService(),
);

// All Products Provider
final allProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final productService = ref.read(productServiceProvider);
  return productService.getAllProducts();
});

// Categories Provider
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final productService = ref.read(productServiceProvider);
  return productService.getAllCategories();
});

// Products by Category Provider
final productsByCategoryProvider =
    FutureProvider.family<List<ProductModel>, String>((ref, category) async {
      final productService = ref.read(productServiceProvider);
      return productService.getProductsByCategory(category);
    });

// Single Product Provider
final productByIdProvider = FutureProvider.family<ProductModel, int>((
  ref,
  id,
) async {
  final productService = ref.read(productServiceProvider);
  return productService.getProductById(id);
});

// Cart State Provider
final cartProvider = NotifierProvider<CartNotifier, List<ProductModel>>(() {
  return CartNotifier();
});

class CartNotifier extends Notifier<List<ProductModel>> {
  @override
  List<ProductModel> build() {
    return [];
  }

  void addToCart(ProductModel product) {
    state = [...state, product];
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < state.length) {
      state = [...state]..removeAt(index);
    }
  }

  void clearCart() {
    state = [];
  }

  double get total {
    return state.fold(0, (sum, item) => sum + item.price);
  }
}

// Favorites State Provider
final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<ProductModel>>(() {
      return FavoritesNotifier();
    });

class FavoritesNotifier extends Notifier<List<ProductModel>> {
  @override
  List<ProductModel> build() {
    return [];
  }

  bool isFavorite(ProductModel product) {
    return state.any((item) => item.id == product.id);
  }

  void toggleFavorite(ProductModel product) {
    final index = state.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      state = [...state]..removeAt(index);
    } else {
      state = [...state, product];
    }
  }
}

// Helper providers for counts
final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).length;
});

final favoritesCountProvider = Provider<int>((ref) {
  return ref.watch(favoritesProvider).length;
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.price);
});
