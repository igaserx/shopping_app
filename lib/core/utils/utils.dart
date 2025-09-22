class Utils {
  //! Discount Method
  static double getDiscountedPrice(double price, double discountPercentage) {
  return price - (price * discountPercentage / 100);
  }
}