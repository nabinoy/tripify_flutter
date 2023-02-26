import 'dart:convert';

SignupResponseModel signupResponseJson(String str) =>
    SignupResponseModel.fromJson(json.decode(str));

class SignupResponseModel {
  late final bool success;
  late final String token;
  late final User user;

  SignupResponseModel(
      {required this.success, required this.token, required this.user});

  SignupResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    token = json['token'];
    user = (json['user'] != null ? User.fromJson(json['user']) : null)!;
  }

  get data => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['token'] = token;
    data['user'] = user.toJson();
    return data;
  }
}

class User {
  late final String name;
  late final String email;
  late final String role;
  late final String id;
  late final String createdAt;

  User(
      {required this.name,
      required this.email,
      required this.role,
      required this.id,
      required this.createdAt});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    role = json['role'];
    id = json['_id'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['_id'] = id;
    data['createdAt'] = createdAt;
    return data;
  }
}
