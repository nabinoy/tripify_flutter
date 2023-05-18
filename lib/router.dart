import 'package:flutter/material.dart';
import 'package:tripify/screens/chatbot.dart';
import 'package:tripify/screens/drawer/translator.dart';
import 'package:tripify/screens/drawer/transport_service.dart';
import 'package:tripify/screens/filter_page/place_filter.dart';
import 'package:tripify/screens/filter_page/restaurant_filter.dart';
import 'package:tripify/screens/home_pages/profile/edit_name.dart';
import 'package:tripify/screens/home_services/hotel.dart';
import 'package:tripify/screens/home_services/hotel_details.dart';
import 'package:tripify/screens/home_services/restaurant.dart';
import 'package:tripify/screens/home_services/restaurant_details.dart';
import 'package:tripify/screens/home_services/tour_operator.dart';
import 'package:tripify/screens/itinerary/itinerary_detail.dart';
import 'package:tripify/screens/itinerary/itinerary_page.dart';
import 'package:tripify/screens/otp_form.dart';
import 'package:tripify/screens/category.dart';
import 'package:tripify/screens/drawer/helpline.dart';
import 'package:tripify/screens/forgot_password.dart';
import 'package:tripify/screens/home.dart';
import 'package:tripify/screens/island.dart';
import 'package:tripify/screens/location_weather.dart';
import 'package:tripify/screens/login.dart';
import 'package:tripify/screens/onboard.dart';
import 'package:tripify/screens/place.dart';
import 'package:tripify/screens/home_services/map_webview.dart';
import 'package:tripify/screens/review_all.dart';
import 'package:tripify/screens/search/search_hotel.dart';
import 'package:tripify/screens/search/search_place.dart';
import 'package:tripify/screens/search/search_restaurant.dart';
import 'package:tripify/screens/search/search_tour_operator.dart';
import 'package:tripify/screens/signup.dart';
import 'package:tripify/screens/util.dart/pdf_viewer.dart';
import 'package:tripify/screens/weather_details.dart';
import 'package:tripify/screens/welcome.dart';

import 'screens/home_pages/profile/edit_password.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Home.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Home(),
      );

    case LoginPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginPage(),
      );

    case SignupPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignupPage(),
      );

    case Welcome.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Welcome(),
      );

    case Place.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Place(),
      );

    case MapWebView.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MapWebView(),
      );

    case ToiletMapWebView.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ToiletMapWebView(),
      );

    case Island.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Island(),
      );

    case Category.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Category(),
      );

    case LocationWeather.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LocationWeather(),
      );

    case WeatherDetails.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const WeatherDetails(),
      );

    case ItineraryPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ItineraryPage(),
      );

    case ForgotPassword.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ForgotPassword(),
      );

    case OnBoardingScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OnBoardingScreen(),
      );

    case Helpline.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Helpline(),
      );

    case ReviewAll.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ReviewAll(),
      );

    case OtpForm.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OtpForm(),
      );

    case ChatBot.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ChatBot(),
      );

    case HotelScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HotelScreen(),
      );

    case TourOperatorSceen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const TourOperatorSceen(),
      );

    case SearchPlace.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SearchPlace(),
      );

    case SearchHotel.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SearchHotel(),
      );

    case SearchTourOperator.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SearchTourOperator(),
      );

    case HotelDetailsPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HotelDetailsPage(),
      );

    case EditName.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const EditName(),
      );

    case EditPassword.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const EditPassword(),
      );

    case FilterPlace.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const FilterPlace(),
      );

    case FilterRestaurant.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const FilterRestaurant(),
      );

    case TranslatorWebView.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const TranslatorWebView(),
      );

    case TransportService.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const TransportService(),
      );

    case PdfViewPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PdfViewPage(),
      );

    case HospitalMapWebView.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HospitalMapWebView(),
      );

    case ItineraryDetails.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ItineraryDetails(),
      );

    case RestaurantScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RestaurantScreen(),
      );

    case RestaurantDetailsPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RestaurantDetailsPage(),
      );

    case SearchRestaurant.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SearchRestaurant(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
