import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
  //! App theme
 static ThemeData appTheme(BuildContext context) {
  final currentLocale = context.locale.languageCode;

  final baseTextTheme = currentLocale == 'ar'
      ? GoogleFonts.cairoTextTheme()
      : GoogleFonts.robotoTextTheme();

  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepOrange,
    primary: Colors.deepOrange,
    secondary: Colors.orangeAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black87,
  );

  return ThemeData(
    useMaterial3: true,
    primaryColor: Colors.deepOrange,
    colorScheme: colorScheme,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepOrange,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),

    // OutlinedButton
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.deepOrange),
        foregroundColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      titleTextStyle: baseTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.deepOrange,
      ),
      contentTextStyle: baseTextTheme.bodyMedium?.copyWith(
        color: Colors.black87,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.deepOrange,
        textStyle: baseTextTheme.labelLarge,
      ),
    ),
    textTheme: baseTextTheme.apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black87,
    ),
  );
}
//! Dialog
static Future<void> showSuccesDialog(BuildContext context,{ required String message, required String goTo}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 60,
        ),
        content: Text(message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, goTo);
            },
            child:  Text(
              "Close".tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}


}