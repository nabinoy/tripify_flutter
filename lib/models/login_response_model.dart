import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  late final bool success;
  late final String token;
  late final User user;

  LoginResponseModel(
      {required this.success, required this.token, required this.user});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['sucess'];
    token = json['token'];
    user = (json['user'] != null ? User.fromJson(json['user']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sucess'] = success;
    data['token'] = token;
    data['user'] = user.toJson();
    return data;
  }
}

class User {
  late final String id;
  late final String name;
  late final String email;
  late final String role;
  late final String forgotPasswordExpiry;
  late final String forgotPasswordToken;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      required this.forgotPasswordExpiry,
      required this.forgotPasswordToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    forgotPasswordExpiry = json['forgotPasswordExpiry'];
    forgotPasswordToken = json['forgotPasswordToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['forgotPasswordExpiry'] = forgotPasswordExpiry;
    data['forgotPasswordToken'] = forgotPasswordToken;
    return data;
  }
}
