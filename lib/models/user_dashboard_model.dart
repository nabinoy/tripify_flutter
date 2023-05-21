class UserDashboard {
  String sId;
  String name;
  String email;
  String role;
  List<String> wishlist;
  String createdAt;
  int? iV;

  UserDashboard(
      {required this.sId,
      required this.name,
      required this.email,
      required this.role,
      required this.wishlist,
      required this.createdAt,
      required this.iV});

  factory UserDashboard.fromJson(Map<String, dynamic> json) {
    return UserDashboard(
      sId :json['_id'],
    name : json['name'],
    email : json['email'],
    role : json['role'],
    wishlist : json['wishlist'].cast<String>(),
    createdAt : json['createdAt'],
    iV : json['__v'],
    );
  }
}

class FeedBackModel {
  String? description;

  FeedBackModel({this.description});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    return data;
  }
}
