import 'dart:convert';
import 'package:tripify/models/forgot_password_request_model.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/hotel_response_model.dart';
import 'package:tripify/models/itinerary_request_model.dart';
import 'package:tripify/models/login_request_model.dart';
import 'package:tripify/models/nearby_request_model.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/models/otp_request_model.dart';
import 'package:tripify/models/restaurant_response_model.dart';
import 'package:tripify/models/review_rating_model.dart';
import 'package:tripify/models/signup_request_model.dart';
import 'package:http/http.dart' as http;
import 'package:tripify/constants/config.dart';
import 'package:tripify/models/tour_operator_response_model.dart';
import 'package:tripify/models/update_user_model.dart';
import 'package:tripify/models/user_hotel_review_model.dart';
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
    return data;
  }

  static Future<dynamic> updateName(
    UpdateNameModel model,
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
      Config.updateNameAPI,
    );

    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception('Failed to load details');
    }
  }

  static Future<dynamic> updatePassword(
    UpdatePasswordModel model,
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
      Config.updatePasswordAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      SharedService.setSharedLogin(data);
    }
    return data;
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

  static Future<String> userHotelReview(UserHotelReviewModel model) async {
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
      Config.reviewHotelAPI,
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

  static Future<List<Places2>> placeBySearch(String search) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {'search': search};
    var url = Uri.https(Config.apiURL, Config.placeAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['places'];
      List<Places2> pd = [];

      for (var i = 0; i < data.length; i++) {
        Places2 p2 = Places2.fromJson(data[i]);
        pd.add(p2);
      }
      return pd;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<Hotels>> hotelBySearch(String search) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {'search': search};
    var url = Uri.https(Config.apiURL, Config.hotelAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['hotels'];
      List<Hotels> h = [];

      for (var i = 0; i < data.length; i++) {
        Hotels h2 = Hotels.fromJson(data[i]);
        h.add(h2);
      }
      return h;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<Restaurants>> restaurantBySearch(String search) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {'search': search};
    var url =
        Uri.https(Config.apiURL, Config.restaurantAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['restaurants'];
      List<Restaurants> r = [];

      for (var i = 0; i < data.length; i++) {
        Restaurants r2 = Restaurants.fromJson(data[i]);
        r.add(r2);
      }
      return r;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<TourOperators>> tourOperatorBySearch(String search) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {'search': search};
    var url =
        Uri.https(Config.apiURL, Config.tourOperatorAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['tourOperators'];
      List<TourOperators> t = [];

      for (var i = 0; i < data.length; i++) {
        TourOperators t2 = TourOperators.fromJson(data[i]);
        t.add(t2);
      }
      return t;
    } else {
      throw Exception('Failed to load tour operator details');
    }
  }

  static Future<List<Places2>> placeAll() async {
    Map<String, String> requestHeaders = {
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
      data = data['places'];
      List<Places2> pd = [];

      for (var i = 0; i < data.length; i++) {
        Places2 p2 = Places2.fromJson(data[i]);
        pd.add(p2);
      }
      return pd;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<List<Places2>>> itineraryAll(ItineraryModel model,
      List<String> categories, List<String> island) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> queryParameters = {};

    if (!island.contains('All')) {
      queryParameters['island'] = island;
    }
    if (categories.isNotEmpty) {
      String categoriesString = categories.join(",");
      queryParameters['categories'] = categoriesString;
    }

    Uri url;
    if (queryParameters.isEmpty) {
      url = Uri.https(
        Config.apiURL,
        Config.itineraryAPI,
      );
    } else {
      url = Uri.https(Config.apiURL, Config.itineraryAPI, queryParameters);
    }

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['places'];
      List<List<Places2>> pd = [];

      for (var j = 0; j < data.length; j++) {
        pd.add([]);
        for (var i = 0; i < data[j].length; i++) {
          Places2 p2 = Places2.fromJson(data[j][i]);
          pd[j].add(p2);
        }
      }
      return pd;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<Places2>> nearbyPlace(NearbyModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.apiURL, Config.placeNearbyAPI);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['places'];
      List<Places2> pd = [];

      for (var i = 0; i < data.length; i++) {
        Places2 p2 = Places2.fromJson(data[i]);
        pd.add(p2);
      }
      return pd;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<Restaurants>> nearbyRestaurants(NearbyModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.apiURL, Config.restaurantNearbyAPI);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['restaurants'];
      List<Restaurants> r = [];

      for (var i = 0; i < data.length; i++) {
        Restaurants r2 = Restaurants.fromJson(data[i]);
        r.add(r2);
      }
      return r;
    } else {
      throw Exception('Failed to load Restaurant details');
    }
  }

  static Future<List<Hotels>> nearbyHotel(NearbyModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.apiURL, Config.hotelNearbyAPI);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['hotels'];
      List<Hotels> h = [];

      for (var i = 0; i < data.length; i++) {
        Hotels h2 = Hotels.fromJson(data[i]);
        h.add(h2);
      }
      return h;
    } else {
      throw Exception('Failed to load hotel by id details');
    }
  }

  static Future<List<Hotels>> hotelByIslandId(String id) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {
      'island': id,
    };
    var url = Uri.https(Config.apiURL, Config.hotelAllAPI, queryParameters);
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['hotels'];
      List<Hotels> h = [];

      for (var i = 0; i < data.length; i++) {
        Hotels h2 = Hotels.fromJson(data[i]);
        h.add(h2);
      }
      return h;
    } else {
      throw Exception('Failed to load hotel by id details');
    }
  }

  static Future<List<Restaurants>> restaurantByIslandId(String id) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {
      'island': id,
    };
    var url =
        Uri.https(Config.apiURL, Config.restaurantAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['restaurants'];
      List<Restaurants> r = [];

      for (var i = 0; i < data.length; i++) {
        Restaurants r2 = Restaurants.fromJson(data[i]);
        r.add(r2);
      }
      return r;
    } else {
      throw Exception('Failed to load Restaurant details');
    }
  }

  static Future<List<Restaurants>> restaurantByIslandIdFoodType(
      String id, String type) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    late dynamic queryParameters;
    dynamic url;

    if (type.contains("All") && id.contains('All')) {
      url = Uri.https(Config.apiURL, Config.restaurantAllAPI);
    } else {
      if (id.contains('All')) {
        queryParameters = {'isVeg': (type == 'Veg') ? 'true' : 'false'};
      } else {
        if (type.contains("All")) {
          queryParameters = {
            'island': id,
          };
        } else {
          queryParameters = {
            'island': id,
            'isVeg': (type == 'Veg') ? 'true' : 'false'
          };
        }
      }
      url = Uri.https(Config.apiURL, Config.restaurantAllAPI, queryParameters);
    }

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['restaurants'];
      List<Restaurants> r = [];

      for (var i = 0; i < data.length; i++) {
        Restaurants r2 = Restaurants.fromJson(data[i]);
        r.add(r2);
      }
      return r;
    } else {
      throw Exception('Failed to load Restaurant details');
    }
  }

  static Future<List<Hotels>> hotelAll() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.hotelAllAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['hotels'];
      List<Hotels> h = [];

      for (var i = 0; i < data.length; i++) {
        Hotels h2 = Hotels.fromJson(data[i]);
        h.add(h2);
      }
      return h;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<Restaurants>> restaurantAll() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.restaurantAllAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['restaurants'];
      List<Restaurants> r = [];

      for (var i = 0; i < data.length; i++) {
        Restaurants r2 = Restaurants.fromJson(data[i]);
        r.add(r2);
      }
      return r;
    } else {
      throw Exception('Failed to load Restaurant details');
    }
  }

  static Future<List<TourOperators>> tourOperatorAll() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var url = Uri.https(
      Config.apiURL,
      Config.tourOperatorAllAPI,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['tourOperators'];
      List<TourOperators> t = [];

      for (var i = 0; i < data.length; i++) {
        TourOperators t2 = TourOperators.fromJson(data[i]);
        t.add(t2);
      }
      return t;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<Places2>> placeRecommendationByPlace(
      String placeId) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var url = Uri.https(
        Config.apiURL, '${Config.placeRecommendationByPlaceAPI}/$placeId');

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['places'];
      List<Places2> pd = [];

      for (var i = 0; i < data.length; i++) {
        Places2 p2 = Places2.fromJson(data[i]);
        pd.add(p2);
      }
      return pd;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<String>> checkUserWishlist() async {
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

    var url = Uri.https(Config.apiURL, Config.userDashboardAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['user']['wishlist'];
      return data.cast<String>();
    } else {
      throw Exception('Failed to load wishlist details');
    }
  }

  static Future<List<Places2>> userWishlist() async {
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

    var url = Uri.https(Config.apiURL, Config.userDashboardAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['user'];
      List<Places2> pd = [];

      for (var i = 0; i < data['wishlist'].length; i++) {
        Map<String, String> requestHeaders = {
          'Accept': 'application/json',
        };

        var url2 = Uri.https(
            Config.apiURL, '${Config.placeAPI}/${data['wishlist'][i]}');
        var response = await client.get(
          url2,
          headers: requestHeaders,
        );

        if (response.statusCode == 200) {
          var data2 = json.decode(response.body);
          data2 = data2['place'];
          Places2 p2 = Places2.fromJson(data2);

          pd.add(p2);
        } else {
          return pd;
        }
      }
      return pd;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<Places2>> placeRecommendationByUser() async {
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

    var url = Uri.https(Config.apiURL, Config.placeRecommendationByUserAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['recomendedPlaces'];
      List<Places2> pd = [];

      for (var i = 0; i < data.length; i++) {
        Places2 p2 = Places2.fromJson(data[i]);
        pd.add(p2);
      }
      return pd;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<Places2>> placeByCategoryIsland(
      String categoryId, String islandID) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {'category': categoryId, 'island': islandID};
    var url = Uri.https(Config.apiURL, Config.placeAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['places'];
      List<Places2> pd = [];

      for (var i = 0; i < data.length; i++) {
        Places2 p2 = Places2.fromJson(data[i]);
        pd.add(p2);
      }
      return pd;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<int> islandPlaceCount(
      String categoryId, String islandID) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {'category': categoryId, 'island': islandID};
    var url = Uri.https(Config.apiURL, Config.placeAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['filteredPlaceNumber'];
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<int> hotelCount() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var url = Uri.https(Config.apiURL, Config.hotelAllAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['filteredNumber'];
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<int> tourOpCount() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var url = Uri.https(Config.apiURL, Config.tourOperatorAllAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['filteredNumber'];
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<int> restaurantCount() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var url = Uri.https(Config.apiURL, Config.restaurantAllAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['filteredNumber'];
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<int> islandHotelCount(String sId) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {'island': sId};
    var url = Uri.https(Config.apiURL, Config.hotelAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['filteredNumber'];
    } else {
      throw Exception('Failed to load hotel details');
    }
  }

  static Future<int> islandRestaurantCount(String sId) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {'island': sId};
    var url =
        Uri.https(Config.apiURL, Config.restaurantAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['filteredNumber'];
    } else {
      throw Exception('Failed to load hotel details');
    }
  }

  static Future<int> islandRestaurantCountFoodType(
      String sId, String type) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    late dynamic queryParameters;
    dynamic url;

    if (type.contains("All") && sId.contains('All')) {
      url = Uri.https(Config.apiURL, Config.restaurantAllAPI);
    } else {
      if (sId.contains('All')) {
        queryParameters = {'isVeg': (type == 'Veg') ? 'true' : 'false'};
      } else {
        if (type.contains("All")) {
          queryParameters = {
            'island': sId,
          };
        } else {
          queryParameters = {
            'island': sId,
            'isVeg': (type == 'Veg') ? 'true' : 'false'
          };
        }
      }

      url = Uri.https(Config.apiURL, Config.restaurantAllAPI, queryParameters);
    }
    //final queryParameters = {'island': sId,'isVeg':isVeg};
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['filteredNumber'];
    } else {
      throw Exception('Failed to load hotel details');
    }
  }

  static Future<int> placeCount() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    //final queryParameters = {'category': categoryId, 'island': islandID};
    var url = Uri.https(Config.apiURL, Config.placeAllAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['filteredPlaceNumber'];
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<String> addToWishlist(String id) async {
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

    final queryParameters = {
      'id': id,
    };
    var url =
        Uri.https(Config.apiURL, Config.addToWishlistAPI, queryParameters);

    var response = await client.put(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['message'];
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<String> deleteFromWishlist(String id) async {
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

    final queryParameters = {
      'id': id,
    };
    var url =
        Uri.https(Config.apiURL, Config.deleteFromWishlistAPI, queryParameters);

    var response = await client.delete(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['message'];
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<Places2>> singlePlacePagination(String page) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {
      'page': page,
    };
    var url = Uri.https(Config.apiURL, Config.placeAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['places'];
      List<Places2> pd = [];

      for (var i = 0; i < data.length; i++) {
        Places2 p2 = Places2.fromJson(data[i]);
        pd.add(p2);
      }
      return pd;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<Places2>> placePagination(
      String categoryId, String islandID, String page) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {
      'category': categoryId,
      'page': page,
      'island': islandID
    };
    var url = Uri.https(Config.apiURL, Config.placeAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['places'];
      List<Places2> pd = [];

      for (var i = 0; i < data.length; i++) {
        Places2 p2 = Places2.fromJson(data[i]);
        pd.add(p2);
      }
      return pd;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<Hotels>> allHotelPagination(String page) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {
      'page': page,
    };
    var url = Uri.https(Config.apiURL, Config.hotelAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['hotels'];
      List<Hotels> hd = [];

      for (var i = 0; i < data.length; i++) {
        Hotels h2 = Hotels.fromJson(data[i]);
        hd.add(h2);
      }
      return hd;
    } else {
      throw Exception('Failed to hotel details');
    }
  }

  static Future<List<Restaurants>> allRestaurantPagination(String page) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {
      'page': page,
    };
    var url =
        Uri.https(Config.apiURL, Config.restaurantAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['restaurants'];
      List<Restaurants> rd = [];

      for (var i = 0; i < data.length; i++) {
        Restaurants r2 = Restaurants.fromJson(data[i]);
        rd.add(r2);
      }
      return rd;
    } else {
      throw Exception('Failed to hotel details');
    }
  }

  static Future<List<TourOperators>> allTourOpPagination(String page) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {
      'page': page,
    };
    var url =
        Uri.https(Config.apiURL, Config.tourOperatorAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['tourOperators'];
      List<TourOperators> to = [];

      for (var i = 0; i < data.length; i++) {
        TourOperators r2 = TourOperators.fromJson(data[i]);
        to.add(r2);
      }
      return to;
    } else {
      throw Exception('Failed to hotel details');
    }
  }

  static Future<List<Hotels>> hotelPagination(
      String islandID, String page) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {'page': page, 'island': islandID};
    var url = Uri.https(Config.apiURL, Config.hotelAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['hotels'];
      List<Hotels> hd = [];

      for (var i = 0; i < data.length; i++) {
        Hotels h2 = Hotels.fromJson(data[i]);
        hd.add(h2);
      }
      return hd;
    } else {
      throw Exception('Failed to hotel details');
    }
  }

  static Future<List<Restaurants>> restaurantPagination(
      String islandID, String page) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {'page': page, 'island': islandID};
    var url =
        Uri.https(Config.apiURL, Config.restaurantAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['restaurants'];
      List<Restaurants> rd = [];

      for (var i = 0; i < data.length; i++) {
        Restaurants r2 = Restaurants.fromJson(data[i]);
        rd.add(r2);
      }
      return rd;
    } else {
      throw Exception('Failed to restaurant details');
    }
  }

  static Future<List<Restaurants>> restaurantPaginationFoodType(
      String islandID, String type, String page) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    late dynamic queryParameters;
    dynamic url;

    if (type.contains("All") && islandID.contains('All')) {
      queryParameters = {'page': page};
      url = Uri.https(Config.apiURL, Config.restaurantAllAPI, queryParameters);
    } else {
      if (type.contains("All")) {
        queryParameters = {'island': islandID, 'page': page};
      } else {
        queryParameters = {
          'island': islandID,
          'isVeg': (type == 'Veg') ? 'true' : 'false',
          'page': page
        };
      }
      url = Uri.https(Config.apiURL, Config.restaurantAllAPI, queryParameters);
    }

    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data['restaurants'];
      List<Restaurants> rd = [];

      for (var i = 0; i < data.length; i++) {
        Restaurants r2 = Restaurants.fromJson(data[i]);
        rd.add(r2);
      }
      return rd;
    } else {
      throw Exception('Failed to restaurant details');
    }
  }

  static Future<int> placeCountFilter(List<String> categories, String islandID,
      String page, double start, double end) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    Map<String, dynamic> queryParameters = {
      'page': page,
      'ratings[gte]': start.toString(),
      'ratings[lte]': end.toString()
    };

    if (!islandID.contains('All')) {
      queryParameters['island'] = islandID;
    }
    if (categories.isNotEmpty) {
      String categoriesString = categories.join(",");
      queryParameters['categories'] = categoriesString;
    }

    queryParameters['categories'].toString();

    var url = Uri.https(Config.apiURL, Config.placeAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['filteredPlaceNumber'];
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<Places2>> placeFilter(List<String> categories,
      String islandID, String page, double start, double end) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    Map<String, dynamic> queryParameters = {
      'page': page,
      'ratings[gte]': start.toString(),
      'ratings[lte]': end.toString()
    };

    if (!islandID.contains('All')) {
      queryParameters['island'] = islandID;
    }
    if (categories.isNotEmpty) {
      String categoriesString = categories.join(",");
      queryParameters['categories'] = categoriesString;
    }

    queryParameters['categories'].toString();

    var url = Uri.https(Config.apiURL, Config.placeAllAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      data = data['places'];
      List<Places2> pd = [];

      for (var i = 0; i < data.length; i++) {
        Places2 p2 = Places2.fromJson(data[i]);
        pd.add(p2);
      }
      return pd;
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<CategoryAll>> categoryAll() async {
    Map<String, String> requestHeaders = {
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
    Map<String, String> requestHeaders = {
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

  static Future<String> askChatBot(String question) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    final queryParameters = {'question': question};
    var url = Uri.https(Config.apiURL, Config.chatBotAPI, queryParameters);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['answer'];
    } else {
      throw Exception('Failed to load person details');
    }
  }

  static Future<List<IslandAll>> islandAll() async {
    Map<String, String> requestHeaders = {
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
    Map<String, String> requestHeaders = {
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

  static Future<ReviewRatings> reviewHotelRatingAll(String id) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    final queryParameters = {'id': id};
    var url = Uri.https(
      Config.apiURL,
      Config.ratingHotelAllAPI,
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
      throw Exception('Failed to load review details');
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

  static Future<String> deleteUserHotelReview(String id) async {
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
      Config.reviewHotelAPI,
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

  static Future<ReviewUser> reviewHotelRatingUser(String id) async {
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
      Config.userHotelReviewAPI,
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
