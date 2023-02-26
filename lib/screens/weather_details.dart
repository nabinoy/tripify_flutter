import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/animation/FadeAnimation.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/weather_model.dart';
import 'package:tripify/router.dart';
import 'package:tripify/services/current_location.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ignore: deprecated_member_use
        androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
        fontFamily: fontRegular,
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: bgColor,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
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
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: FutureBuilder(
          future: Future.wait([
            getWeatherInfo(),
            getForcastInfo(),
            getDayForcastInfo(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const WeatherScreen();
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
  const WeatherScreen({super.key});

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Container(
            //   height: screenWidth * 0.40,
            //   width: screenWidth / 2 + 16,
            //   padding: const EdgeInsets.all(10),
            //   child: MainWeather(),
            // ),
            Container(
              height: screenHeight / 2 * 0.8,
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
              child: MainWeather(),
            ),
            FadeAnimation(
                1.7,
                SizedBox(
                    height: screenHeight * 0.2, child: const HourForecast())),
            FadeAnimation(
                1.8,
                SizedBox(
                    height: screenHeight * 0.41, child: const DayForecast())),
            FadeAnimation(
                1.9,
                SizedBox(
                    height: screenWidth * 0.85, child: const WeatherDetail())),
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

// class LoadingScreen extends StatelessWidget {
//   const LoadingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Center(
//         child: Shimmer.fromColors(
//           baseColor: const Color.fromARGB(255, 80, 80, 80),
//           highlightColor: const Color.fromARGB(255, 198, 198, 198),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 height: 20,
//                 width: 50,
//                 color: Colors.white,
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 height: 20,
//                 width: 80,
//                 color: Colors.white,
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 height: 20,
//                 width: 100,
//                 color: Colors.white,
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 height: 20,
//                 width: 60,
//                 color: Colors.white,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
