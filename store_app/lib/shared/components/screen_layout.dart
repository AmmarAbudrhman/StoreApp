import 'package:flutter/material.dart';
import 'package:store_app/shared/components/app_header.dart';

class ScreenLayout extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<Widget>? actions;
  final Widget body;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final EdgeInsetsGeometry? padding;
  final Widget? floatingActionButton;

  const ScreenLayout({
    super.key,
    required this.title,
    this.icon,
    this.actions,
    required this.body,
    this.showBackButton = true,
    this.onBackPressed,
    this.padding = const EdgeInsets.all(24.0),
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppHeader(
          title: title,
          icon: icon,
          actions: actions,
          showBackButton: showBackButton,
          onBackPressed: onBackPressed,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(padding: padding, child: body),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
