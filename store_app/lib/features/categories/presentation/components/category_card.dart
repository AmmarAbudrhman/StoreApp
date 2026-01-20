import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_colors.dart';
import 'package:store_app/features/categories/data/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final Function(int)? onEdit;
  final Function(int)? onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            category.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: category.description.isNotEmpty
            ? Text(category.description)
            : null,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit' && onEdit != null) {
              onEdit!(category.id);
            } else if (value == 'delete' && onDelete != null) {
              onDelete!(category.id);
            }
          },
        ),
      ),
    );
  }
}
