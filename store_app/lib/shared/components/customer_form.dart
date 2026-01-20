import 'package:flutter/material.dart';
import 'package:store_app/core/utils/validation.dart';
import 'package:store_app/shared/components/custom_button.dart';
import 'package:store_app/shared/components/custom_text_field.dart';

class CustomerForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final bool isLoading;
  final String buttonText;
  final Function() onSubmit;

  const CustomerForm({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.isLoading,
    required this.buttonText,
    required this.onSubmit,
  });

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name Field
          CustomTextField(
            controller: widget.fullNameController,
            labelText: 'Full Name',
            prefixIcon: Icons.person,
            validator: (value) =>
                Validation.validateRequired(value, 'full name'),
          ),
          const SizedBox(height: 16),

          // Email Field
          CustomTextField(
            controller: widget.emailController,
            labelText: 'Email',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: Validation.validateEmail,
          ),
          const SizedBox(height: 16),

          // Phone Field
          CustomTextField(
            controller: widget.phoneController,
            labelText: 'Phone',
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: Validation.validatePhone,
          ),
          const SizedBox(height: 16),

          // Address Field
          CustomTextField(
            controller: widget.addressController,
            labelText: 'Address',
            prefixIcon: Icons.location_on,
            maxLines: 3,
            validator: (value) => Validation.validateRequired(value, 'address'),
          ),
          const SizedBox(height: 24),

          // Submit Button
          CustomButton(
            text: widget.buttonText,
            onPressed: widget.onSubmit,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}
