import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/cart/cubits/cart_state.dart';
import 'package:shopping_app/features/cart/models/cart_item.dart';


class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(items: []));

  void addItem(CartItem item) {
    final existingIndex = state.items.indexWhere(
      (element) => element.product.id == item.product.id,
    );

    if (existingIndex != -1) {
      final updatedItem = state.items[existingIndex].copyWith(
        quantity: state.items[existingIndex].quantity + item.quantity,
      );

      final updatedItems = List<CartItem>.from(state.items)
        ..[existingIndex] = updatedItem;

      emit(state.copyWith(items: updatedItems));
    } else {
      emit(state.copyWith(items: [...state.items, item]));
    }
  }

  void removeItem(int productId) {
    emit(
      state.copyWith(
        items: state.items
            .where((item) => item.product.id != productId)
            .toList(),
      ),
    );
  }

  void updateQuantity(int productId, int quantity) {
    final index = state.items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (quantity <= 0) {
        
        removeItem( productId);
      } else {
        final updatedItem = state.items[index].copyWith(quantity: quantity);
        final updatedItems = List<CartItem>.from(state.items)
          ..[index] = updatedItem;
        emit(state.copyWith(items: updatedItems));
      }
    }
  }

  void clearCart() {
    emit(state.copyWith(items: []));
  }
}
