import 'dart:convert';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:tripify/models/forgot_password_request_model.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/login_request_model.dart';
import 'package:tripify/models/place_response_model.dart';
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
      print(response.statusCode);
      Document document = parse(response.body);
      Element? errorElement = document.querySelector('pre');
      String errorString = errorElement!.text;
      final pattern = RegExp(r'Error: (.*?)\s+at');
      final match = pattern.firstMatch(errorString);
      final errorMessage = match!.group(1);
      print(errorMessage);
      return false;
    }
  }

  static Future<String> signup(
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
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedService.setSharedLogin(data);
      return 'Done';
    } else {
      if (response.body
          .toString()
          .contains('E11000 duplicate key error collection')) {
        return 'This email is already taken. Please use a different email';
      } else {
        return 'Sorry, we couldn\'t process your request due to a server error. Please try again later.';
      }
    }
  }

  static Future<String> userReview(
    UserReviewModel model,
  ) async {
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
    print(jsonEncode(model.toJson()));
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    print(response.statusCode);
    print(response.body);
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
      Document document = parse(response.body);
      Element? errorElement = document.querySelector('pre');
      String errorString = errorElement!.text;
      final pattern = RegExp(r'Error: (.*?)\s+at');
      final match = pattern.firstMatch(errorString);
      final errorMessage = match!.group(1);
      print(errorMessage);
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
