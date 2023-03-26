class UserReviewModel {
  String? placeId;
  int? rating;
  String? comment;

  UserReviewModel({required this.placeId,required this.rating,required this.comment});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['placeId'] = placeId;
    data['rating'] = rating;
    data['comment'] = comment;
    return data;
  }
}
