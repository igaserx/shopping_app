import 'package:shopping_app/features/products/data/data_sources/data_source.dart';
import 'package:shopping_app/features/products/data/models/product_model.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';
import 'package:shopping_app/features/products/domain/repositories/products_repo.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    final productsJson = await remoteDataSource.getAllProducts();
    return productsJson.map((json) => ProductModel.fromJson(json)).toList();
  }
}
