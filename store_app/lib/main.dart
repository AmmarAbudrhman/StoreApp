import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/core/constants/app_routes.dart';
import 'package:store_app/core/constants/app_theme.dart';
import 'package:store_app/features/auth/presentation/screens/edit_profile_screen.dart';
import 'package:store_app/features/auth/presentation/screens/login_screen.dart';
import 'package:store_app/features/auth/presentation/screens/profile_screen.dart';
import 'package:store_app/features/auth/presentation/screens/register_screen.dart';
import 'package:store_app/features/categories/data/models/category_model.dart';
import 'package:store_app/features/categories/presentation/screens/add_edit_category_screen.dart';
import 'package:store_app/features/categories/presentation/screens/categories_screen.dart';
import 'package:store_app/features/customers/data/models/customer_model.dart';
import 'package:store_app/features/customers/presentation/screens/add_edit_customer_screen.dart';
import 'package:store_app/features/customers/presentation/screens/customers_screen.dart';
import 'package:store_app/features/products/data/models/product_model.dart';
import 'package:store_app/features/products/presentation/screens/cart_screen.dart';
import 'package:store_app/features/products/presentation/screens/favorites_screen.dart';
import 'package:store_app/features/products/presentation/screens/home_screen.dart';
import 'package:store_app/features/products/presentation/screens/product_details_screen.dart';
import 'package:store_app/features/products/presentation/screens/search_screen.dart';
import 'package:store_app/shared/screens/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: StoreApp()));
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case AppRoutes.login:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case AppRoutes.register:
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case AppRoutes.home:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case AppRoutes.profile:
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case AppRoutes.editProfile:
            return MaterialPageRoute(builder: (_) => const EditProfileScreen());
          case AppRoutes.cart:
            return MaterialPageRoute(builder: (_) => const CartScreen());
          case AppRoutes.favorites:
            return MaterialPageRoute(builder: (_) => const FavoritesScreen());
          case AppRoutes.search:
            return MaterialPageRoute(builder: (_) => const SearchScreen());
          case AppRoutes.productDetails:
            final product = settings.arguments as ProductModel;
            return MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(product: product),
            );

          // Categories routes
          case AppRoutes.categories:
            return MaterialPageRoute(builder: (_) => const CategoriesScreen());
          case AppRoutes.addCategory:
            return MaterialPageRoute(
              builder: (_) => const AddEditCategoryScreen(),
            );
          case AppRoutes.editCategory:
            final category = settings.arguments as CategoryModel;
            return MaterialPageRoute(
              builder: (_) => AddEditCategoryScreen(category: category),
            );

          // Customers routes
          case AppRoutes.customers:
            return MaterialPageRoute(builder: (_) => const CustomersScreen());
          case AppRoutes.addCustomer:
            return MaterialPageRoute(
              builder: (_) => const AddEditCustomerScreen(),
            );
          case AppRoutes.editCustomer:
            final customer = settings.arguments as CustomerModel;
            return MaterialPageRoute(
              builder: (_) => AddEditCustomerScreen(customer: customer),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
            );
        }
      },
    );
  }
}
