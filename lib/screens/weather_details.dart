import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/weather_model.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/services/geocoding.dart';
import 'package:tripify/widget/day_forcast.dart';
import 'package:tripify/widget/hour_forecast.dart';
import 'package:tripify/widget/main_weather.dart';
import 'package:tripify/widget/weather_detail_more.dart';

class WeatherDetails extends StatefulWidget {
  static const String routeName = '/weatherdetails';
  const WeatherDetails({super.key});

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    weatherLatAPI = getlat().toString();
    weatherLongAPI = getlong().toString();
    stopListeningForLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    final placeList =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    if (placeList[0] != 'Current') {
      weatherLatAPI = placeList[0];
      weatherLongAPI = placeList[1];
    }
    String weatherLocationName = '';

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return WillPopScope(
      onWillPop: () async {
        hourForecasts.clear();
        getPreviousForecastData();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              hourForecasts.clear();
              getPreviousForecastData();
              HapticFeedback.mediumImpact();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
          elevation: 0,
          backgroundColor: bgColor,
          centerTitle: true,
          title: const Text(
            "Weather",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: FutureBuilder(
          future: Future.wait([
            getNameFromCoordinate(
                    double.parse(weatherLatAPI), double.parse(weatherLongAPI))
                .then((value) => {weatherLocationName = value}),
            getWeatherInfo(),
            getForcastInfo(),
            getDayForcastInfo(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return WeatherScreen(weatherLocationName);
            } else {
              return const LoadingScreen();
            }
          },
        ),
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  final String weatherLocationName;
  const WeatherScreen(this.weatherLocationName, {super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void dispose() {
    hourForecasts.clear();
    dayForecasts.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
              child: MainWeather(widget.weatherLocationName),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'Hour forecast',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                HourForecast()
              ],
            ),
            const DayForecast(),
            const WeatherDetail(),
          ],
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
