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

}