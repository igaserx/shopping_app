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
      id: json[ApiKeys.id] as int,
      title: json[ApiKeys.title] as String,
      description: json[ApiKeys.description] as String  ,
      price: (json[ApiKeys.price] as num).toDouble(),
      imageUrl: json[ApiKeys.imageUrl] as String,
      rating: (json[ApiKeys.rating] as num).toDouble(),
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
