import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/utils/utils.dart';
import 'package:shopping_app/core/widgets/favorite_button.dart';
import 'package:shopping_app/core/widgets/hot_widget.dart';
import 'package:shopping_app/core/widgets/price_widget.dart';
import 'package:shopping_app/core/widgets/sale_widget.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';
import 'package:shopping_app/features/products/presentation/views/product_details.dart';

class VerticalProductCard extends StatefulWidget {
  final ProductEntity product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuyNow;
  final VoidCallback? onTap;

  const VerticalProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
    this.onBuyNow,
    this.onTap,
  });

  @override
  State<VerticalProductCard> createState() => _VerticalProductCardState();
}

class _VerticalProductCardState extends State<VerticalProductCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late final ProductEntity product ;
  

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    product = widget.product;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsView(product: widget.product),
        ),
      );
      }  }  
  @override
  Widget build(BuildContext context) {
    final discountPrice = Utils.getDiscountedPrice(product.price, product.discount);
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        // Go to product details
        _handleTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.98).animate(
          CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha:  0.08),
                spreadRadius: 0,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    //! image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.grey[50]!, Colors.white],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Hero(
                            tag: 'product-image-${widget.product.id}',
                            child: Image.network(
                              product.thumbnail,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 40,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Image not available',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //! fav
                    Positioned(
                      top: 12,
                      right: 12,
                      child:FavoriteButton(product: product)
                    ),

                    //! Hot
                    if (product.rating > 4.5)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: HotWidget(),
                      )
                    //! Sale
                    else if(product.discount >= 18)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: SaleWidget(),
                      )                 
                  ],
                ),
              ),

              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //! name
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 4),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            //! price
                            PriceWidget(price: discountPrice),
                              //! rate
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            
                            ],
                          ),

                          const SizedBox(height: 15),
                          
                          Row(
                            children: [
                              //! buy now
                              Expanded(
                                child: Container(
                                  height: 36,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF5722),
                                        Color(0xFFE64A19),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFF5722).withValues(alpha:  0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: widget.onBuyNow,
                                      borderRadius: BorderRadius.circular(12),
                                      child: const Center(
                                        child: Text(
                                          "Buy Now",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              //! add to cart
                              Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6B7280),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha:  0.08),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: widget.onAddToCart,
                                    borderRadius: BorderRadius.circular(12),
                                    splashColor: Colors.white.withValues(alpha:  0.1),
                                    highlightColor: Colors.white.withValues(alpha:  0.05),
                                    child: const Center(
                                      child: Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}