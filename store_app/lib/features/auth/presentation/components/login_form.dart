import 'package:flutter/material.dart';
import 'package:store_app/core/utils/validation.dart';
import 'package:store_app/shared/components/custom_button.dart';
import 'package:store_app/shared/components/custom_text_field.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final Function() onLogin;
  final Function() onRegisterTap;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    required this.onRegisterTap,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          CustomTextField(
            controller: widget.emailController,
            labelText: 'Email',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: Validation.validateEmail,
          ),
          const SizedBox(height: 20),

          // Password Field
          CustomTextField(
            controller: widget.passwordController,
            labelText: 'Password',
            prefixIcon: Icons.lock,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: Validation.validatePassword,
          ),
          const SizedBox(height: 12),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Forgot password feature coming soon'),
                  ),
                );
              },
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 20),

          // Login Button
          CustomButton(
            text: 'Login',
            onPressed: widget.onLogin,
            isLoading: widget.isLoading,
          ),
          const SizedBox(height: 20),

          // Register Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              TextButton(
                onPressed: widget.onRegisterTap,
                child: const Text('Register'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
