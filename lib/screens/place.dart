import 'dart:async';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:georange/georange.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/loader/loader_review_all.dart';
import 'package:tripify/loader/loader_review_user.dart';
import 'package:tripify/models/hotel_response_model.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/models/restaurant_response_model.dart';
import 'package:tripify/models/review_rating_model.dart';
import 'package:tripify/models/user_review_model.dart';
import 'package:tripify/models/weather_model.dart';
import 'package:tripify/screens/home_services/hotel_details.dart';
import 'package:tripify/screens/home_services/restaurant_details.dart';
import 'package:tripify/screens/review_all.dart';
import 'package:tripify/screens/weather_details.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/services/shared_service.dart';
import 'package:tripify/widget/direction_map.dart';
import 'package:tripify/widget/hour_forecast.dart';
import 'dart:math' as math;

import 'package:tripify/widget/place_recommendation_byplace.dart';
import 'package:tripify/widget/widget_to_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/nearby_request_model.dart';

late PlaceDetails placeDetails;
late List<Places2> currentPlace;
ValueNotifier<String> temperatureNotifier = ValueNotifier<String>('');
final controller = CarouselController();

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

class Place extends StatefulWidget {
  static const String routeName = '/place';

  const Place({super.key});

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  List<Hotels> nearbyHd = [];
  List<Restaurants> nearbyRd = [];
  ValueNotifier<int> pictureIndex = ValueNotifier<int>(0);
  int tempIndex = 0;
  ReviewUser ru = ReviewUser.fromJson({
    "user": "",
    "name": "",
    "rating": 0,
    "comment": "",
    "sentiment": "",
    "_id": "",
    "date": ""
  });

  @override
  void dispose() {
    temperatureNotifier.value = '';
    hourForecasts.clear();
    polylineCoordinates.clear();
    super.dispose();
  }

  void _launchWeb(String website) async {
    await launchUrl(Uri.parse(website), mode: LaunchMode.externalApplication);
  }

  Widget buildIndicator(int tempIndex, int length) => AnimatedSmoothIndicator(
        onDotClicked: animateToSlide,
        effect: const ScaleEffect(
            scale: 1.6,
            dotHeight: 6,
            dotWidth: 6,
            dotColor: Color.fromARGB(255, 191, 191, 191),
            activeDotColor: Colors.white),
        activeIndex: tempIndex,
        count: length,
      );

  void animateToSlide(int index) => controller.animateToPage(index);

