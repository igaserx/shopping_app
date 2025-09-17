import 'package:shopping_app/core/database/apis/end_points.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.rating,
  });
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json[ApiKeys.id] ,
      title: json[ApiKeys.title] ,
      description: json[ApiKeys.description] ,
      price: json[ApiKeys.price] ,
      imageUrl: json[ApiKeys.imageUrl],
      rating: json[ApiKeys.rating],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id : id,
      ApiKeys.title : title,
      ApiKeys.description: description,
      ApiKeys.price: price,
      ApiKeys.imageUrl: imageUrl,
      ApiKeys.rating: rating,
    };
  }
}
