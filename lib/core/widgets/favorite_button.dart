import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/favorite/cubits/favorite_cubit.dart';
import 'package:shopping_app/features/favorite/cubits/favorite_state.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';

class FavoriteButton extends StatelessWidget {
  final ProductEntity product;
  final double size;
  final bool background;
  final num padding;

  const FavoriteButton({super.key, required this.product, this.size = 20, this.background = true,  this.padding = 0.0});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final isFavorite = context.read<FavoritesCubit>().isFavorite(product);

        return Padding(
          padding: EdgeInsets.all(padding.toDouble()),
          child: GestureDetector(
            onTap: () {
              context.read<FavoritesCubit>().toggleFavorite(product);
            },
            child: background ? AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isFavorite ? Colors.red[50] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: size,
              ),
            ) : Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: size,
              ),
          ),
        );
      },
    );
  }
}
