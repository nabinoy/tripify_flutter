import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static String name = '';
  static String email = '';
  static String id = '';

  static Future<void> shareInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTimeOpen = prefs.getBool('is_first_time_open') ?? true;

    if (isFirstTimeOpen) {
      await prefs.setBool('is_first_time_open', false);
    }
  }

  static Future<void> setNoFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_first_time_open', false);
  }

  static Future<void> setSharedLogOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const storage = FlutterSecureStorage();
    name = '';
  email = '';
  id = '';
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('id');
    await prefs.remove('is_session_expired');
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
  }

  static Future<void> setUserName(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const keyName = 'name';
    final valueName = data;
    prefs.setString(keyName, valueName);
  }

  static Future<void> getSharedLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const keyName = 'name';
    name = prefs.getString(keyName) ?? 'Guest';
    const keyEmail = 'email';
    email = prefs.getString(keyEmail) ?? 'Login with your email';
    const keyId = 'id';
    id = prefs.getString(keyId) ?? '';
  }

  static Future<String?> getSecureUserToken() async {
    const storage = FlutterSecureStorage();
    String? userToken = await storage.read(key: 'token');
    return userToken;
  }

  static Future<void> setSessionExpire(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const keyAfter = 'is_session_expired';
    final valueAfter = value;
    prefs.setBool(keyAfter, valueAfter);
  }

  static Future<bool> getSessionExpire() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const keyAfter = 'is_session_expired';
    return prefs.getBool(keyAfter) ?? false;
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
    distance = prefs.getDouble(key) ?? 0;
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
}
