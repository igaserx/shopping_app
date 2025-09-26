import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/utils/utils.dart';
import 'package:shopping_app/core/widgets/custom_snack_bar.dart';
import 'package:shopping_app/core/widgets/price_widget.dart';
import 'package:shopping_app/core/widgets/rating_widget.dart';
import 'package:shopping_app/features/favorite/cubits/favorite_cubit.dart';
import 'package:shopping_app/features/favorite/cubits/favorite_state.dart';
import 'package:shopping_app/features/favorite/models/favorite_model.dart';


class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(context),
      body: BlocConsumer<FavoritesCubit, FavoritesState>(
        listener: (context, state) {
          if (state is FavoriteAdded || state is FavoriteRemoved) {
            final message = state is FavoriteAdded 
                ? (state).message
                : (state as FavoriteRemoved).message;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: state is FavoriteAdded 
                    ? Colors.green 
                    : Colors.orange,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.favorites.isEmpty) {
            return _buildEmptyFavorites(context);
          }
          
          return _buildFavoritesList(context, state.favorites);
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          return Text(
            "Favorites",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: const Color(0xFF2D3748),
      actions: [
        BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state.favorites.isNotEmpty) {
              return IconButton(
                onPressed: () => _showClearFavoritesDialog(context),
                icon: const Icon(Icons.clear_all),
                tooltip: 'Clear all favorites',
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.grey.withValues(alpha:  0.2),
        ),
      ),
    );
  }

  Widget _buildEmptyFavorites(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_outline,
              size: 60,
              color: Colors.red[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding products you love',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context, List<FavoriteModel> favorites) {
    return RefreshIndicator(
      onRefresh: () => context.read<FavoritesCubit>().loadFavorites(),
      color: const Color(0xFFFF5722),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          return _buildFavoriteItem(context, favorite);
        },
      ),
    );
  }

  Widget _buildFavoriteItem(BuildContext context, FavoriteModel favorite) {
    final price =  Utils.getDiscountedPrice(favorite.product.price, favorite.product.discount);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:  0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey[50]!, Colors.white],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    favorite.product.thumbnail,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey[400],
                            size: 30,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No image',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            //! Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favorite.product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  //! Price and Rating
                  Row(
                    children: [
                      //! Price
                      PriceWidget(price: price),

                      const Spacer(),
                      
                      //! Rating
                      RatingWidget(rate: favorite.product.rating),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  //! date
                  Text(
                    'Added ${_formatDate(favorite.addedAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),

                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      //! Add to cart 
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Utils.onAddToCart(context, product: favorite.product);
                           CustomSnackBar.show(context, "${favorite.product.title} added to cart!", type: SnackBarType.success);
                          },
                          icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                          label: const Text(
                           "Add to Cart",
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(0, 32),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      //! Heart Icon to remove from favorites
                      IconButton(
                        onPressed: () {
                          context.read<FavoritesCubit>().removeFromFavorites(favorite.product);
                        },
                        icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          minimumSize: const Size(32, 32),
                        ),
                        tooltip: 'Remove from favorites',
                      ),
                    
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  void _showClearFavoritesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FavoritesCubit>().clearFavorites();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
