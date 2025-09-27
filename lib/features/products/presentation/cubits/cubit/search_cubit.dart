
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/products/domain/repositories/products_repo.dart';
import 'package:shopping_app/features/products/presentation/cubits/cubit/search_state.dart';

class ProductSearchCubit extends Cubit<ProductSearchState> {
  final ProductRepository productRepository;

  ProductSearchCubit({required this.productRepository})
      : super(ProductSearchInitial());

   searchProducts(String query) async {
    if (query.isEmpty) {
      emit(ProductSearchInitial());
      return;
    }

    emit(ProductSearchLoading());

    try {
      final products = await productRepository.searchProducts(query);
      emit(ProductSearchLoaded(products));
    } catch (e) {
      emit(ProductSearchError(e.toString()));
    }
  }

  void clearSearch() {
    emit(ProductSearchInitial());
  }
}