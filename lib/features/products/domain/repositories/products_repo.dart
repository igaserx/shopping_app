import 'package:shopping_app/features/products/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getAllProducts();
  Future<List<ProductEntity>> getProductByCategory(List<String> categories);
  Future<List<ProductEntity>> searchProducts(String query);

}