import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning, custom }

class CustomSnackBar {
  static void show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.success,
    Duration duration = const Duration(seconds: 3),
    Color? customColor,
  }) {
    final color = _getBackgroundColor(type, customColor);
    final icon = _getIcon(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        duration: duration,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _getBackgroundColor(SnackBarType type, Color? customColor) {
    switch (type) {
      case SnackBarType.success:
        return Colors.green;
      case SnackBarType.error:
        return Colors.red;
      case SnackBarType.warning:
        return Colors.orange;
      case SnackBarType.custom:
        return customColor ?? Colors.blueGrey;
    }
  }

  static IconData _getIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
      case SnackBarType.custom:
        return Icons.info_outline;
    }
  }
}