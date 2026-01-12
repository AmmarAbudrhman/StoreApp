import 'package:flutter/material.dart';
import 'package:store_app/models/products/product_model.dart';

class AppState extends ChangeNotifier {
  final List<ProductModel> _cartItems = [];
  final List<ProductModel> _favoriteItems = [];

  List<ProductModel> get cartItems => List.unmodifiable(_cartItems);
  List<ProductModel> get favoriteItems => List.unmodifiable(_favoriteItems);

  int get cartCount => _cartItems.length;
  int get favoritesCount => _favoriteItems.length;

  bool isFavorite(ProductModel product) {
    return _favoriteItems.any((item) => item.id == product.id);
  }

  void addToCart(ProductModel product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void toggleFavorite(ProductModel product) {
    final index = _favoriteItems.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _favoriteItems.removeAt(index);
    } else {
      _favoriteItems.add(product);
    }
    notifyListeners();
  }

  double get cartTotal {
    return _cartItems.fold(0, (sum, item) => sum + item.price);
  }
}
