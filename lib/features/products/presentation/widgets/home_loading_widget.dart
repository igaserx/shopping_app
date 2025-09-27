import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({super.key});

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
    final screenHeight = MediaQuery.sizeOf(context).height;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: screenHeight * 0.39,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(height: 20, width: 120),
                          const SizedBox(height: 8),
                          _shimmerBox(height: 16, width: 200),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _shimmerBox(height: 48, radius: BorderRadius.circular(12)),
                const SizedBox(height: 16),

                _shimmerBox(height: 20, width: 160),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder:
                        (context, index) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 12,
                                width: 40,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _shimmerBox(height: 150, radius: BorderRadius.circular(16)),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(height: 140, radius: BorderRadius.circular(16)),
                  const SizedBox(height: 8),
                  _shimmerBox(height: 16, width: 100),
                  const SizedBox(height: 6),
                  _shimmerBox(height: 16, width: 60),
                ],
              );
            }, childCount: 6),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
          ),
        ),
      ],
    );
  }
}
