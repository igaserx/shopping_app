import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/widgets/custom_snack_bar.dart';
import 'package:shopping_app/core/widgets/price_widget.dart';
import 'package:shopping_app/features/cart/presentation/cubits/cubit/cart_cubit.dart';
import 'package:shopping_app/features/cart/presentation/cubits/cubit/cart_state.dart';
import '../../domain/entities/cart_item.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(context),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.items.isEmpty) {
            return _buildEmptyCart(context);
          }
          return Column(
            children: [
              _buildCartHeader(state),
              Expanded(child: _buildCartItems(state)),
              _buildCheckoutSection(context, state),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF2D3748),
      title: const Text(
        "Cart",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      actions: [
        BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.items.isNotEmpty) {
              return IconButton(
                onPressed: () => _showClearCartDialog(context),
                icon: const Icon(Icons.delete_outline),
                tooltip: "Clear Cart",
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: Colors.grey.withValues(alpha: 0.2)),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
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
              Icons.shopping_cart_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your Cart is Empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some items to get started',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Continue Shopping'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5722),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartHeader(CartState state) {
    final itemCount = state.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF5722).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shopping_cart,
              color: const Color(0xFFFF5722),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$itemCount ${itemCount == 1 ? 'item' : 'items'} in your cart',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  'Ready for checkout',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Text(
              'Free Shipping',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(CartState state) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return _buildCartItemCard(context, item, index);
      },
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item, int index) {
    return Dismissible(
  key: ValueKey(item.product.id),
  direction: DismissDirection.endToStart,
  background: Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    color: Colors.red,
    child: const Icon(Icons.delete, color: Colors.white),
  ),
  onDismissed: (direction) {
    
    context.read<CartCubit>().removeItem(item.product.id); 
  },
  child: Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(item),
          const SizedBox(width: 16),
          Expanded(child: _buildProductDetails(item)),
          const SizedBox(width: 12),
          _buildQuantityControls(context, item),
        ],
      ),
    ),
  ),
);

  }

  Widget _buildProductImage(CartItem item) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[50]!, Colors.white],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            item.product.thumbnail,
            fit: BoxFit.contain,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey[400],
                        size: 30,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'No image',
                        style: TextStyle(color: Colors.grey[500], fontSize: 10),
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(CartItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //! Title
        Text(
          item.product.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 6),

        //! Price
        PriceWidget(price: item.product.price),
      ],
    );
  }

  Widget _buildQuantityControls(BuildContext context, CartItem item) {
    return Column(
      children: [

        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //! -
              InkWell(
                onTap: () {
                  if (item.quantity > 1) {
                    context.read<CartCubit>().updateQuantity(
                      item.product.id,
                      item.quantity - 1,
                    );
                  } else {
                    _showRemoveItemDialog(context, item);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: const Icon(Icons.remove, size: 18),
                ),
              ),

              //! Quantity
              Container(
                width: 44,
                height: 36,
                alignment: Alignment.center,
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              //! +
              InkWell(
                onTap: () {
                  context.read<CartCubit>().updateQuantity(
                    item.product.id,
                    item.quantity + 1,
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: const Icon(Icons.add, size: 18),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPriceSummary(state),
              const SizedBox(height: 20),
              _buildCheckoutButton(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSummary(CartState state) {
    final itemCount = state.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    const double shippingCost = 0.0; 

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal ($itemCount items)',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              PriceWidget(price: state.totalPrice, prColor:Colors.grey[600]!, size: 16,)
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(
                shippingCost == 0
                    ? 'Free'
                    : '\$${shippingCost.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  color: shippingCost == 0 ? Colors.green[600] : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              PriceWidget(
                price: state.totalPrice + shippingCost,
                prColor: Color(0xFFFF5722),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context, CartState state) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed:
            state.items.isNotEmpty ? () => _proceedToCheckout(context) : null,
        icon: const Icon(Icons.shopping_cart_checkout),
        label: const Text(
          'Proceed to Checkout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5722),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[600],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Clear Cart'),
            content: const Text("Are you sure?"),
            actions: [
              //! Cancel
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: const Text('Cancel'),
              ),
              //! Clear
              ElevatedButton(
                onPressed: () {
                  context.read<CartCubit>().clearCart();
                  Navigator.pop(context);
                  CustomSnackBar.show(
                    context,
                    "Cart cleared successfully",
                    type: SnackBarType.success,
                  );
                },
                style:
                    ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white
                    ).copyWith(),
                child: const Text('Clear All'),
              ),
            ],
          ),
    );
  }

  void _showRemoveItemDialog(BuildContext context, CartItem item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Remove Item'),
            content: Text('Remove "${item.product.title}" from your cart?'),
            actions: [
              //! Cancel
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              //! Remove
              ElevatedButton(
                onPressed: () {
                  context.read<CartCubit>().removeItem(item.product.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.product.title} removed from cart'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Remove'),
              ),
            ],
          ),
    );
  }

  void _proceedToCheckout(BuildContext context) {
    // TODO
  }
}
