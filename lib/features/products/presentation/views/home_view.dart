import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/DI/di.dart';
import 'package:shopping_app/features/cart/views/cart_view.dart';
import 'package:shopping_app/features/favorite/views/favorite_view.dart';
import 'package:shopping_app/features/products/data/models/banner_item.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';
import 'package:shopping_app/features/products/presentation/cubits/prduct_cubit.dart';
import 'package:shopping_app/features/products/presentation/cubits/prduct_state.dart';
import 'package:shopping_app/features/products/presentation/views/all_products_view.dart';
import 'package:shopping_app/features/products/presentation/widgets/hot_offers.dart';
import 'package:shopping_app/features/products/presentation/views/product_details.dart';
import 'package:shopping_app/core/widgets/v_product_card.dart';
import 'package:shopping_app/features/products/presentation/widgets/home_loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/features/products/presentation/widgets/top_picks.dart';
import 'package:shopping_app/features/profile/views/profile_view.dart';
import '../../../../core/utils/utils.dart';

 Map<String, List<String>> mainCategories = {
  "Electronics".tr() : ["smartphones", "laptops"],
  "Fashion".tr(): [
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
  "Furniture".tr(): ["home-decoration", "furniture", "lighting"],
  "groceries".tr(): ["groceries"],
  "Beauty_Health".tr(): ["fragrances", "skincare"],
  "Automotive".tr(): ["automotive", "motorcycle"],
};

final List<Map<String, String>> categoriesData = [
  {"name": "Electronics".tr(), "imageUrl": "assets/electroinc.png"},
  {"name": "Fashion".tr(), "imageUrl": "assets/fashion.png"},
  {"name": "Furniture".tr(), "imageUrl": "assets/home.png"},
  {"name": "groceries".tr(), "imageUrl": "assets/food.png"},
  {"name": "Beauty_Health".tr(), "imageUrl": "assets/beauty.png"},
  {"name": "Automotive".tr(), "imageUrl": "assets/automotive.png"},
];

final List<BannerItem> bannersData = [
  BannerItem(
    title: "Welcome_to_our_Shopping_app".tr(),
    subtitle: "Find_everything_you_need_in_one_place".tr(),
    imageUrl: "https://cdn-icons-png.flaticon.com/512/3081/3081559.png",
  ),
  BannerItem(
    title: "Discover_New_Products".tr(),
    subtitle: "Browse_our_latest_and_greatest_items".tr(),
    imageUrl: "https://cdn-icons-png.flaticon.com/512/1170/1170576.png",
  ),
   BannerItem(
    title: "Enjoy_Fast_Delivery".tr(),
    subtitle: "Get_your_orders_delivered_quickly_and_safely".tr(),
    imageUrl: "https://cdn-icons-png.flaticon.com/512/1046/1046857.png",
  ),
];

class HomeView extends StatelessWidget {
  static const String routeName = "HomeView";
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    

    return BlocProvider(
      create: (context) => di<ProductCubit>()..getAllProducts(),
      child: HomeViewBody(),
    );
  }
}

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key,});


  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  int _currentIndex = 0;
   final _pages = [
    HomeContent(),
    CartView(),
    FavoriteView(),
    ProfileView(),
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: IndexedStack(
            key: ValueKey<int>(_currentIndex),
            index: _currentIndex,
            children: _pages,
          ),
        ),
        bottomNavigationBar: _buildBottombar(_currentIndex, (index) {
          setState(() {
            _currentIndex = index;
          });
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
            label: "Home".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: "Cart".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: "Favorite".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile".tr(),
          ),
        ],
      ),
    );
  }

}


class HomeContent extends StatefulWidget{
  
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final fullName = FirebaseAuth.instance.currentUser?.displayName ?? 'User';
  
  @override
  Widget build(BuildContext context) {
    
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ProductCubit>().getAllProducts();
      },
      color: const Color(0xFFFF5722),
      child: Scaffold(
        appBar: AppBar(title: Text("Our_Products".tr(),),
        elevation: 0,
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
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
      )
    );
  }

  Widget _buildInitialState() {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
           Text(
            "Ready_to_browse_products".tr(),
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
            "No_Products_Found".tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We_could_not_find_any_products_at_the_moment".tr(),
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.read<ProductCubit>().getAllProducts(),
            icon: const Icon(Icons.refresh),
            label: Text("Refresh".tr()),
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
              "Oops_Something_went_wrong".tr(),
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
                  label: Text("Go_Back".tr()),
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
                  label: Text("Try_Again".tr()),
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
        //! Top Picks
        SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            "Top_Picks".tr(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),  
        ),
        ),

        //! PageView
        SliverToBoxAdapter(
          child: SizedBox(
            height : 200,
            child: FeaturedProductsWidget(
                products: products,),
          )
        ),

        SliverToBoxAdapter(child: SizedBox(height: 24,)),
       
        SliverToBoxAdapter(
          child: HotOffersWidget(offers: products,))
        ,
        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // ! Popular Products
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AllProductsView(products: products,),
                    ),
                  );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular_Products".tr(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "See_All".tr(),
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
            itemCount: 20,
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
  
  

