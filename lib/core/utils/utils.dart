import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/widgets/custom_snack_bar.dart';
import 'package:shopping_app/features/cart/cubits/cart_cubit.dart';
import 'package:shopping_app/features/cart/models/cart_item.dart';
import 'package:shopping_app/features/check_out/views/buy_now_view.dart';
import 'package:shopping_app/features/check_out/views/check_out_view.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';

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

  //! buy 
  static void onBuyNow(BuildContext context, {required ProductEntity product}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  BuyNowView(product: product,),
      ),
  );
    CustomSnackBar.show(context, 'Proceeding to buy ${product.title}', type: SnackBarType.custom,customColor: Colors.amber[800]);
  }
  //! Proceeding to buy 
  static void onProceedingToBuy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CheckoutView(),
      ),
    );
    CustomSnackBar.show(context, 'Proceeding to buy all items', type: SnackBarType.custom, customColor:  Colors.amber[800]);
  }
  //! change language
  static void changeToArabic(BuildContext context) {
  context.setLocale(const Locale('ar'));
  }
  static void changeToEnglish(BuildContext context) {
  context.setLocale(const Locale('en'));
  }
}