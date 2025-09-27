import 'package:shopping_app/features/products/domain/entities/product_entity.dart';
import 'package:shopping_app/features/products/domain/repositories/products_repo.dart';

class SearchProductsUsecase {
  final ProductRepository repo;

  SearchProductsUsecase({required this.repo});

  Future<List<ProductEntity>> call(String query) async {
    return repo.searchProducts(query);
  }
}
