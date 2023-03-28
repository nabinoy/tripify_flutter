class RegenerateOTPRequest {
  String? email;

  RegenerateOTPRequest({this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    return data;
  }
}

class VerifyOTPRequest {
  String? otp;

  VerifyOTPRequest({this.otp});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otp'] = otp;
    return data;
  }
}
