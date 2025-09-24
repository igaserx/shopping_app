import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    super.key,
    required this.price,
    this.prColor = const Color(0xFF059669),
    this.size = 22,
  });

  final double price;
  final Color prColor;
  final double size;


  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '\$',
              style: TextStyle(
                fontSize: size * 0.63 ,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            TextSpan(
              text: price.toStringAsFixed(0),
              style:  TextStyle(
                fontSize: size,
                fontWeight: FontWeight.bold,
                color: prColor,
              ),
            ),
            if (price % 1 != 0)
              TextSpan(
                text: '.${((price % 1) * 100).toInt().toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: size - 4,
                  fontWeight: FontWeight.w600,
                  color: prColor,
                ),
              ),
          ],
        ),
      );
  }
}