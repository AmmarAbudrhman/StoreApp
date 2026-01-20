import 'package:flutter/material.dart';
import 'package:store_app/core/utils/validation.dart';
import 'package:store_app/shared/components/custom_button.dart';
import 'package:store_app/shared/components/custom_text_field.dart';

class RegisterForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController addressController;
  final bool isLoading;
  final Function() onRegister;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.addressController,
    required this.isLoading,
    required this.onRegister,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name Field
          CustomTextField(
            controller: widget.nameController,
            labelText: 'Full Name',
            prefixIcon: Icons.person,
            validator: (value) => Validation.validateRequired(value, 'name'),
          ),
          const SizedBox(height: 20),

          // Email Field
          CustomTextField(
            controller: widget.emailController,
            labelText: 'Email',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: Validation.validateEmail,
          ),
          const SizedBox(height: 20),

          // Phone Field
          CustomTextField(
            controller: widget.phoneController,
            labelText: 'Phone',
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: Validation.validatePhone,
          ),
          const SizedBox(height: 20),

          // Address Field
          CustomTextField(
            controller: widget.addressController,
            labelText: 'Address',
            prefixIcon: Icons.location_on,
            validator: (value) => Validation.validateRequired(value, 'address'),
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
          const SizedBox(height: 20),

          // Confirm Password Field
          CustomTextField(
            controller: widget.confirmPasswordController,
            labelText: 'Confirm Password',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            validator: (value) =>
                Validation.validateRequired(value, 'confirm password'),
          ),
          const SizedBox(height: 30),

          // Register Button
          CustomButton(
            text: 'Register',
            onPressed: widget.onRegister,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}
