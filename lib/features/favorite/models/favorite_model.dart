import 'package:shopping_app/core/database/apis/end_points.dart';
import 'package:shopping_app/features/products/data/models/product_model.dart';
import 'package:shopping_app/features/products/data/models/subModel/dimensions_model.dart';
import 'package:shopping_app/features/products/data/models/subModel/review_model.dart';
import 'package:shopping_app/features/products/domain/entities/product_entity.dart';

class FavoriteModel {
  final ProductEntity product;
  final DateTime addedAt;

  FavoriteModel({
    required this.product,
    required this.addedAt,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      product:  ProductModel(
      id: map[ApiKeys.id] as int,
      title: map[ApiKeys.title] as String,
      description: map[ApiKeys.description] as String,
      price: (map[ApiKeys.price] as num).toDouble(),
      thumbnail: map[ApiKeys.thumbnail] as String,
      rating: (map[ApiKeys.rating] as num).toDouble(),
      images: map[ApiKeys.images] as List<dynamic>,
      reviews:
          (map[ApiKeys.reviews] as List<dynamic>?)
              ?.map((reviewJson) => ReviewModel.fromJson(reviewJson))
              .toList() ??
          [],
      returnPolicy: map[ApiKeys.returnPolicy] as String,
      status: map[ApiKeys.status] as String,
      discount: (map[ApiKeys.discount] as num).toDouble(),
      brand: map[ApiKeys.brand],
      sku: map[ApiKeys.sku] ,
      weight: map[ApiKeys.weight] as int,
      warranty: map[ApiKeys.warranty] ,
      shipping: map[ApiKeys.shipping] ,
      minimumOrder: map[ApiKeys.minimumOrder] as int,
      dimensions: DimensionsModel.fromJson(map[ApiKeys.dimensions] as Map<String, dynamic>),
      stock: map[ApiKeys.stock] as int,
      
    ),
      addedAt: DateTime.parse(map['addedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ApiKeys.id: product.id,
      ApiKeys.title: product.title,
      ApiKeys.description: product.description,
      ApiKeys.price: product.price,
      ApiKeys.thumbnail: product.thumbnail,
      ApiKeys.rating: product.rating,
    
      'addedAt': addedAt.toIso8601String(),
    };
  }
  
}