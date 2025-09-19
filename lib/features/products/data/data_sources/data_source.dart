import 'package:shopping_app/core/database/apis/api_consumer.dart';
import 'package:shopping_app/core/database/apis/end_points.dart';

abstract class ProductRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllProducts();
}

class ProductRemoteDatasourcesImpl extends ProductRemoteDataSource {
  final ApiConsumer api;

  ProductRemoteDatasourcesImpl({required this.api});

  @override
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final response = await api.get(EndPoints.product); 
    final products = response['products'] as List<dynamic>;
    return List<Map<String, dynamic>>.from(products);
  }
}
