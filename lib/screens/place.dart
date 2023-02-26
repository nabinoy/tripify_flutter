import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/router.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/services/shared_service.dart';
import 'package:tripify/widget/direction_map.dart';

import '../loader/loader_home_main.dart';

class Place extends StatelessWidget {
  static const String routeName = '/place';
  const Place({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PlaceDetails(),
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
    );
  }
}

class PlaceDetails extends StatefulWidget {
  const PlaceDetails({super.key});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  late StreamSubscription subscription;
  ValueNotifier<double> distance = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      SharedService.getSharedDistance();
      distance.value = SharedService.distance;
    });
    bool flag = false;

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none && flag == false) {
        flag = true;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "No internet",
            style: TextStyle(fontFamily: fontRegular, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 3,
          ),
          duration: Duration(days: 1),
          backgroundColor: Colors.grey,
        ));
      } else if ((result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi ||
              result == ConnectivityResult.bluetooth ||
              result == ConnectivityResult.ethernet ||
              result == ConnectivityResult.vpn) &&
          flag == true) {
        flag = false;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Connected",
            style: TextStyle(fontFamily: fontRegular, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 3,
          ),
          backgroundColor: Colors.green,
        ));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Place name',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: FutureBuilder(
          future: Future.wait([]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: distance,
                        builder: (context, value, child) {
                          return Text(
                              'Distance ${distance.value.toStringAsFixed(2)}km');
                        },
                      ),
                      SizedBox(
                        height: screenWidth * 0.8,
                        width: screenWidth,
                        child: FutureBuilder(
                            future: Future.wait([
                              getCurrentLocation(),
                            ]),
                            builder: (builder, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: const DirectionMap());
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
              );
            } else {
              return const LoaderHomeMain();
            }
          }),
    );
  }
}
