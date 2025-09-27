
import 'package:flutter/material.dart';
import 'package:shopping_app/core/utils/utils.dart';
import 'package:shopping_app/core/widgets/price_widget.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;

  const ProductItemWidget({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final price = Utils.getDiscountedPrice(product.price, product.discount);
    return Card(
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            product.thumbnail,
            width: 45,
            height: 45,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 45,
                height: 45,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
        title: Text(
          product.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: PriceWidget(price: price, size: 16, prColor: Colors.deepOrange[400]!,),
        onTap: onTap,
      ),
    );
  }
}
