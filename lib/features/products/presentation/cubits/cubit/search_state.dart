import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';

abstract class ProductSearchState extends Equatable {
  const ProductSearchState();

  @override
  List<Object> get props => [];
}

class ProductSearchInitial extends ProductSearchState {}

class ProductSearchLoading extends ProductSearchState {}

class ProductSearchLoaded extends ProductSearchState {
  final List<ProductEntity> products;

  const ProductSearchLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductSearchError extends ProductSearchState {
  final String message;

  const ProductSearchError(this.message);

  @override
  List<Object> get props => [message];
}