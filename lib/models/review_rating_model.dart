class ReviewRatings {
  List<Reviews2> reviews;
  int oneCount;
  int twoCount;
  int threeCount;
  int fourCount;
  int fiveCount;
  int positiveResponse;
  int negativeResponse;
  int neutralResponse;
  int numberOfReviews;
  double ratingsAverage;

  ReviewRatings(
      {required this.reviews,
      required this.oneCount,
      required this.twoCount,
      required this.threeCount,
      required this.fourCount,
      required this.fiveCount,
      required this.positiveResponse,
      required this.negativeResponse,
      required this.neutralResponse,
      required this.numberOfReviews,
      required this.ratingsAverage});

  factory ReviewRatings.fromJson(Map<String, dynamic> json) {
    return ReviewRatings(
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => Reviews2.fromJson(e))
          .toList(),
// reviews : (json['reviews'] != null ? Reviews2.fromJson(json['reviews']) : null)!,
      oneCount: json['oneCount'],
      twoCount: json['twoCount'],
      threeCount: json['threeCount'],
      fourCount: json['fourCount'],
      fiveCount: json['fiveCount'],
      positiveResponse: json['positiveResponse'],
      negativeResponse: json['negativeResponse'],
      neutralResponse: json['neutralResponse'],
      numberOfReviews: json['numberOfReviews'],
      ratingsAverage: json['ratingsAverage'].toDouble(),
    );
  }
}

class Reviews2 {
  String user;
  String name;
  int rating;
  String comment;
  String date;
  String sId;
  String sentiment;

  Reviews2(
      {required this.user,
      required this.name,
      required this.rating,
      required this.comment,
      required this.date,
      required this.sId,
      required this.sentiment});

  factory Reviews2.fromJson(Map<String, dynamic> json) {
    return Reviews2(
      user: json['user'],
      name: json['name'],
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'],
      sId: json['_id'],
      sentiment: json['sentiment'],
    );
  }
}

class ReviewUser {
  String user;
  String name;
  int rating;
  String comment;
  String date;
  String sId;
  String sentiment;

  ReviewUser(
      {required this.user,
      required this.name,
      required this.rating,
      required this.comment,
      required this.sentiment,
      required this.sId,
      required this.date});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      user: json['user'],
      name: json['name'],
      rating: json['rating'],
      comment: json['comment'],
      sentiment: json['sentiment'],
      sId: json['_id'],
      date: json['date'],
    );
  }
}
