import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tripify/models/place_response_model.dart';

class SharedService {
  static Future<void> shareInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTimeOpen = prefs.getBool('is_first_time_open') ?? true;

    if (isFirstTimeOpen) {
      await prefs.setBool('is_first_time_open', false);
    }
  }

  static Future<void> setSharedLogOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const storage = FlutterSecureStorage();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('id');
    await storage.delete(key: 'token');
    await prefs.remove('is_home_after_login');
  }

  static Future<void> setSharedLogin(dynamic data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const storage = FlutterSecureStorage();
    const keyName = 'name';
    final valueName = data['user']['name'];
    prefs.setString(keyName, valueName);
    const keyEmail = 'email';
    final valueEmail = data['user']['email'];
    prefs.setString(keyEmail, valueEmail);
    const keyId = 'id';
    final valueId = data['user']['_id'];
    prefs.setString(keyId, valueId);
    await storage.write(key: 'token', value: data['token']);
    setSharedUserToken(true);
    Map<String, dynamic> decodedToken = JwtDecoder.decode(data['token']);
    DateTime expiryTokenDate =
        DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
    print(expiryTokenDate);
  }

  static String name = '';
  static String email = '';
  static String id = '';

  static Future<void> getSharedLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const keyName = 'name';
    name = prefs.getString(keyName) ?? 'Developer';
    const keyEmail = 'email';
    email = prefs.getString(keyEmail) ?? 'Login with your email';
    const keyId = 'id';
    id = prefs.getString(keyId)!;
  }

  static Future<String?> getSecureUserToken() async {
    const storage = FlutterSecureStorage();
    String? userToken = await storage.read(key: 'token');
    return userToken;
  }

  static Future<void> setSharedHomeAfter(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const keyAfter = 'is_home_after_login';
    final valueAfter = value;
    prefs.setBool(keyAfter, valueAfter);
  }

  static Future<bool> getSharedHomeAfter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const keyAfter = 'is_home_after_login';
    return prefs.getBool(keyAfter) ?? false;
  }

  static Future<void> setSharedDistance(double distance) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('distance');
    const key = 'distance';
    final value = distance;
    prefs.setDouble(key, value);
  }

  static double distance = 0;

  static Future<void> getSharedDistance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const key = 'distance';
    distance = prefs.getDouble(key)!;
  }

  static Future<void> setSharedUserToken(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const keyAfter = 'is_user_token';
    final valueToken = value;
    prefs.setBool(keyAfter, valueToken);
  }

  static Future<bool> getSharedUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const keyAfter = 'is_user_token';
    return prefs.getBool(keyAfter) ?? false;
  }

  // static Future<void> setsharedLocation(double lat, double long) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   const keyLat = 'last_known_lat';
  //   final valueLat = lat;
  //   prefs.setDouble(keyLat, valueLat);
  //   const keyLong = 'last_known_long';
  //   final valueLong = long;
  //   prefs.setDouble(keyLong, valueLong);
  // }

  // static double lat = 0;
  // static double long = 0;

  // static Future<void> getsharedLocation() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   const keyLat = 'last_known_lat';
  //   lat =  prefs.getDouble(keyLat)!;
  //   const keyLong = 'last_known_long';
  //   long =  prefs.getDouble(keyLong)!;
  // }
}
