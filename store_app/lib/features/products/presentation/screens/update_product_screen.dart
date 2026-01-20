import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/features/products/data/models/product_model.dart';
import 'package:store_app/features/products/presentation/providers/product_provider.dart';
import 'package:store_app/shared/components/custom_button.dart';
import 'package:store_app/shared/components/product_form.dart';
import 'package:store_app/shared/components/screen_layout.dart';

class UpdateProductScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const UpdateProductScreen({super.key, required this.product});

  @override
  ConsumerState<UpdateProductScreen> createState() =>
      _UpdateProductScreenState();
}

class _UpdateProductScreenState extends ConsumerState<UpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  String? _selectedCategory;
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _selectedCategory = widget.product.category;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        final productData = {
          'Name': _titleController.text.trim(),
          'Price': double.parse(_priceController.text),
          'Description': _descriptionController.text.trim(),
          'Category': _selectedCategory ?? widget.product.category,
          'Image': _imageFile?.path ?? widget.product.image,
        };

        final productService = ref.read(productServiceProvider);
        await productService.updateProduct(widget.product.id, productData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update product: $e')),
          );
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
    return ScreenLayout(
      title: 'Update Product',
      icon: Icons.edit,
      body: Form(
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
                  .maybeWhen(data: (data) => data, orElse: () => <String>[]),
              imageFile: _imageFile,
              existingImageUrl: widget.product.image,
              onCategoryChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              onPickImage: _pickImage,
            ),
            const SizedBox(height: 32),
            CustomButton(text: 'Update Product', onPressed: _updateProduct),
          ],
        ),
      ),
    );
  }
}
