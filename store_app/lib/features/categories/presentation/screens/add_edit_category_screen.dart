import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/core/utils/validation.dart';
import 'package:store_app/features/categories/data/models/category_model.dart';
import 'package:store_app/features/categories/presentation/providers/category_provider.dart';
import 'package:store_app/shared/components/custom_button.dart';
import 'package:store_app/shared/components/custom_text_field.dart';

class AddEditCategoryScreen extends ConsumerStatefulWidget {
  final CategoryModel? category;

  const AddEditCategoryScreen({super.key, this.category});

  @override
  ConsumerState<AddEditCategoryScreen> createState() =>
      _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends ConsumerState<AddEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  bool _isLoading = false;

  bool get isEdit => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.category?.description ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.category?.imageUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        if (isEdit) {
          await ref
              .read(categoryNotifierProvider.notifier)
              .updateCategory(
                id: widget.category!.id,
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim(),
                imageUrl: _imageUrlController.text.trim(),
              );
        } else {
          await ref
              .read(categoryNotifierProvider.notifier)
              .createCategory(
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim(),
                imageUrl: _imageUrlController.text.trim(),
              );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEdit
                    ? 'Category updated successfully'
                    : 'Category created successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Category' : 'Add Category')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'Category Name',
                prefixIcon: Icons.category,
                validator: (value) =>
                    Validation.validateRequired(value, 'category name'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                labelText: 'Description',
                prefixIcon: Icons.description,
                maxLines: 3,
                validator: (value) =>
                    Validation.validateRequired(value, 'description'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _imageUrlController,
                labelText: 'Image URL',
                prefixIcon: Icons.image,
                validator: (value) =>
                    Validation.validateRequired(value, 'image URL'),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: isEdit ? 'Update Category' : 'Create Category',
                onPressed: _saveCategory,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
