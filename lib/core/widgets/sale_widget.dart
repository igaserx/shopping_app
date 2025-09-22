import 'package:flutter/material.dart';

class SaleWidget extends StatelessWidget {
  const SaleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'SALE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  }
