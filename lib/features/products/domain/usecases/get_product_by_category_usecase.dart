import 'package:shopping_app/features/products/domain/entities/product_entity.dart';
import 'package:shopping_app/features/products/domain/repositories/products_repo.dart';


 class GetProductByCategoryUsecase {
  final ProductRepository repo;

  GetProductByCategoryUsecase({required this.repo});
  Future<List<ProductEntity>> call(List<String> categories) async {
    return repo.getProductByCategory(categories);
  }
}