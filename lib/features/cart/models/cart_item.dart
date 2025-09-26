import 'package:shopping_app/core/utils/utils.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';

class CartItem {
  final ProductEntity product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  double get totalPrice => Utils.getDiscountedPrice(product.price, product.discount) * quantity;

  CartItem copyWith({ProductEntity? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