  @override
  Widget build(BuildContext context) {
    GeoRange georange = GeoRange();
    ValueNotifier<bool> isListed = ValueNotifier<bool>(false);

    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    List<Places2> placeList = arguments[0] as List<Places2>;
    isListed.value = arguments[1];
    currentPlace = placeList;
    weatherLatAPI = placeList.first.location.coordinates[1].toString();
    weatherLongAPI = placeList.first.location.coordinates[0].toString();
    double screenWidth = MediaQuery.of(context).size.width;
    List<Hotels> nearbyHd = [];

    late ReviewRatings r;
    double userRating = 0;
    String message = '';

    NearbyModel model = NearbyModel(
        lat: placeList.first.location.coordinates[1].toString(),
        long: placeList.first.location.coordinates[0].toString(),
        maxRad: '3000');

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 350,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
                background: SafeArea(
              child: Stack(
                children: [
                  CarouselSlider.builder(
                      carouselController: controller,
                      itemCount: placeList.first.images.length,
                      itemBuilder: (context, index, realIndex) {
                        final urlImage =
                            placeList.first.images[index].secureUrl;
                        tempIndex = index;
                        return buildImage(context, urlImage, index);
                      },
                      options: CarouselOptions(
                          height: 400,
                          viewportFraction: 1,
                          autoPlay: true,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: const Duration(seconds: 1),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, reason) =>
                              pictureIndex.value = index)),
                  Positioned(
                    bottom: 30,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: pictureIndex,
                            builder: (context, value, child) {
                              return buildIndicator(pictureIndex.value,
                                  placeList.first.images.length);
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
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
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  final tempDir = await getTemporaryDirectory();
                  final controller = ScreenshotController();
                  final bytes = await controller.captureFromWidget(
                      Material(child: PlaceToImage(placeList)));
                  final file = await File('${tempDir.path}/image.png')
                      .writeAsBytes(bytes);
                  await Share.shareFiles([file.path],
                      text:
                          'Download our app now!\n\nhttps://play.google.com/store/apps/details?id=com.example.tripify');
                },
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
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  if (SharedService.id == '') {
                    final snackBar = SnackBar(
                      width: double.infinity,
                      dismissDirection: DismissDirection.down,
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: DefaultTextStyle(
                        style: const TextStyle(
                          fontFamily: fontRegular,
                        ),
                        child: AwesomeSnackbarContent(
                          title: 'Warning!',
                          message:
                              'Please login/signup to add this place to wishlist!',
                          contentType: ContentType.warning,
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  } else {
                    if (isListed.value) {
                      await APIService.deleteFromWishlist(placeList.first.sId)
                          .then((value) {
                        message = value;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            message,
                            style: const TextStyle(
                                fontFamily: fontRegular, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                          ),
                          backgroundColor: Colors.blue,
                        ));
                      });
                      isListed.value = false;
                    } else {
                      await APIService.addToWishlist(placeList.first.sId)
                          .then((value) {
                        message = value;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            message,
                            style: const TextStyle(
                                fontFamily: fontRegular, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                          ),
                          backgroundColor: Colors.blue,
                        ));
                      });

                      isListed.value = true;
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ValueListenableBuilder(
                      valueListenable: isListed,
                      builder: (context, value, child) {
                        return (isListed.value)
                            ? const Icon(
                                MdiIcons.heart,
                                color: Color.fromARGB(255, 244, 54, 70),
                                size: 24,
                              )
                            : const Icon(
                                MdiIcons.heartOutline,
                                color: Colors.black,
                                size: 24,
                              );
                      },
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
                          fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_pin,
                            size: 16, color: Colors.black54),
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
            delegate: PlaceCategoryTop(placeList.first.ratings),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ExpandableText(
                    placeList.first.description,
                    animation: true,
                    expandText: 'show more',
                    collapseText: 'show less',
                    maxLines: 6,
                    linkColor: Colors.blue,
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
                    'Activities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: placeList.first.activities.map((item) {
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: const Color.fromARGB(255, 233, 238, 240),
                        child: ListTile(
                          title: Text(
                            item,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
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
                    'Best time to visit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(children: [
                        Icon(Icons.calendar_month,
                            size: 40, color: Colors.lightGreen[800]),
                        const Text('January',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        const Text('Start month',
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54))
                      ]),
                      Row(
                        children: List.generate(
                          7,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 5.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                      Column(children: [
                        Icon(Icons.calendar_month,
                            size: 40, color: Colors.lightBlue[800]),
                        const Text('September',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        const Text('End month',
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54))
                      ]),
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
                    'Timing',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Table(
                    border: const TableBorder(
                      top: BorderSide.none,
                      bottom: BorderSide(color: Colors.black12),
                      horizontalInside: BorderSide(color: Colors.black12),
                      verticalInside: BorderSide.none,
                    ),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[100],
                        ),
                        children: const [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Day',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Open Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Close Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...List.generate(
                        placeList.first.timings.length,
                        (rowIndex) => TableRow(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: Text(
                                  placeList.first.timings[rowIndex].day,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: Text(
                                  placeList.first.timings[rowIndex].openTime,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: Text(
                                  placeList.first.timings[rowIndex].closeTime,
                                  textAlign: TextAlign.center,
                                ),
                              ),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          ...placeList.first.doS.map((d) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: const [
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Icon(
                                        MdiIcons.checkCircleOutline,
                                        color: Colors.green,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      d,
                                      style: const TextStyle(fontSize: 14),
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
                          const SizedBox(height: 16),
                          ...placeList.first.dontS.map((d) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: const [
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Icon(
                                        MdiIcons.cancel,
                                        color: Colors.red,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      d,
                                      style: const TextStyle(fontSize: 14),
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
                children: [
                  const Text(
                    'Cost',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  (placeList.first.entry)
                      ? Column(children: [
                          Wrap(
                            children:
                                placeList.first.entryCost.map((entryCost) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: Color((math.Random().nextDouble() *
                                              0xCCCCCC)
                                          .toInt())
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        entryCost.category,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          MdiIcons.currencyRupee,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        Text(
                                          entryCost.cost.toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ])
                      : Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 233, 238, 240),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                MdiIcons.cashRemove,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "Entry free",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
                    'How to reach',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ExpandableText(
                    'The Science Centre in Andaman and Nicobar Islands is located in Goodwill Estate, in the city of Port Blair. It is easily accessible by road from any part of the city. Here are some ways to reach the Science Centre:\n\n1. By car or taxi: You can hire a car or taxi from anywhere in Port Blair and ask the driver to take you to the Science Centre. The centre is located about 3 km from the city centre, and the journey should take around 15-20 minutes.\n\n2. By bus: You can take a local bus from any part of Port Blair that goes towards the Science Centre. You can ask the conductor or other passengers for help in identifying the correct bus. The journey may take a bit longer than by car or taxi, but it is a more affordable option.\n\n3. By auto-rickshaw: You can also take an auto-rickshaw from anywhere in Port Blair to reach the Science Centre. This option is more convenient if you are travelling alone or in a small group.',
                    animation: true,
                    expandText: 'show more',
                    collapseText: 'show less',
                    maxLines: 6,
                    linkColor: Colors.blue,
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
                    'Direction',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                      if (snapshot.connectionState == ConnectionState.done) {
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        size: 23,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.83,
                        child: Text(
                          (placeList.first.address.landmark == "null")
                              ? '${placeList.first.address.street}, ${placeList.first.address.zip}, ${placeList.first.address.city}, ${placeList.first.address.state}, ${placeList.first.address.country}'
                              : '${placeList.first.address.street}, ${placeList.first.address.landmark}, ${placeList.first.address.zip}, ${placeList.first.address.city}, ${placeList.first.address.state}, ${placeList.first.address.country}',
                          style: const TextStyle(color: Colors.black54),
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
                    'External links',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: placeList.first.externalLinks.map((externalLink) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: const Color.fromARGB(255, 233, 238, 240)),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              externalLink.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    child: Text(
                                      externalLink.link,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black54, fontSize: 13),
                                    )),
                                MaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    _launchWeb(externalLink.link);
                                  },
                                  color: Colors.lightBlue[600],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Row(
                                    children: const [
                                      Text(
                                        'Open',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Icon(
                                        Icons.open_in_new_outlined,
                                        size: 18,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
              FutureBuilder(
                future: Future.wait([getWeatherInfo(), getForcastInfo()]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return const HourForecast();
                  } else {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: CircularProgressIndicator(),
                    ));
                  }
                },
              ),
            ],
          )),
          SliverToBoxAdapter(
              child: (SharedService.id.isEmpty)
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rate this place',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                onRatingUpdate: (rating) {
                                  userRating = rating;
                                },
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
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Alert'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    content: const Text(
                                        "Please login with your email first!"),
                                    actions: <Widget>[
                                      MaterialButton(
                                        minWidth: double.infinity,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                              color: Colors.lightBlue[800]),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                    )
                  : FutureBuilder(
                      future: Future.wait([
                        APIService.reviewRatingUser(placeList.first.sId)
                            .then((value) => {ru = value}),
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return (ru.rating.toDouble() == 0)
                              ? Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Rate this place',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          RatingBar.builder(
                                            initialRating: ru.rating.toDouble(),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.blue,
                                            ),
                                            onRatingUpdate: (rating) {
                                              userRating = rating;
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: MaterialButton(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              200,
                                          height: 40,
                                          onPressed: () {
                                            if (userRating == 0) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const RatingErrorDialog(),
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    WriteReviewDialog(
                                                        userRating),
                                              );
                                            }
                                          },
                                          color: Colors.lightBlue[800],
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: const Text(
                                            'Write a review',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Your review',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      UserReviewWidget(ru)
                                    ],
                                  ),
                                );
                        } else {
                          return const LoaderReviewUser();
                        }
                      },
                    )),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ratings and reviews',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FutureBuilder(
                    future: Future.wait([
                      APIService.reviewRatingAll(placeList.first.sId)
                          .then((value) => {r = value}),
                      SharedService.getSharedLogin()
                    ]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (r.numberOfReviews == 0) {
                          return Container(
                            padding: const EdgeInsets.only(top: 30),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  MdiIcons.emoticonSadOutline,
                                  size: 58,
                                  color: Theme.of(context).disabledColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No data available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).disabledColor,
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
                                        r.ratingsAverage.toStringAsFixed(1),
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
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.blue,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      Text(
                                        r.numberOfReviews.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          const Text('5'),
                                          LinearPercentIndicator(
                                            backgroundColor:
                                                Colors.grey[300] as Color,
                                            animation: true,
                                            animationDuration: 3000,
                                            width: 160.0,
                                            lineHeight: 10.0,
                                            percent: (r.numberOfReviews == 0)
                                                ? 0
                                                : (r.fiveCount /
                                                    r.numberOfReviews),
                                            barRadius:
                                                const Radius.circular(16),
                                            progressColor: Colors.blue,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          const Text('4'),
                                          LinearPercentIndicator(
                                            backgroundColor:
                                                Colors.grey[300] as Color,
                                            animation: true,
                                            animationDuration: 3000,
                                            width: 160.0,
                                            lineHeight: 10.0,
                                            percent: (r.numberOfReviews == 0)
                                                ? 0
                                                : (r.fourCount /
                                                    r.numberOfReviews),
                                            barRadius:
                                                const Radius.circular(16),
                                            progressColor: Colors.blue,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          const Text('3'),
                                          LinearPercentIndicator(
                                            backgroundColor:
                                                Colors.grey[300] as Color,
                                            animation: true,
                                            animationDuration: 3000,
                                            width: 160.0,
                                            lineHeight: 10.0,
                                            percent: (r.numberOfReviews == 0)
                                                ? 0
                                                : (r.threeCount /
                                                    r.numberOfReviews),
                                            barRadius:
                                                const Radius.circular(16),
                                            progressColor: Colors.blue,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          const Text('2'),
                                          LinearPercentIndicator(
                                            backgroundColor:
                                                Colors.grey[300] as Color,
                                            animation: true,
                                            animationDuration: 3000,
                                            width: 160.0,
                                            lineHeight: 10.0,
                                            percent: (r.numberOfReviews == 0)
                                                ? 0
                                                : (r.twoCount /
                                                    r.numberOfReviews),
                                            barRadius:
                                                const Radius.circular(16),
                                            progressColor: Colors.blue,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          const Text('1 '),
                                          LinearPercentIndicator(
                                            backgroundColor:
                                                Colors.grey[300] as Color,
                                            animation: true,
                                            animationDuration: 3000,
                                            width: 160.0,
                                            lineHeight: 10.0,
                                            percent: (r.numberOfReviews == 0)
                                                ? 0
                                                : (r.oneCount /
                                                    r.numberOfReviews),
                                            barRadius:
                                                const Radius.circular(16),
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
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: (r.numberOfReviews == 1)
                                    ? 1
                                    : (r.numberOfReviews == 2)
                                        ? 2
                                        : 3,
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
                                        color: Colors.lightBlue[700] as Color),
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                      } else {
                        return const LoaderReviewAll();
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
                children: [
                  const Text(
                    'Similar places',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.width / 1.58,
                      child: PlaceRecommendationByPlace(placeList.first.sId))
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                width: double.infinity,
                child: const Text(
                  "Nearby hotels",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              FutureBuilder(
                future: APIService.nearbyHotel(model)
                    .then((value) => {nearbyHd = value}),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (nearbyHd.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 85),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              MdiIcons.alertCircleOutline,
                              size: 58,
                              color: Theme.of(context).disabledColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hotels found!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          Wrap(
                            children: nearbyHd.map((widget) {
                              Point point1 = Point(
                                  latitude:
                                      placeList.first.location.coordinates[1],
                                  longitude:
                                      placeList.first.location.coordinates[0]);
                              Point point2 = Point(
                                  latitude: widget.location.coordinates[1],
                                  longitude: widget.location.coordinates[0]);

                              var distance = georange.distance(point1, point2);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, HotelDetailsPage.routeName,
                                      arguments: [widget]);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2.0,
                                        blurRadius: 5.0,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    color: Colors.white,
                                  ),
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(12),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: CachedNetworkImage(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .25,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .25,
                                            imageUrl:
                                                widget.images.first.secureUrl,
                                            placeholder: (context, url) =>
                                                Image.memory(
                                              kTransparentImage,
                                              fit: BoxFit.cover,
                                            ),
                                            fadeInDuration: const Duration(
                                                milliseconds: 200),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .55,
                                            child: Text(
                                              widget.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .55,
                                            child: Text(widget.address.city,
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              RatingBar.builder(
                                                initialRating:
                                                    widget.ratings.toDouble(),
                                                ignoreGestures: true,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 16,
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {},
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                widget.ratings.toString(),
                                                style: const TextStyle(
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                  ' (${widget.reviews.length} reviews)',
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black54)),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.lightBlue[700],
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  '${distance.toStringAsFixed(1)}km away',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                width: double.infinity,
                child: const Text(
                  "Nearby Restaurants",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              FutureBuilder(
                future: APIService.nearbyRestaurants(model)
                    .then((value) => {nearbyRd = value}),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (nearbyRd.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 85),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              MdiIcons.alertCircleOutline,
                              size: 58,
                              color: Theme.of(context).disabledColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No restaurants found!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          Wrap(
                            children: nearbyRd.map((widget) {
                              Point point1 = Point(
                                  latitude: currentLocation.latitude!,
                                  longitude: currentLocation.longitude!);
                              Point point2 = Point(
                                  latitude: widget.location.coordinates[1],
                                  longitude: widget.location.coordinates[0]);

                              var distance = georange.distance(point1, point2);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RestaurantDetailsPage.routeName,
                                      arguments: [widget]);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2.0,
                                        blurRadius: 5.0,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    color: Colors.white,
                                  ),
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(12),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: CachedNetworkImage(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .25,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .25,
                                            imageUrl:
                                                widget.images.first.secureUrl,
                                            placeholder: (context, url) =>
                                                Image.memory(
                                              kTransparentImage,
                                              fit: BoxFit.cover,
                                            ),
                                            fadeInDuration: const Duration(
                                                milliseconds: 200),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .55,
                                            child: Text(
                                              widget.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .55,
                                            child: Text(widget.address.city,
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Icon(
                                            MdiIcons.squareCircle,
                                            size: 18,
                                            color: (widget.isVeg)
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.lightBlue[700],
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  '${distance.toStringAsFixed(1)}km away',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ))
        ],
      ),
    );
  }
}

class PlaceCategory extends StatefulWidget {
  final double ratingsAverage;
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
                  Text(
                    widget.ratingsAverage.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 14),
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
                    valueListenable: temperatureNotifier,
                    builder: (context, value, child) {
                      return (temperatureNotifier.value == '')
                          ? const Text('-')
                          : Text(
                              '${temperatureNotifier.value}°c',
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
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
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

class UserReviewWidget extends StatefulWidget {
  final ReviewUser ru;
  const UserReviewWidget(this.ru, {Key? key}) : super(key: key);

  @override
  State<UserReviewWidget> createState() => _UserReviewWidgetState();
}

class _UserReviewWidgetState extends State<UserReviewWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.ru.date);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: Color(
                                (math.Random().nextDouble() * 0x333333).toInt())
                            .withOpacity(1.0),
                        child: Text(
                          widget.ru.name[0],
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.ru.name,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.lightBlue,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              MdiIcons.checkDecagram,
                              size: 12,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              'You',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'update',
                        child: Text(
                          'Update review',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete review',
                            style: TextStyle(fontSize: 15)),
                      ),
                    ],
                    onSelected: (String value) {
                      if (value == 'update') {
                        showDialog(
                          context: context,
                          builder: (context) => EditReviewDialog(widget.ru),
                        );
                      } else if (value == 'delete') {
                        APIService.deleteUserReview(currentPlace.first.sId);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Review deleted",
                            style: TextStyle(
                                fontFamily: fontRegular, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 3,
                          ),
                          backgroundColor: Colors.green,
                        ));
                      }
                    },
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  RatingBar.builder(
                    initialRating: widget.ru.rating.toDouble(),
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
                widget.ru.comment,
                style: TextStyle(color: Colors.grey[700] as Color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget buildImage(BuildContext context, String urlImage, int index) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
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
    ),
  );
}

class WriteReviewDialog extends StatefulWidget {
  final double rating;
  const WriteReviewDialog(this.rating, {Key? key}) : super(key: key);

  @override
  State<WriteReviewDialog> createState() => _WriteReviewDialogState();
}

class _WriteReviewDialogState extends State<WriteReviewDialog> {
  _WriteReviewDialogState();
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Write a review'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Your rating: ',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RatingBar.builder(
                        initialRating: widget.rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 18.0,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 6.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.blue,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              TextFormField(
                controller: _controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write a review!';
                  }
                  return null;
                },
                maxLines: null,
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Write a review..',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 3,
                      color: Colors.black,
                      style: BorderStyle.solid,
                    ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(16),
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.lightBlue[800]),
          ),
        ),
        MaterialButton(
          onPressed: () {
            //Navigator.of(context).pop();
            isLoading = true;
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            if (_formKey.currentState!.validate()) {
              UserReviewModel model = UserReviewModel(
                  placeId: currentPlace.first.sId,
                  rating: widget.rating.toInt(),
                  comment: _controller.text);
              APIService.userReview(model).then(
                (response) {
                  if (response.contains('Done')) {
                    Navigator.of(context).pop();
                    isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Successfully submitted!',
                        style: TextStyle(fontFamily: fontRegular, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 3,
                      ),
                      backgroundColor: Colors.green,
                    ));
                  } else {
                    final snackBar = SnackBar(
                      width: double.infinity,
                      dismissDirection: DismissDirection.down,
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: DefaultTextStyle(
                        style: const TextStyle(
                          fontFamily: fontRegular,
                        ),
                        child: AwesomeSnackbarContent(
                          title: 'Error 500',
                          message: response,
                          contentType: ContentType.warning,
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  }
                },
              );
            }
          },
          color: Colors.lightBlue[800],
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: isLoading
              ? const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }
}

class EditReviewDialog extends StatefulWidget {
  final ReviewUser ru;
  const EditReviewDialog(this.ru, {Key? key}) : super(key: key);

  @override
  State<EditReviewDialog> createState() => _EditReviewDialogState();
}

class _EditReviewDialogState extends State<EditReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameNotifier = ValueNotifier<String>('');
  double userRating = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    userRating = widget.ru.rating.toDouble();
    return AlertDialog(
      title: const Text('Edit review'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Give rating: ',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RatingBar.builder(
                        initialRating: widget.ru.rating.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 18.0,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 6.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.blue,
                        ),
                        onRatingUpdate: (rating) {
                          userRating = rating;
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              TextFormField(
                //controller: _controller,
                initialValue: widget.ru.comment,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write a review!';
                  }
                  return null;
                },
                maxLines: null,
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Write a review..',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 3,
                      color: Colors.black,
                      style: BorderStyle.solid,
                    ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(16),
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  _nameNotifier.value = value;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.lightBlue[800]),
          ),
        ),
        MaterialButton(
          onPressed: () {
            //Navigator.of(context).pop();
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            if (_formKey.currentState!.validate()) {
              isLoading = true;
              UserReviewModel model = UserReviewModel(
                placeId: currentPlace.first.sId,
                rating: userRating.toInt(),
                comment: (_nameNotifier.value == '')
                    ? widget.ru.comment
                    : _nameNotifier.value,
              );
              APIService.userReview(model).then(
                (response) {
                  if (response.contains('Done')) {
                    Navigator.of(context).pop();
                    isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Successfully updated!',
                        style: TextStyle(fontFamily: fontRegular, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 3,
                      ),
                      backgroundColor: Colors.green,
                    ));
                  } else {
                    isLoading = false;
                    final snackBar = SnackBar(
                      width: double.infinity,
                      dismissDirection: DismissDirection.down,
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: DefaultTextStyle(
                        style: const TextStyle(
                          fontFamily: fontRegular,
                        ),
                        child: AwesomeSnackbarContent(
                          title: 'Error 500',
                          message: response,
                          contentType: ContentType.warning,
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  }
                },
              );
            }
          },
          color: Colors.lightBlue[800],
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: isLoading
              ? const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }
}

class RatingErrorDialog extends StatefulWidget {
  const RatingErrorDialog({super.key});

  @override
  State<RatingErrorDialog> createState() => _RatingErrorDialogState();
}

class _RatingErrorDialogState extends State<RatingErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alert'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: const Text("Please rate this place first!"),
      actions: <Widget>[
        MaterialButton(
          minWidth: double.infinity,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'OK',
            style: TextStyle(color: Colors.lightBlue[800]),
          ),
        ),
      ],
    );
  }
}
