import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_app/core/constants/app_colors.dart';
import 'package:store_app/features/orders/data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final Function(int)? onViewDetails;

  const OrderCard({
    super.key,
    required this.order,
    this.onViewDetails,
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
            Text('${order.items.length} item${order.items.length == 1 ? '' : 's'}'),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: onViewDetails != null ? () => onViewDetails!(order.id) : null,
        ),
        onTap: onViewDetails != null ? () => onViewDetails!(order.id) : null,
      ),
    );
  }
}