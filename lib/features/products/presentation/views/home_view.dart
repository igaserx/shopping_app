import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/DI/di.dart';
import 'package:shopping_app/features/cart/views/cart_view.dart';
import 'package:shopping_app/features/favorite/views/favorite_view.dart';
import 'package:shopping_app/features/products/data/models/banner_item.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';
import 'package:shopping_app/features/products/presentation/cubits/prduct_cubit.dart';
import 'package:shopping_app/features/products/presentation/cubits/prduct_state.dart';
import 'package:shopping_app/features/products/presentation/views/product_details.dart';
import 'package:shopping_app/features/products/presentation/views/products_view.dart';
import 'package:shopping_app/features/products/presentation/widgets/category.dart';
import 'package:shopping_app/core/widgets/v_product_card.dart';
import 'package:shopping_app/features/products/presentation/widgets/home_loading_widget.dart';
import 'package:shopping_app/features/products/presentation/widgets/sales_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/features/products/presentation/views/search_view.dart';
import 'package:shopping_app/features/profile/views/profile_view.dart';
import '../../../../core/utils/utils.dart';

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
  "Home": ["home-decoration", "furniture", "lighting"],
  "Food": ["groceries"],
  "Beauty & Health": ["fragrances", "skincare"],
  "Automotive": ["automotive", "motorcycle"],
};

final List<Map<String, String>> categoriesData = [
  {"name": "Electronics", "imageUrl": "assets/electroinc.png"},
  {"name": "Fashion", "imageUrl": "assets/fashion.png"},
  {"name": "Home", "imageUrl": "assets/home.png"},
  {"name": "Food", "imageUrl": "assets/food.png"},
  {"name": "Beauty & Health", "imageUrl": "assets/beauty.png"},
  {"name": "Automotive", "imageUrl": "assets/automotive.png"},
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
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            _homeBody(context),
            CartView(),
            FavoriteView(),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: _buildBottombar(_currentIndex, (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }),
      ),
    );
  }

  Widget _buildBottombar(int currentIndex, Function(int) onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey[600],
        currentIndex: currentIndex,
        onTap: onTap,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  RefreshIndicator _homeBody(BuildContext context) {
    return RefreshIndicator(
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
    return HomeLoadingWidget();
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
                  ],
                ),
                const SizedBox(height: 16),
                //! Search
                TextField(
                  readOnly: true,
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchView(),
                        ),
                      ),
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
                onBuyNow: () => Utils.onBuyNow(context, product: product),
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
