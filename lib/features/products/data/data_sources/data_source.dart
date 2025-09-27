import 'package:shopping_app/core/database/apis/api_consumer.dart';
import 'package:shopping_app/core/database/apis/end_points.dart';
import 'package:shopping_app/core/errors/error_model.dart';
import 'package:shopping_app/core/errors/exceptions.dart';
import 'package:shopping_app/features/products/data/models/product_model.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';
abstract class ProductRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllProducts();
  Future<List<Map<String, dynamic>>> getProductByCategory(List<String> categories);
   Future<List<ProductModel>>searchProducts(String query);
}

class ProductRemoteDatasourcesImpl extends ProductRemoteDataSource {
  final ApiConsumer api;

  ProductRemoteDatasourcesImpl({required this.api});

  @override
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final response = await api.get("${EndPoints.product}?limit=250"); 
    final products = response[EndPoints.product] as List<dynamic>;
    return List<Map<String, dynamic>>.from(products);
  }
  
  @override
 Future<List<Map<String, dynamic>>> getProductByCategory(
    List<String> categories) async {
  List<Map<String, dynamic>> allProducts = [];

  for (final category in categories) {
    final response = await api.get("${EndPoints.product}/${EndPoints.category}/$category");
    final products = response[EndPoints.product] as List<dynamic>;
    allProducts.addAll(List<Map<String, dynamic>>.from(products));
  }

  return allProducts;
}
@override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await api.get(
        "${EndPoints.product}/${EndPoints.search}",
        queryParameters: {EndPoints.query: query},
      );
      
      
      Map<String, dynamic> responseData;
      
      if (response is Map<String, dynamic>) {
        responseData = response;
      } else {
      
        responseData = response.data as Map<String, dynamic>;
      }
      
      final List<dynamic> productsJson = responseData['products'] ?? [];
      
      return productsJson
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
          
    } catch (e) {
      throw ServerException(
        errorModel: ErrorModel(errMessage: 'Failed to search products: ${e.toString()}', statusCode:  500)
      );
    }
  }
}
