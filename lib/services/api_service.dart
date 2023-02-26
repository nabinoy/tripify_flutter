import 'dart:convert';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:tripify/models/forgot_password_request_model.dart';
import 'package:tripify/models/login_request_model.dart';
import 'package:tripify/models/login_response_model.dart';
import 'package:tripify/models/signup_request_model.dart';
import 'package:tripify/models/signup_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:tripify/constants/config.dart';
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
      } else{
        return 'Sorry, we couldn\'t process your request due to a server error. Please try again later.';
      }
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
      print(response.body);
      return true;
    } else {
      print(response.statusCode);
      print(response.body);
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
}
