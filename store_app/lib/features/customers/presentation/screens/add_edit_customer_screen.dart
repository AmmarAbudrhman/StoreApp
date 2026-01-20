import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/features/customers/data/models/customer_model.dart';
import 'package:store_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:store_app/shared/components/customer_form.dart';
import 'package:store_app/shared/components/screen_layout.dart';

class AddEditCustomerScreen extends ConsumerStatefulWidget {
  final CustomerModel? customer;

  const AddEditCustomerScreen({super.key, this.customer});

  @override
  ConsumerState<AddEditCustomerScreen> createState() =>
      _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends ConsumerState<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _isLoading = false;

  bool get isEdit => widget.customer != null;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.customer?.fullName ?? '',
    );
    _emailController = TextEditingController(
      text: widget.customer?.email ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.customer?.phone ?? '',
    );
    _addressController = TextEditingController(
      text: widget.customer?.address ?? '',
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveCustomer() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        if (isEdit) {
          await ref
              .read(customerNotifierProvider.notifier)
              .updateCustomer(
                id: widget.customer!.id,
                fullName: _fullNameController.text.trim(),
                email: _emailController.text.trim(),
                phone: _phoneController.text.trim(),
                address: _addressController.text.trim(),
              );
        } else {
          await ref
              .read(customerNotifierProvider.notifier)
              .createCustomer(
                fullName: _fullNameController.text.trim(),
                email: _emailController.text.trim(),
                phone: _phoneController.text.trim(),
                address: _addressController.text.trim(),
              );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEdit
                    ? 'Customer updated successfully'
                    : 'Customer created successfully',
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
    return ScreenLayout(
      title: isEdit ? 'Edit Customer' : 'Add Customer',
      icon: isEdit ? Icons.edit : Icons.person_add,
      body: CustomerForm(
        formKey: _formKey,
        fullNameController: _fullNameController,
        emailController: _emailController,
        phoneController: _phoneController,
        addressController: _addressController,
        isLoading: _isLoading,
        buttonText: isEdit ? 'Update Customer' : 'Create Customer',
        onSubmit: _saveCustomer,
      ),
    );
  }
}
