import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/widgets/custom_snack_bar.dart';
import 'package:shopping_app/features/cart/presentation/cubits/cubit/cart_cubit.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';

import '../../features/cart/domain/entities/cart_item.dart';

class Utils {
  //! Discount Method
  static double getDiscountedPrice(double price, double discountPercentage) {
  return price - (price * discountPercentage / 100);
  }
  //! days
  static int daysAgo(String dateIso) {
  final dateTime = DateTime.parse(dateIso); 
  final now = DateTime.now().toUtc();       
  final difference = now.difference(dateTime);
  return difference.inDays;
}
  //! add to cart
  static void onAddToCart( BuildContext context,{required ProductEntity product}) {
    try {
    final cartCubit = context.read<CartCubit>();
  cartCubit.addItem(CartItem(product: product, quantity: 1));
  CustomSnackBar.show(context, "${product.title} added to cart!", type: SnackBarType.success);
}catch (e) {
   CustomSnackBar.show(
    context,e.toString(), type: SnackBarType.warning
   );
}
  }
}