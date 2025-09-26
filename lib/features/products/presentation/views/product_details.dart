import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/utils/utils.dart';
import 'package:shopping_app/core/widgets/discount_widget.dart';
import 'package:shopping_app/core/widgets/favorite_button.dart';
import 'package:shopping_app/core/widgets/price_widget.dart';
import 'package:shopping_app/features/favorite/cubits/favorite_cubit.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';
import 'package:shopping_app/features/products/domain/entities/subEntities/review_entity.dart';
class ProductDetailsView extends StatefulWidget {
  static const String routeName = "ProductDetailsView";
  final ProductEntity product;

  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _imagePageController;

  bool isFavorite = false;
  int selectedImageIndex = 0;
  int quantity = 1;
  late final ProductEntity product;
  late final List<dynamic> productImages = product.images;
  late final List<ReviewEntity> reviews = product.reviews;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _imagePageController = PageController();
    product = widget.product;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _info(),
                _options(),
                _tabSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      actions: [
        //! Fav
        FavoriteButton(product: product, background: false, size: 24, padding: 8.0,),

        const SizedBox(width: 8),

      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.grey[50],
          child: Stack(
            children: [
              PageView.builder(
                controller: _imagePageController,
                onPageChanged: (index) {
                  setState(() {
                    selectedImageIndex = index;
                  });
                },
                itemCount: productImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:  0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    //! image
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        productImages[index],
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    productImages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: selectedImageIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            selectedImageIndex == index
                                ? const Color(0xFFFF5722)
                                : Colors.white.withValues(alpha:  0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _info() {
    final discountedPrice = Utils.getDiscountedPrice(product.price, product.discount);
    final bool isDiscount = product.discount >= 10.0 ; 

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              //! Status
              _stockmethod(product.status),

              const Spacer(),

              //! Stars
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ' (${reviews.length} reviews)',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            
            ],
          ),

          const SizedBox(height: 16),
          //! Title
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              //! Price
            PriceWidget(price: discountedPrice, size: 28,),

              const SizedBox(width: 12),

              //! Discount
              if (isDiscount) 
                //! Old Price
                Text(
                  '\$${(product.price).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[500],
                  ),
                ),
            ],
          ),

          //! Discount badge
          if (isDiscount)
            DiscountWidget(discount: product.discount,),

        ],
      ),
    );
  }

  Container _stockmethod(String status) {
     Color backColor;
    Color textColor;
    String displayText;
     switch (status.toLowerCase()) {
      case "low stock":
        backColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        displayText = "Low Stock";
        break;
      case "in stock":
      default:
        backColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        displayText = "In Stock";
        break;
    }
     return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _options() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [        

          //! Quantity 
          Row(
            children: [
              const Text(
                'Quantity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    //! -
                    IconButton(
                      onPressed:
                          quantity > 1
                              ? () {
                                setState(() {
                                  quantity--;
                                });
                              }
                              : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //! +
                    IconButton(
                      onPressed: 
                      quantity != product.stock ?
                       () {
                          setState(() {
                            quantity++;
                          });
                        } : null
                        ,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),
        
        ],
      ),
    );
  }

  Widget _tabSection() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
            indicator: BoxDecoration(
              color: const Color(0xFFFF5722),
              borderRadius: BorderRadius.circular(12),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Description'),
              Tab(text: 'Reviews'),
              Tab(text: 'Shipping'),
            ],
          ),
        ),
        Container(
          height:  MediaQuery.of(context).size.height * 0.5,
          margin: const EdgeInsets.all(20),
          child: TabBarView(
            controller: _tabController,
            children: [
              _descriptionTab(),
              _reviewsTab(),
              _shippingTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _descriptionTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              product.description,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Specifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _keyAndValue('Brand', product.brand ?? "No brand available"),
            _keyAndValue('SKU', product.sku),
            _keyAndValue('Weight', '${product.weight} g'),
            _keyAndValue('Dimensions', '${product.dimensions.height} x ${product.dimensions.width} x ${product.dimensions.depth} cm'),
            _keyAndValue('Warranty', product.warranty),
          ],
        ),
      ),
    );
  }

  Widget _keyAndValue(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              key,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _reviewsTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Customer Reviews',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return _reviewItem(review);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewItem(ReviewEntity review) {
    int daysAgo = Utils.daysAgo(review.date.toString()) ;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFFF5722),
          child: Text(
            review.reviewerName.characters.first,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    review.reviewerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    daysAgo == 1 ?
                    "$daysAgo Day ago" 
                    : "$daysAgo Days ago",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating.floor()
                        ? Icons.star
                        : Icons.star_outline,
                    size: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                review.comment,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shippingTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipping Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          _buildShippingOption(
            'Standard Delivery',
            product.shipping,
            'Free',
            Icons.local_shipping,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Return Policy',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                product.returnPolicy,
                  style: TextStyle(color: Colors.blue[700], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingOption(
    String title,
    String time,
    String price,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFFF5722)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFFFF5722),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            //! Add to Cart
            Expanded(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(right: 12),
                child: ElevatedButton.icon(
                  onPressed: () => Utils.onAddToCart(context, product: product),
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            //! buy now
            Expanded(
              child: Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Utils.onBuyNow(context, product: product);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Buy Now'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
