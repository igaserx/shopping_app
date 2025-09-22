import 'package:shopping_app/core/database/apis/end_points.dart';
import 'package:shopping_app/features/products/data/models/subModel/dimensions_model.dart';
import 'package:shopping_app/features/products/data/models/subModel/review_model.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.thumbnail,
    required super.rating,
    required super.images,
    required super.reviews,
    required super.returnPolicy,
    required super.status,
    required super.discount,
    required super.brand,
    required super.sku,
    required super.weight,
    required super.warranty,
    required super.shipping,
    required super.minimumOrder,
    required super.dimensions,
    required super.stock,
  });
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json[ApiKeys.id] as int,
      title: json[ApiKeys.title] as String,
      description: json[ApiKeys.description] as String,
      price: (json[ApiKeys.price] as num).toDouble(),
      thumbnail: json[ApiKeys.thumbnail] as String,
      rating: (json[ApiKeys.rating] as num).toDouble(),
      images: json[ApiKeys.images] as List<dynamic>,
      reviews:
          (json[ApiKeys.reviews] as List<dynamic>?)
              ?.map((reviewJson) => ReviewModel.fromJson(reviewJson))
              .toList() ??
          [],
      returnPolicy: json[ApiKeys.returnPolicy] as String,
      status: json[ApiKeys.status] as String,
      discount: (json[ApiKeys.discount] as num).toDouble(),
      brand: json[ApiKeys.brand],
      sku: json[ApiKeys.sku] ,
      weight: json[ApiKeys.weight] as int,
      warranty: json[ApiKeys.warranty] ,
      shipping: json[ApiKeys.shipping] ,
      minimumOrder: json[ApiKeys.minimumOrder] as int,
      dimensions: DimensionsModel.fromJson(json[ApiKeys.dimensions] as Map<String, dynamic>),
      stock: json[ApiKeys.stock] as int,
      
    );
  }
  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.title: title,
      ApiKeys.description: description,
      ApiKeys.price: price,
      ApiKeys.thumbnail: thumbnail,
      ApiKeys.rating: rating,
    };
  }
}
