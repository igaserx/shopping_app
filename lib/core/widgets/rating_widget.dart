import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rate;
  const RatingWidget({
    super.key, required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  rate.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
  }
}