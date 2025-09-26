
abstract class CheckoutState {
  const CheckoutState();
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final String orderId;
  final String message;
  
  const CheckoutSuccess(this.orderId, this.message);
}

class CheckoutError extends CheckoutState {
  final String message;
  
  const CheckoutError(this.message);
}