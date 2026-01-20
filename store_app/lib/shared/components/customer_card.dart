import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_colors.dart';
import 'package:store_app/features/customers/data/models/customer_model.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  final Function(int)? onEdit;
  final Function(int)? onDelete;

  const CustomerCard({
    super.key,
    required this.customer,
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
            customer.fullName[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          customer.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(customer.email), Text(customer.phone)],
        ),
        isThreeLine: true,
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
              onEdit!(customer.id);
            } else if (value == 'delete' && onDelete != null) {
              onDelete!(customer.id);
            }
          },
        ),
      ),
    );
  }
}
