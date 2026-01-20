import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_app/shared/components/custom_text_field.dart';
import 'package:store_app/shared/components/searchable_dropdown.dart';

class ProductForm extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final String? selectedCategory;
  final List<String> categories;
  final XFile? imageFile;
  final String? existingImageUrl;
  final Function(String?) onCategoryChanged;
  final Function() onPickImage;
  final String? Function(String?)? categoryValidator;

  const ProductForm({
    super.key,
    required this.titleController,
    required this.priceController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.categories,
    required this.imageFile,
    this.existingImageUrl,
    required this.onCategoryChanged,
    required this.onPickImage,
    this.categoryValidator,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image Picker
        GestureDetector(
          onTap: widget.onPickImage,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: widget.imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(widget.imageFile!.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : widget.existingImageUrl != null &&
                      widget.existingImageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.existingImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap to change image',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to add image',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 20),

        // Title Field
        CustomTextField(
          controller: widget.titleController,
          labelText: 'Title',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Price Field
        CustomTextField(
          controller: widget.priceController,
          labelText: 'Price',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a price';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid price';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Description Field
        CustomTextField(
          controller: widget.descriptionController,
          labelText: 'Description',
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Category Dropdown
        SearchableDropdown(
          labelText: 'Category',
          selectedItem: widget.selectedCategory,
          items: widget.categories,
          onChanged: widget.onCategoryChanged,
          prefixIcon: Icons.category,
          searchHintText: 'Search categories...',
          validator:
              widget.categoryValidator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
        ),
      ],
    );
  }
}
