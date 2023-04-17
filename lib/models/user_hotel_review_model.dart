class UserHotelReviewModel {
  String hotelId;
  int rating;
  String comment;

  UserHotelReviewModel({required this.hotelId,required this.rating,required this.comment});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hotelId'] = hotelId;
    data['rating'] = rating;
    data['comment'] = comment;
    return data;
  }
}