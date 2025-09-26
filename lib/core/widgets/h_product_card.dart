import 'package:flutter/material.dart';
import 'package:shopping_app/core/utils/utils.dart';
import 'package:shopping_app/core/widgets/favorite_button.dart';
import 'package:shopping_app/core/widgets/hot_widget.dart';
import 'package:shopping_app/core/widgets/price_widget.dart';
import 'package:shopping_app/core/widgets/rating_widget.dart';
import 'package:shopping_app/core/widgets/sale_widget.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';
import 'package:shopping_app/features/products/presentation/views/product_details.dart';

class HorizontalProductCard extends StatefulWidget {
  final ProductEntity product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuyNow;
  final VoidCallback? onTap;

  const HorizontalProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
    this.onBuyNow,
    this.onTap,
  });

  @override
  State<HorizontalProductCard> createState() => _HorizontalProductCardState();
}

class _HorizontalProductCardState extends State<HorizontalProductCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late final ProductEntity product;
  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    //! Product entity
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
          builder: (context) => ProductDetailsView(product: product),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final discountPrice = Utils.getDiscountedPrice(product.price, product.discount);
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) 
      {
        _scaleController.reverse();
        _handleTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.98).animate(
          CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
        ),
        child: Container(
          height: 140,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha:  0.08),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [

              
              Container(
                width: 120,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    //! image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.grey[50]!, Colors.white],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            product.thumbnail,
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
                                    size: 30,
                                    color: Colors.grey[400],
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

                    //! fav
                    Positioned(
                      top: 8,
                      right: 8,
                      child: FavoriteButton(product: product)
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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //! Title
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 8),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //! Price
                              PriceWidget(price: discountPrice),
                              
                              //! rate
                              RatingWidget(rate: product.rating),

                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                            
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
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF5722).withValues(alpha:  0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: widget.onBuyNow,
                                  borderRadius: BorderRadius.circular(10),
                                  child: const Center(
                                    child: Text(
                                      "Buy Now",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          //! Add to Cart Button
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6B7280),
                              borderRadius: BorderRadius.circular(10),
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
                                borderRadius: BorderRadius.circular(10),
                                splashColor: Colors.white.withValues(alpha:  0.1),
                                highlightColor: Colors.white.withValues(alpha:  0.05),
                                child: const Center(
                                  child: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
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
