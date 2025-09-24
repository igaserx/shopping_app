import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/DI/di.dart';
import 'package:shopping_app/features/products/data/models/banner_item.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';
import 'package:shopping_app/features/products/presentation/cubits/prduct_cubit.dart';
import 'package:shopping_app/features/products/presentation/cubits/prduct_state.dart';
import 'package:shopping_app/features/products/presentation/views/product_details.dart';
import 'package:shopping_app/features/products/presentation/views/products_view.dart';
import 'package:shopping_app/features/products/presentation/widgets/category.dart';
import 'package:shopping_app/core/widgets/v_product_card.dart';
import 'package:shopping_app/features/products/presentation/widgets/sales_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/utils.dart';
import 'package:shopping_app/features/cart/presentation/views/cart_view.dart';

const Map<String, List<String>> mainCategories = {
  "Electronics": ["smartphones", "laptops"],
  "Fashion": [
    "tops",
    "womens-dresses",
    "womens-shoes",
    "mens-shirts",
    "mens-shoes",
    "mens-watches",
    "womens-watches",
    "womens-bags",
    "womens-jewellery",
    "sunglasses",
  ],
  "Home & Living": ["groceries", "home-decoration", "furniture", "lighting"],
  "Beauty & Health": ["fragrances", "skincare"],
  "Automotive": ["automotive", "motorcycle"],
};

final List<Map<String, String>> categoriesData = [
  {
    "name": "Electronics",
    "imageUrl": "https://cdn-icons-png.flaticon.com/512/1055/1055687.png",
  },
  {
    "name": "Fashion",
    "imageUrl": "https://cdn-icons-png.flaticon.com/512/892/892458.png",
  },
  {
    "name": "Home & Living",
    "imageUrl": "https://cdn-icons-png.flaticon.com/512/2909/2909763.png",
  },
  {
    "name": "Beauty & Health",
    "imageUrl": "https://cdn-icons-png.flaticon.com/512/869/869869.png",
  },
  {
    "name": "Automotive",
    "imageUrl": "https://cdn-icons-png.flaticon.com/512/743/743131.png",
  },
];

final List<BannerItem> bannersData = [
  const BannerItem(
    title: "Welcome to our Shopping app!",
    subtitle: "Find everything you need in one place.",
    imageUrl: "https://cdn-icons-png.flaticon.com/512/3081/3081559.png",
  ),
  const BannerItem(
    title: "Discover New Products",
    subtitle: "Browse our latest and greatest items.",
    imageUrl: "https://cdn-icons-png.flaticon.com/512/1170/1170576.png",
  ),
  const BannerItem(
    title: "Enjoy Fast Delivery",
    subtitle: "Get your orders delivered quickly and safely.",
    imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046857.png",
  ),
];

class HomeView extends StatelessWidget {
  static const String routeName = "HomeView";
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'User';
    final String userName = userEmail.split('@')[0];
    
    

    return BlocProvider(
      create: (context) => di<ProductCubit>()..getAllProducts(),
      child: HomeViewBody(userName: userName),
    );
  }
}

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key, required this.userName});

  final String userName;

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await context.read<ProductCubit>().getAllProducts();
          },
          color: const Color(0xFFFF5722),
          child: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductInitial) {
                return _buildInitialState();
              } else if (state is ProductLoading) {
                return _buildLoadingState();
              } else if (state is ProductLoaded) {
                return _buildLoadedState(state.products);
              } else if (state is ProductError) {
                return _buildErrorState(state.message);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Ready to browse products!',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 8,
      itemBuilder: (context, index) => LoadingWidget(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Products Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We couldn\'t find any products at the moment.',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.read<ProductCubit>().getAllProducts(),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5722),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                Icons.error_outline,
                size: 60,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed:
                      () => context.read<ProductCubit>().getAllProducts(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _onBuyNow(ProductEntity product) {
    // TODO: go buy
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proceeding to buy ${product.title}'),
        backgroundColor: const Color(0xFFFF5722),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildLoadedState(List<ProductEntity> products) {
    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return CustomScrollView(
      slivers: [
        //! Orange Background
        SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.39,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFBF360C),
                  const Color(0xFFE64A19),
                  const Color(0xFFFF5722),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //! Welcome
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, ${widget.userName}!",
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            "Let's find your favorite items",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //! Cart
                    IconButton(
                      icon: const Icon(
                        Icons.production_quantity_limits,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartPage()),
);
                      },
                    ),
                  
                  ],
                ),
                const SizedBox(height: 16),
                //! Search
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                //! Categories
                Text(
                  "Shop by Category",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoriesData.length,
                    itemBuilder: (context, index) {
                      final category = categoriesData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Category(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ProductView.routeName,
                              arguments: {
                                "name": category["name"],
                                "category":
                                    mainCategories["${category["name"]}"],
                              },
                            );
                          },
                          imageUrl: category['imageUrl']!,
                          categoryName: category['name']!,
                        ),
                      );
                    },
                  ),
                ),
              
              ],
            ),
          ),
        ),

        // ! Sales Banner
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: SalesBanner(banners: bannersData),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // ! Popular Products
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                // Todo : see all products
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular Products",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "See All",
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ),

        //! Grid of Products
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return VerticalProductCard(
                product: product,
                onAddToCart: () => Utils.onAddToCart(context, product: product),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProductDetailsView(product: product),
                    ),
                  );
                },
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
          ),
        ),

      ],
    );
  }
}

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(6, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey[300]!,
                        Colors.grey[100]!,
                        Colors.grey[300]!,
                      ],
                      stops: [
                        (_controller.value - 0.3).clamp(0.0, 1.0),
                        _controller.value,
                        (_controller.value + 0.3).clamp(0.0, 1.0),
                      ],
                      begin: const Alignment(-1, -0.3),
                      end: const Alignment(2, 0.3),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
