import 'package:shopping_app/core/database/apis/end_points.dart';
import 'package:shopping_app/features/products/domain/entities/subEntities/dimensions_entity.dart';

class DimensionsModel extends DimensionsEntity {
  const DimensionsModel({
    required super.width,
    required super.height,
    required super.depth,
  });
  factory DimensionsModel.fromJson(Map<String, dynamic> json){
    return DimensionsModel(
      width: (json[ApiKeys.width]as num).toDouble(), 
      height: (json[ApiKeys.height]as num).toDouble(), 
      depth: (json[ApiKeys.depth] as num).toDouble(),
      );
  }
}
