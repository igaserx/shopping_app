import 'package:shopping_app/core/database/apis/end_points.dart';
import 'package:shopping_app/features/products/domain/entities/subEntities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    required super.rating,
    required super.comment,
    required super.date,
    required super.reviewerName,
    required super.reviewerEmail,
  });
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json[ApiKeys.rating] as int,
      comment: json[ApiKeys.comment] as String,
      date: DateTime.parse(json[ApiKeys.date] as String),
      reviewerName: json[ApiKeys.reviewerName] as String,
      reviewerEmail: json[ApiKeys.reviewerEmail] as String,
    );
  }
}
