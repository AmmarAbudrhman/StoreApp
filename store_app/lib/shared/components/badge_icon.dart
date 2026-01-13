import 'package:flutter/material.dart';
import 'package:store_app/core/constants/app_colors.dart';

class BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onPressed;
  final Color? iconColor;

  const BadgeIcon({
    super.key,
    required this.icon,
    required this.count,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(icon, color: iconColor ?? AppColors.textPrimary),
          onPressed: onPressed,
        ),
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
