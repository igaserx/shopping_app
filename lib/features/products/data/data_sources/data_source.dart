import 'package:shopping_app/core/database/apis/api_consumer.dart';
import 'package:shopping_app/core/database/apis/end_points.dart';
abstract class ProductRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllProducts();
  Future<List<Map<String, dynamic>>> getProductByCategory(List<String> categories);
}

class ProductRemoteDatasourcesImpl extends ProductRemoteDataSource {
  final ApiConsumer api;

  ProductRemoteDatasourcesImpl({required this.api});

  @override
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final response = await api.get("${EndPoints.product}?limit=100"); 
    final products = response['products'] as List<dynamic>;
    return List<Map<String, dynamic>>.from(products);
  }
  
  @override
 Future<List<Map<String, dynamic>>> getProductByCategory(
    List<String> categories) async {
  List<Map<String, dynamic>> allProducts = [];

  for (final category in categories) {
    final response = await api.get("${EndPoints.product}/category/$category");
    final products = response['products'] as List<dynamic>;
    allProducts.addAll(List<Map<String, dynamic>>.from(products));
  }

  return allProducts;
}
}
