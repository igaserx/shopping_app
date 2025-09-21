import 'package:flutter/material.dart';

class DiscountWidget extends StatelessWidget {
  const DiscountWidget({
    super.key,
    required this.discount,
  });

  final double discount;

  @override
  Widget build(BuildContext context) {
    Color backColor;
Color textColor;
    if (discount >= 50) {
  backColor = Colors.red[100]!;
  textColor = Colors.red[700]!;
} else if (discount >= 20) {
  backColor = Colors.orange[100]!;
  textColor = Colors.orange[700]!;
} else {
  backColor = Colors.green[100]!;
  textColor = Colors.green[700]!;
}
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: textColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${discount.floorToDouble()}% OFF',
        style: TextStyle(
          color: backColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
