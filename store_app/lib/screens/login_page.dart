import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_routes.dart';
import 'package:store_app/features/auth/presentation/components/auth_layout.dart';
import 'package:store_app/features/auth/presentation/components/login_form.dart';
import 'package:store_app/features/auth/presentation/components/login_header.dart';
import 'package:store_app/features/auth/presentation/components/test_credentials_info.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Fake credentials for testing
  static const String _fakeEmail = 'test@example.com';
  static const String _fakePassword = '123456';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Check credentials
        if (_emailController.text == _fakeEmail &&
            _passwordController.text == _fakePassword) {
          // Login successful
          Navigator.pushReplacementNamed(context, AppRoutes.home);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Login failed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  void _onRegisterTap() {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      header: const LoginHeader(),
      form: LoginForm(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
        isLoading: _isLoading,
        onLogin: _login,
        onRegisterTap: _onRegisterTap,
      ),
      footer: TestCredentialsInfo(email: _fakeEmail, password: _fakePassword),
    );
  }
}
