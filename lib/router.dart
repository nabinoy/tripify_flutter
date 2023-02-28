import 'package:flutter/material.dart';
import 'package:tripify/screens/category.dart';
import 'package:tripify/screens/drawer/helpline.dart';
import 'package:tripify/screens/forgot_password.dart';
import 'package:tripify/screens/home.dart';
import 'package:tripify/screens/island.dart';
import 'package:tripify/screens/location_weather.dart';
import 'package:tripify/screens/login.dart';
import 'package:tripify/screens/onboard.dart';
import 'package:tripify/screens/place.dart';
import 'package:tripify/screens/map_webview.dart';
import 'package:tripify/screens/signup.dart';
import 'package:tripify/screens/weather_details.dart';
import 'package:tripify/screens/welcome.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Home.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const Home(),);

    case LoginPage.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const LoginPage(),);

    case SignupPage.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const SignupPage(),);

    case Welcome.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const Welcome(),);

    case Place.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const Place(),);

    case MapWebView.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const MapWebView(),);

    case Island.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const Island(),);

    case Category.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const Category(),);

    case LocationWeather.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const LocationWeather(),);

    case WeatherDetails.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const WeatherDetails(),);

    case ForgotPassword.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const ForgotPassword(),);

    case OnBoardingScreen.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const OnBoardingScreen(),);

    case Helpline.routeName:
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const Helpline(),);
  
    default: 
      return MaterialPageRoute(settings : routeSettings,builder: (_) => const Scaffold(
        body: Center(
          child: Text('Screen does not exist!'),
        ),
      ),
      );
  }
}
