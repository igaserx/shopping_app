import 'package:flutter/material.dart';
import 'package:shopping_app/core/utils/utils.dart';
import 'package:shopping_app/core/widgets/v_product_card.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';
import 'package:shopping_app/features/products/presentation/views/product_details.dart';
import 'package:shopping_app/features/products/presentation/views/search_view.dart';

class AllProductsView extends StatelessWidget {
  final List<ProductEntity> products;

  const AllProductsView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchView(),));
          }, icon: Icon(Icons.search,))
        ],
      ),
      body: CustomScrollView(
        slivers: [
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
                        builder: (context) => ProductDetailsView(product: product),
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
      ),
    );
  }
}
