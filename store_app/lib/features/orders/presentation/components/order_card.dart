import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_app/core/constants/app_colors.dart';
import 'package:store_app/features/orders/data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final Function(int)? onViewDetails;
  final Function(int)? onEdit;
  final Function(int)? onDelete;

  const OrderCard({
    super.key,
    required this.order,
    this.onViewDetails,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            '#${order.id}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          'Order #${order.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${dateFormat.format(order.orderDate)}'),
            Text('Total: ${currencyFormat.format(order.totalAmount)}'),
            Text('Status: ${order.status}'),
            Text(
              '${order.items.length} item${order.items.length == 1 ? '' : 's'}',
            ),
          ],
        ),
        isThreeLine: true,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 20),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
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
            if (value == 'view' && onViewDetails != null) {
              onViewDetails!(order.id);
            } else if (value == 'edit' && onEdit != null) {
              onEdit!(order.id);
            } else if (value == 'delete' && onDelete != null) {
              onDelete!(order.id);
            }
          },
        ),
        onTap: onViewDetails != null ? () => onViewDetails!(order.id) : null,
      ),
    );
  }
}
