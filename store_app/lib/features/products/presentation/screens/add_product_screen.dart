import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/features/products/presentation/providers/product_provider.dart';
import 'package:store_app/shared/components/custom_button.dart';
import 'package:store_app/features/products/presentation/components/product_form.dart';
import 'package:store_app/shared/components/app_header.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _addProduct() async {
    if (_formKey.currentState?.validate() == true) {
      try {
        final productData = {
          'Name': _titleController.text.trim(),
          'Price': double.parse(_priceController.text),
          'Description': _descriptionController.text.trim(),
          'Category': _selectedCategory ?? '',
          'Image': _imageFile?.path ?? '', // Or upload and get URL
        };

        final productService = ref.read(productServiceProvider);
        await productService.addProduct(productData);

        // Invalidate the products provider to refresh the list
        ref.invalidate(allProductsProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Failed to add product';
          final errorString = e.toString().toLowerCase();

          if (errorString.contains('category not found')) {
            errorMessage = 'Please select a valid category from the list';
          } else if (errorString.contains('name field is required') ||
              errorString.contains('name')) {
            errorMessage = 'Please enter a product name';
          } else if (errorString.contains('price')) {
            errorMessage = 'Please enter a valid price';
          } else if (errorString.contains('description')) {
            errorMessage = 'Please enter a product description';
          } else if (errorString.contains('network') ||
              errorString.contains('connection')) {
            errorMessage =
                'Network error. Please check your connection and try again';
          } else {
            errorMessage =
                'An error occurred while adding the product. Please try again';
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppHeader(
          title: 'Add Product',
          icon: Icons.add,
          showBackButton: true,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProductForm(
                  titleController: _titleController,
                  priceController: _priceController,
                  descriptionController: _descriptionController,
                  selectedCategory: _selectedCategory,
                  categories: ref
                      .watch(categoriesProvider)
                      .maybeWhen(
                        data: (data) => data,
                        orElse: () => <String>[],
                      ),
                  imageFile: _imageFile,
                  onCategoryChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  onPickImage: _pickImage,
                ),
                const SizedBox(height: 32),
                CustomButton(text: 'Add Product', onPressed: _addProduct),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
