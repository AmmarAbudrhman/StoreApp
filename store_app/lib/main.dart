import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/screens/add_product_screen.dart';
import 'package:store_app/screens/edit_profile_screen.dart';
import 'package:store_app/screens/home_page.dart';
import 'package:store_app/screens/login_page.dart';
import 'package:store_app/screens/manage_products_screen.dart';
import 'package:store_app/screens/profile_screen.dart';
import 'package:store_app/screens/register_page.dart';
import 'package:store_app/screens/search_screen.dart';
import 'package:store_app/screens/splash_screen.dart';
import 'package:store_app/services/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const StoreApp(),
    ),
  );
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginPage.id: (context) => const LoginPage(),
        RegisterPage.id: (context) => const RegisterPage(),
        HomePage.id: (context) => const HomePage(),
        ProfileScreen.id: (context) => const ProfileScreen(),
        ManageProductsScreen.id: (context) => const ManageProductsScreen(),
        AddProductScreen.id: (context) => const AddProductScreen(),
        SearchScreen.id: (context) => const SearchScreen(),
        EditProfileScreen.id: (context) => const EditProfileScreen(),
      },
      initialRoute: SplashScreen.id,
      title: 'Store App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
    );
  }
}
