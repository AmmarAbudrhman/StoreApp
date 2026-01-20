import 'package:flutter/material.dart';

class TestCredentialsInfo extends StatelessWidget {
  final String email;
  final String password;

  const TestCredentialsInfo({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text(
            'Test Credentials:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('Email: $email'),
          Text('Password: $password'),
        ],
      ),
    );
  }
}
