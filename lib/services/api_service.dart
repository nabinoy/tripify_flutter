import 'dart:convert';
import 'package:tripify/models/forgot_password_request_model.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/login_request_model.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/models/otp_request_model.dart';
import 'package:tripify/models/review_rating_model.dart';
import 'package:tripify/models/signup_request_model.dart';
import 'package:http/http.dart' as http;
import 'package:tripify/constants/config.dart';
import 'package:tripify/models/user_review_model.dart';
import 'shared_service.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(
    LoginRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.loginAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedService.setSharedLogin(data);
      return true;
    } else {
      return false;
    }
  }

  static Future<dynamic> signup(
    SignupRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.registerAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    }
  }

  static Future<String> userReview(UserReviewModel model) async {
    var userToken = '';
    await SharedService.getSecureUserToken().then((String? data) {
      String? token = data.toString();
      userToken = token;
    });

    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $userToken',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };

    var url = Uri.https(
      Config.apiURL,
      Config.reviewAPI,
    );
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Done';
    } else {
      return 'Error, please try again!';
    }
  }

  static Future<bool> forgotpassword(
    ForgotPasswordRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.forgotPasswordAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<PlaceDetails> placeAll() async {
    var userToken = '';
    await SharedService.getSecureUserToken().then((String? data) {
      String? token = data.toString();
      userToken = token;
    });

    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $userToken',
      'Accept': 'application/json',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.placeAllAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      PlaceDetails pd = PlaceDetails.fromJson(data);
      return pd;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<CategoryAll>> categoryAll() async {
    var userToken = '';
    await SharedService.getSecureUserToken().then((String? data) {
      String? token = data.toString();
      userToken = token;
    });

    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $userToken',
      'Accept': 'application/json',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.categoryAllAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['categories'];
      List<CategoryAll> c = [];

      for (var i = 0; i < data.length; i++) {
        CategoryAll ca = CategoryAll.fromJson(data[i]);
        c.add(ca);
      }
      return c;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<ServiceAll>> serviceAll() async {
    //var userToken = '';
    // await SharedService.getSecureUserToken().then((String? data) {
    //   String? token = data.toString();
    //   userToken = token;
    // });

    Map<String, String> requestHeaders = {
     // 'Authorization': 'Bearer $userToken',
      'Accept': 'application/json',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.serviceAllAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['services'];
      List<ServiceAll> s = [];

      for (var i = 0; i < data.length; i++) {
        ServiceAll sa = ServiceAll.fromJson(data[i]);
        s.add(sa);
      }
      return s;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<IslandAll>> islandAll() async {
    var userToken = '';
    await SharedService.getSecureUserToken().then((String? data) {
      String? token = data.toString();
      userToken = token;
    });

    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $userToken',
      'Accept': 'application/json',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.islandAllAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['islands'];
      List<IslandAll> ia = [];

      for (var i = 0; i < data.length; i++) {
        IslandAll iaa = IslandAll.fromJson(data[i]);
        ia.add(iaa);
      }
      return ia;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<ReviewRatings> reviewRatingAll(String id) async {
    var userToken = '';
    await SharedService.getSecureUserToken().then((String? data) {
      String? token = data.toString();
      userToken = token;
    });

    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $userToken',
      'Accept': 'application/json',
    };
    final queryParameters = {'id': id};
    var url = Uri.https(
      Config.apiURL,
      Config.ratingAllAPI,
      queryParameters,
    );
    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      ReviewRatings rr = ReviewRatings.fromJson(data);
      return rr;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<String> deleteUserReview(String id) async {
    var userToken = '';
    await SharedService.getSecureUserToken().then((String? data) {
      String? token = data.toString();
      userToken = token;
    });

    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $userToken',
      'Accept': 'application/json',
    };
    final queryParameters = {'id': id};
    var url = Uri.https(
      Config.apiURL,
      Config.reviewAPI,
      queryParameters,
    );
    var response = await client.delete(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      return 'Successfully deleted!';
    } else {
      throw Exception('Error, please try again!');
    }
  }

  static Future<String> regenerateOTP(RegenerateOTPRequest model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var url = Uri.https(
      Config.apiURL,
      Config.regenerateOTPAPI,
    );
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Successfully Resend OTP';
    } else {
      throw Exception('Error, please try again!');
    }
  }

  static Future<dynamic> verifyOTP(VerifyOTPRequest model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var url = Uri.https(
      Config.apiURL,
      Config.verifyOTPAPI,
    );
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      SharedService.setSharedLogin(data);
      return data;
    } else {
      throw Exception('Error, please try again!');
    }
  }

  static Future<String> updateUserReview(UserReviewModel model) async {
    var userToken = '';
    await SharedService.getSecureUserToken().then((String? data) {
      String? token = data.toString();
      userToken = token;
    });

    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $userToken',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    var url = Uri.https(
      Config.apiURL,
      Config.reviewAPI,
    );
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
      return 'Successfully updated!';
    } else {
      throw Exception('Error, please try again!');
    }
  }

  static Future<ReviewUser> reviewRatingUser(String id) async {
    var userToken = '';
    await SharedService.getSecureUserToken().then((String? data) {
      String? token = data.toString();
      userToken = token;
    });

    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $userToken',
      'Accept': 'application/json',
    };
    final queryParameters = {'id': id};
    var url = Uri.https(
      Config.apiURL,
      Config.userReviewAPI,
      queryParameters,
    );
    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['review'];
      ReviewUser ru = ReviewUser.fromJson(data);
      return ru;
    } else if (response.statusCode == 500 &&
        json.decode(response.body)['message'] == 'No review found.') {
      var emptyJson = {
        "user": "",
        "name": "",
        "rating": 0,
        "comment": "",
        "sentiment": "",
        "_id": "",
        "date": ""
      };
      ReviewUser ru = ReviewUser.fromJson(emptyJson);
      return ru;
    } else {
      throw Exception('Failed to load person details');
    }
  }
}
