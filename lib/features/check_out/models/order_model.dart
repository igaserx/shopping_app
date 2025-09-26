class OrderModel {
  final String orderId;
  final List<dynamic> items; 
  final double totalAmount;
  final String shippingAddress;
  final String phoneNumber;
  final String paymentMethod;
  final DateTime orderDate;
  final String status;

  OrderModel({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.phoneNumber,
    required this.paymentMethod,
    required this.orderDate,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'items': items.map((item) => {
        'title': item.product.title,
        'price': item.product.price,
        'quantity': item.quantity,
        'thumbnail': item.product.thumbnail,
      }).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'phoneNumber': phoneNumber,
      'paymentMethod': paymentMethod,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }
}