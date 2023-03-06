import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/place_model.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/models/weather_model.dart';
import 'package:tripify/screens/weather_details.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/services/shared_service.dart';
import 'package:tripify/widget/direction_map.dart';
import 'package:tripify/widget/hour_forecast.dart';

late PlaceDetails placeDetails;

class PlaceCategoryTop extends SliverPersistentHeaderDelegate {
  final ValueChanged<int> onChanged;
  final int selectedIndex;

  PlaceCategoryTop({required this.onChanged, required this.selectedIndex});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      height: 45,
      color: Colors.white,
      child: const PlaceCategory(),
    );
  }

  @override
  double get maxExtent => 45;

  @override
  double get minExtent => 45;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class PlaceData {
  final List<String> placeList;
  PlaceData({required this.placeList});
}

class Place extends StatefulWidget {
  static const String routeName = '/place';

  const Place({super.key});

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  @override
  void initState() {
    super.initState();
    // getCurrentLocation();
    // weatherLatAPI = getlat().toString();
    // weatherLongAPI = getlong().toString();
  }

  @override
  void dispose() {
    hourForecasts.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final placeList =
        ModalRoute.of(context)!.settings.arguments as List<PlaceDetails>;
    weatherLatAPI = placeList.first.location.coordinates[1].toString();
    weatherLongAPI = placeList.first.location.coordinates[0].toString();
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      body: FutureBuilder(
          future: Future.wait([
            getForcastInfo(),
            getWeatherInfo(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    expandedHeight: 300,
                    pinned: true,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: FadeInImage.memoryNetwork(
                        fadeInDuration: const Duration(milliseconds: 200),
                        fit: BoxFit.cover,
                        placeholder: kTransparentImage,
                        image: placeList.first.images.first.secureUrl,
                      ),
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              MdiIcons.share,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              MdiIcons.heartOutline,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                    // bottom: PreferredSize(
                    //   preferredSize: const Size.fromHeight(0.0),
                    //   child: Container(
                    //     height: 32.0,
                    //     alignment: Alignment.center,
                    //     decoration: const BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(20.0),
                    //         topRight: Radius.circular(20.0),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              placeList.first.name,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_pin,
                                  size: 18,
                                ),
                                Text(
                                  placeList.first.address.city,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: PlaceCategoryTop(
                        onChanged: ((value) {}), selectedIndex: 0),
                    pinned: true,
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            placeList.first.description,
                            style: const TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Activities',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'scuba diving',
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Timing',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '09:00am to 05:00pm',
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Cost',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'No fees required',
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Direction',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      child: SizedBox(
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
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 5,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Address',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${placeList.first.address.street}\n${placeList.first.address.landmark}\n${placeList.first.address.zip}\n${placeList.first.address.city}\n${placeList.first.address.state}\n${placeList.first.address.country}',
                            style: const TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Weather Forecast',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.pushNamed(
                                    context,
                                    WeatherDetails.routeName,
                                    arguments: [weatherLatAPI, weatherLongAPI],
                                  );
                                },
                                child: const Text(
                                  'View more',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const HourForecast(),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rate this place',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.blue,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width - 200,
                              height: 40,
                              onPressed: () {},
                              color: Colors.lightBlue[800],
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Text(
                                'Write a review',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ratings and reviews',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    '4.5',
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                  RatingBar.builder(
                                    initialRating: 4.5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 14.0,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.blue,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const Text(
                                    '345',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      const Text('5'),
                                      LinearPercentIndicator(
                                        width: 160.0,
                                        lineHeight: 10.0,
                                        percent: 0.9,
                                        barRadius: const Radius.circular(16),
                                        progressColor: Colors.blue,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const Text('4'),
                                      LinearPercentIndicator(
                                        width: 160.0,
                                        lineHeight: 10.0,
                                        percent: 0.1,
                                        barRadius: const Radius.circular(16),
                                        progressColor: Colors.blue,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const Text('3'),
                                      LinearPercentIndicator(
                                        width: 160.0,
                                        lineHeight: 10.0,
                                        percent: 0.2,
                                        barRadius: const Radius.circular(16),
                                        progressColor: Colors.blue,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const Text('2'),
                                      LinearPercentIndicator(
                                        width: 160.0,
                                        lineHeight: 10.0,
                                        percent: 0,
                                        barRadius: const Radius.circular(16),
                                        progressColor: Colors.blue,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const Text('1 '),
                                      LinearPercentIndicator(
                                        width: 160.0,
                                        lineHeight: 10.0,
                                        percent: 0.3,
                                        barRadius: const Radius.circular(16),
                                        progressColor: Colors.blue,
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'External links',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'https://www.example.com',
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class PlaceCategory extends StatefulWidget {
  const PlaceCategory({super.key});

  @override
  State<PlaceCategory> createState() => _PlaceCategoryState();
}

class _PlaceCategoryState extends State<PlaceCategory> {
  ValueNotifier<double> distance = ValueNotifier<double>(0);
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      SharedService.getSharedDistance();
      distance.value = SharedService.distance;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final placeList =
        ModalRoute.of(context)!.settings.arguments as List<PlaceDetails>;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                MdiIcons.mapMarkerDistance,
                size: 30,
              ),
            ),
            Column(
              children: [
                const Text(
                  'Distance',
                  style: TextStyle(fontSize: 12),
                ),
                ValueListenableBuilder(
                  valueListenable: distance,
                  builder: (context, value, child) {
                    return Text(
                      '${distance.value.toStringAsFixed(2)}km',
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                MdiIcons.star,
                size: 30,
              ),
            ),
            Column(
              children: [
                const Text(
                  'Rating',
                  style: TextStyle(fontSize: 12),
                ),
                ValueListenableBuilder(
                  valueListenable: distance,
                  builder: (context, value, child) {
                    return Text(
                      placeList.first.ratings.toString(),
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                MdiIcons.weatherCloudy,
                size: 30,
              ),
            ),
            Column(
              children: [
                const Text(
                  'Weather',
                  style: TextStyle(fontSize: 12),
                ),
                ValueListenableBuilder(
                  valueListenable: distance,
                  builder: (context, value, child) {
                    return Text(
                      '$temperature°c',
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
