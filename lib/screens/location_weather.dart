import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/weather_model.dart';
import 'package:tripify/router.dart';
import 'package:tripify/screens/weather_details.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/widget/map.dart';

class LocationWeather extends StatefulWidget {
  static const String routeName = '/locationweather';
  const LocationWeather({super.key});

  @override
  State<LocationWeather> createState() => _LocationWeatherState();
}

class _LocationWeatherState extends State<LocationWeather> {
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    weatherLatAPI = getlat().toString();
    weatherLongAPI = getlong().toString();
    getWeatherInfo();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
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
            title: FutureBuilder(
                future: getWeatherInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(
                      '\u{1F4CD} $placeName',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  }
                }),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pushNamed(
                        context,
                        WeatherDetails.routeName,
                      );
                    },
                    child: SizedBox(
                      height: screenWidth * 0.40,
                      width: screenWidth,
                      child: FutureBuilder(
                        future: getWeatherInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Container(
                              margin: const EdgeInsets.only(top: 6),
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0,
                                    offset: Offset(3.0, 3.0),
                                    spreadRadius: 2.0,
                                  ),
                                ],
                                color: const Color.fromARGB(255, 229, 229, 229),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: screenWidth * 0.50,
                                    width: screenWidth / 2 + 16,
                                    child: Column(children: [
                                      SizedBox(
                                        height: screenWidth * 0.20,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: screenWidth / 2 - 120,
                                              child: Center(
                                                child: Image.network(
                                                    'http://openweathermap.org/img/wn/$ico@2x.png'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: screenWidth / 2 - 100,
                                              child: Text(
                                                '$temperature°c',
                                                style: const TextStyle(
                                                  fontSize: 42,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        alignment: Alignment.centerLeft,
                                        height: screenWidth * 0.07,
                                        child: Text(
                                          desc1,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        alignment: Alignment.centerLeft,
                                        height: screenWidth * 0.1,
                                        child: Text(
                                          'Sunrise: $sunrise',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  SizedBox(
                                    height: screenWidth * 0.50,
                                    width: screenWidth / 2 - 48,
                                    child: Column(children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 6, 8.0, 0),
                                        alignment: Alignment.centerRight,
                                        height: screenWidth * 0.07,
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          size: 26,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 10.0),
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        alignment: Alignment.centerLeft,
                                        height: screenWidth * 0.1,
                                        child: Text(
                                          'Wind: ${wind}km/h',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        alignment: Alignment.centerLeft,
                                        height: screenWidth * 0.07,
                                        child: Text(
                                          'Humidity: $humidity%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        alignment: Alignment.centerLeft,
                                        height: screenWidth * 0.1,
                                        child: Text(
                                          'Sunset: $sunset',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                    child: const Text(
                      'Your location',
                      style: TextStyle(),
                    ),
                  ),
                  SizedBox(
                    height: screenWidth * 1.3,
                    width: screenWidth,
                    child: FutureBuilder(
                        future: getCurrentLocation(),
                        builder: (builder, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: const MapData());
                          } else {
                            return Container(
                              color: Colors.white,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
