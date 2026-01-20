import 'package:flutter/material.dart';
import 'package:store_app/core/utils/validation.dart';
import 'package:store_app/shared/components/custom_button.dart';
import 'package:store_app/shared/components/custom_text_field.dart';

class CategoryForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController imageUrlController;
  final bool isLoading;
  final String buttonText;
  final Function() onSubmit;

  const CategoryForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.imageUrlController,
    required this.isLoading,
    required this.buttonText,
    required this.onSubmit,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
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
            labelText: 'Category Name',
            prefixIcon: Icons.category,
            validator: (value) =>
                Validation.validateRequired(value, 'category name'),
          ),
          const SizedBox(height: 16),

          // Description Field
          CustomTextField(
            controller: widget.descriptionController,
            labelText: 'Description (Optional)',
            prefixIcon: Icons.description,
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Image URL Field
          CustomTextField(
            controller: widget.imageUrlController,
            labelText: 'Image URL (Optional)',
            prefixIcon: Icons.image,
            keyboardType: TextInputType.url,
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
