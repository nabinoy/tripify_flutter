class UpdateNameModel {
  String name;

  UpdateNameModel({required this.name});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class UpdatePasswordModel {
  String oldPassword;
  String password;

  UpdatePasswordModel({required this.oldPassword, required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oldPassword'] = oldPassword;
    data['password'] = password;
    return data;
  }
}

