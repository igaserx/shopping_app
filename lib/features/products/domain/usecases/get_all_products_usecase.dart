import 'package:shopping_app/features/products/domain/entities/product_entity.dart';
import 'package:shopping_app/features/products/domain/repositories/products_repo.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;

  const GetAllProductsUseCase({required this.repository});

  Future<List<ProductEntity>> call() async {
    return await repository.getAllProducts();
  }
}
