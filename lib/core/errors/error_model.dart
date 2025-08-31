class ErrorModel {
  final int statusCode; 
  final String errMessage;

  ErrorModel({required this.statusCode, required this.errMessage});
  factory ErrorModel.fromJson(Map<String,dynamic>json){
    return ErrorModel(statusCode: json[""], errMessage: json[""]);
  }
}