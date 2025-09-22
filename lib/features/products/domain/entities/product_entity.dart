import 'package:shopping_app/features/products/domain/entities/subEntities/dimensions_entity.dart';
import 'package:shopping_app/features/products/domain/entities/subEntities/review_entity.dart';

class ProductEntity {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final List<dynamic> images;
  final double rating;
  final List<ReviewEntity> reviews;
  final String returnPolicy;
  final String status;
  final double discount;
  final String? brand;
  final String sku;
  final int weight;
  final String warranty;
  final String shipping;
  final int minimumOrder;
  final DimensionsEntity dimensions;
  final int stock;





  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.rating,
    required this.images,
    required this.returnPolicy,
    required this.status,
    required this.discount,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.warranty,
    required this.shipping,
    required this.minimumOrder,
    this.reviews = const [],
    required this.dimensions,
    required this.stock,
    
  });
}
