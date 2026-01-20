import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget header;
  final Widget form;
  final Widget? footer;

  const AuthLayout({
    super.key,
    required this.header,
    required this.form,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(children: [header, form, if (footer != null) footer!]),
        ),
      ),
    );
  }
}
