import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductsLoading extends StatelessWidget {
  const ProductsLoading({super.key});

  Widget _shimmerBox({
    double height = 16,
    double width = double.infinity,
    BorderRadius? radius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300]!,
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left texts
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(height: 20, width: 140),
                  const SizedBox(height: 6),
                  _shimmerBox(height: 14, width: 100),
                ],
              ),
              // Right chip
              _shimmerBox(
                height: 28,
                width: 60,
                radius: BorderRadius.circular(20),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}