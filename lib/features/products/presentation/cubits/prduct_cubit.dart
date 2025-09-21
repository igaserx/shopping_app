import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/products/domain/usecases/get_all_products_usecase.dart';
import 'package:shopping_app/features/products/domain/usecases/get_product_by_category_usecase.dart';
import 'package:shopping_app/features/products/presentation/cubits/prduct_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetProductByCategoryUsecase getProductByCategoryUsecase;

  ProductCubit({required this.getAllProductsUseCase, required this.getProductByCategoryUsecase}) : super(ProductInitial());

getAllProducts() async {
  emit(ProductLoading());
  try {
    final products = await getAllProductsUseCase.call();
    emit(ProductLoaded(products: products));
  } catch (e) {
    emit(ProductError(message: e.toString()));
  }
}
 getProductsByCategory(List<String> category) async {
    emit(ProductLoading());
    try {
      final products = await getProductByCategoryUsecase.call(category);
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
