import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_colors.dart';
import 'package:store_app/features/customers/data/models/customer_model.dart';
import 'package:store_app/shared/components/screen_layout.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final CustomerModel customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Customer Details',
      icon: Icons.person,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                child: Text(
                  customer.fullName[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Full Name', customer.fullName),
            const SizedBox(height: 16),
            _buildDetailRow('Email', customer.email),
            const SizedBox(height: 16),
            _buildDetailRow('Phone', customer.phone),
            const SizedBox(height: 16),
            _buildDetailRow('Address', customer.address),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Divider(),
      ],
    );
  }
}
