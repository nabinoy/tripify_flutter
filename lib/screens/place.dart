import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/models/review_rating_model.dart';
import 'package:tripify/models/weather_model.dart';
import 'package:tripify/screens/review_all.dart';
import 'package:tripify/screens/weather_details.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/services/shared_service.dart';
import 'package:tripify/widget/direction_map.dart';
import 'package:tripify/widget/hour_forecast.dart';
import 'dart:math' as math;

late PlaceDetails placeDetails;

class PlaceCategoryTop extends SliverPersistentHeaderDelegate {
  double ratingsAverage;
  PlaceCategoryTop(this.ratingsAverage);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      height: 45,
      color: Colors.white,
      child: PlaceCategory(ratingsAverage),
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
  void dispose() {
    hourForecasts.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Places2> placeList =
        ModalRoute.of(context)!.settings.arguments as List<Places2>;
    weatherLatAPI = placeList.first.location.coordinates[1].toString();
    weatherLongAPI = placeList.first.location.coordinates[0].toString();
    double screenWidth = MediaQuery.of(context).size.width;

    late ReviewUser ru;
    late ReviewRatings r;
    final controller = CarouselController();

    return Scaffold(
      backgroundColor: bgColor,
      body: FutureBuilder(
          future: Future.wait([
            APIService.reviewRatingAll(placeList.first.sId)
                .then((value) => {r = value}),
            APIService.reviewRatingUser(placeList.first.sId)
                .then((value) => {ru = value}),
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
                        background: CarouselSlider.builder(
                            carouselController: controller,
                            itemCount: placeList.first.images.length,
                            itemBuilder: (context, index, realIndex) {
                              final urlImage =
                                  placeList.first.images[index].secureUrl;
                              return buildImage(context, urlImage, index);
                            },
                            options: CarouselOptions(
                              height: 400,
                              viewportFraction: 1,
                              autoPlay: true,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  const Duration(seconds: 1),
                              autoPlayCurve: Curves.fastOutSlowIn,
                            ))),
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
                    delegate: PlaceCategoryTop(r.ratingsAverage),
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
                            textAlign: TextAlign.justify,
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
                        children: [
                          const Text(
                            'Timing',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Table(
                            border: TableBorder.all(),
                            columnWidths: const {
                              0: FractionColumnWidth(0.3),
                              1: FractionColumnWidth(0.3),
                              2: FractionColumnWidth(0.4),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue[200],
                                ),
                                children: const [
                                  Center(child: Text('Day')),
                                  Center(child: Text('Open Time')),
                                  Center(child: Text('Close Time')),
                                ],
                              ),
                              ...List.generate(
                                placeList.first.timings.length,
                                (rowIndex) => TableRow(
                                  children: [
                                    Text(
                                      placeList.first.timings[rowIndex].day,
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      placeList
                                          .first.timings[rowIndex].openTime,
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      placeList
                                          .first.timings[rowIndex].closeTime,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                        children: [
                          const Text(
                            'Dos and Don\'ts',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dos:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...placeList.first.doS.map((d) => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            MdiIcons.checkCircleOutline,
                                            color: Colors.green,
                                            size: 18,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Expanded(
                                            child: Text(
                                              d,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Don\'ts:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...placeList.first.dontS.map((d) => Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            MdiIcons.closeCircleOutline,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Expanded(
                                            child: Text(
                                              d,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
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
                                initialRating: ru.rating.toDouble(),
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
                          FutureBuilder(
                            future:
                                APIService.reviewRatingAll(placeList.first.sId)
                                    .then((value) => {r = value}),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (r.numberOfReviews == 0) {
                                  return Container(
                                    padding: const EdgeInsets.only(top: 30),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          MdiIcons.emoticonSadOutline,
                                          size: 58,
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No data available',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Theme.of(context).disabledColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                r.ratingsAverage
                                                    .toStringAsFixed(1),
                                                style: const TextStyle(
                                                  fontSize: 50,
                                                ),
                                              ),
                                              RatingBar.builder(
                                                initialRating:
                                                    r.ratingsAverage.toDouble(),
                                                ignoreGestures: true,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 14.0,
                                                itemPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.blue,
                                                ),
                                                onRatingUpdate: (rating) {},
                                              ),
                                              Text(
                                                r.numberOfReviews.toString(),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  const Text('5'),
                                                  LinearPercentIndicator(
                                                    backgroundColor: Colors
                                                        .grey[300] as Color,
                                                    animation: true,
                                                    animationDuration: 3000,
                                                    width: 160.0,
                                                    lineHeight: 10.0,
                                                    percent: (r.numberOfReviews ==
                                                            0)
                                                        ? 0
                                                        : (r.fiveCount /
                                                            r.numberOfReviews),
                                                    barRadius:
                                                        const Radius.circular(
                                                            16),
                                                    progressColor: Colors.blue,
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  const Text('4'),
                                                  LinearPercentIndicator(
                                                    backgroundColor: Colors
                                                        .grey[300] as Color,
                                                    animation: true,
                                                    animationDuration: 3000,
                                                    width: 160.0,
                                                    lineHeight: 10.0,
                                                    percent: (r.numberOfReviews ==
                                                            0)
                                                        ? 0
                                                        : (r.fourCount /
                                                            r.numberOfReviews),
                                                    barRadius:
                                                        const Radius.circular(
                                                            16),
                                                    progressColor: Colors.blue,
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  const Text('3'),
                                                  LinearPercentIndicator(
                                                    backgroundColor: Colors
                                                        .grey[300] as Color,
                                                    animation: true,
                                                    animationDuration: 3000,
                                                    width: 160.0,
                                                    lineHeight: 10.0,
                                                    percent: (r.numberOfReviews ==
                                                            0)
                                                        ? 0
                                                        : (r.threeCount /
                                                            r.numberOfReviews),
                                                    barRadius:
                                                        const Radius.circular(
                                                            16),
                                                    progressColor: Colors.blue,
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  const Text('2'),
                                                  LinearPercentIndicator(
                                                    backgroundColor: Colors
                                                        .grey[300] as Color,
                                                    animation: true,
                                                    animationDuration: 3000,
                                                    width: 160.0,
                                                    lineHeight: 10.0,
                                                    percent: (r.numberOfReviews ==
                                                            0)
                                                        ? 0
                                                        : (r.twoCount /
                                                            r.numberOfReviews),
                                                    barRadius:
                                                        const Radius.circular(
                                                            16),
                                                    progressColor: Colors.blue,
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  const Text('1 '),
                                                  LinearPercentIndicator(
                                                    backgroundColor: Colors
                                                        .grey[300] as Color,
                                                    animation: true,
                                                    animationDuration: 3000,
                                                    width: 160.0,
                                                    lineHeight: 10.0,
                                                    percent: (r.numberOfReviews ==
                                                            0)
                                                        ? 0
                                                        : (r.oneCount /
                                                            r.numberOfReviews),
                                                    barRadius:
                                                        const Radius.circular(
                                                            16),
                                                    progressColor: Colors.blue,
                                                  )
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 3,
                                        itemBuilder: (context, index) {
                                          final review = r.reviews[index];
                                          return ReviewWidget(review: review);
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, ReviewAll.routeName,
                                              arguments: r);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'View more',
                                            style: TextStyle(
                                                color: Colors.lightBlue[700]
                                                    as Color),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
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
  // ignore: prefer_typing_uninitialized_variables
  final ratingsAverage;
  const PlaceCategory(this.ratingsAverage, {super.key});

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
                child: const Icon(
                  Icons.location_pin,
                  size: 30,
                  color: Color.fromARGB(255, 195, 19, 16),
                ),
              ),
              Column(
                children: [
                  Text(
                    'Distance',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[700] as Color),
                  ),
                  ValueListenableBuilder(
                    valueListenable: distance,
                    builder: (context, value, child) {
                      return (distance.value == 0.0)
                          ? const Text('-')
                          : Text(
                              '${distance.value.toStringAsFixed(2)}km',
                              style: const TextStyle(fontSize: 14),
                            );
                    },
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
                child: const Icon(
                  MdiIcons.star,
                  size: 30,
                  color: Color.fromARGB(255, 255, 231, 13),
                ),
              ),
              Column(
                children: [
                  Text(
                    'Rating',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[700] as Color),
                  ),
                  ValueListenableBuilder(
                    valueListenable: distance,
                    builder: (context, value, child) {
                      return Text(
                        widget.ratingsAverage.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 14),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
                child: const Icon(
                  Icons.sunny,
                  size: 30,
                  color: Colors.orange,
                ),
              ),
              Column(
                children: [
                  Text(
                    'Weather',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[700] as Color),
                  ),
                  ValueListenableBuilder(
                    valueListenable: distance,
                    builder: (context, value, child) {
                      return Text(
                        '$temperature°c',
                        style: const TextStyle(fontSize: 14),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  final Reviews2 review;

  const ReviewWidget({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(review.date);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.grey[300] as Color,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor:
                        Color((math.Random().nextDouble() * 0x333333).toInt())
                            .withOpacity(1.0),
                    child: Text(
                      review.name[0],
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    review.name,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  RatingBar.builder(
                    initialRating: review.rating.toDouble(),
                    ignoreGestures: true,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 16,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.blue,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                review.comment,
                style: TextStyle(color: Colors.grey[700] as Color),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}

Widget buildImage(BuildContext context, String urlImage, int index) {
  return ClipRRect(
    child: CachedNetworkImage(
      height: 600,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.bottomCenter,
      imageUrl: urlImage,
      placeholder: (context, url) => Image.memory(
        kTransparentImage,
        fit: BoxFit.cover,
      ),
      fadeInDuration: const Duration(milliseconds: 200),
      fit: BoxFit.cover,
    ),
  );
}
