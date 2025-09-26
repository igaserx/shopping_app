
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:shopping_app/features/check_out/cubits/order_state.dart';
import 'package:shopping_app/features/check_out/models/order_model.dart';


class CheckoutCubit extends Cubit<CheckoutState> {
  static const String _ordersKey = 'orders_history';
  
  CheckoutCubit() : super(CheckoutInitial());

  Future<void> placeOrder({
    required List<dynamic> cartItems,
    required double totalAmount,
    required String address,
    required String phone,
    required String paymentMethod,
  }) async {
    emit(CheckoutLoading());
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      //! Generate order ID
      final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';
      
      
      final order = OrderModel(
        orderId: orderId,
        items: cartItems,
        totalAmount: totalAmount,
        shippingAddress: address,
        phoneNumber: phone,
        paymentMethod: paymentMethod,
        orderDate: DateTime.now(),
      );
      
      await _saveOrder(order);
      
      emit(CheckoutSuccess(orderId, 'Order placed successfully!'));
    } catch (e) {
      emit(CheckoutError('Failed to place order. Please try again.'));
    }
  }

  Future<void> _saveOrder(OrderModel order) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingOrders = prefs.getStringList(_ordersKey) ?? [];
      
      existingOrders.add(jsonEncode(order.toMap()));
      await prefs.setStringList(_ordersKey, existingOrders);
    } catch (e) {
      throw Exception('Failed to save order');
    }
  }
}