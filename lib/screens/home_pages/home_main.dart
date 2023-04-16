import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/animation/FadeAnimation.dart';
import 'package:tripify/loader/loader_home_main.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/screens/category.dart';
import 'package:tripify/screens/home_services/hotel.dart';
import 'package:tripify/screens/home_services/tour_operator.dart';
import 'package:tripify/screens/island.dart';
import 'package:tripify/screens/location_weather.dart';
import 'package:tripify/screens/search_page.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/services/geocoding.dart';
import 'package:tripify/services/shared_service.dart';
import 'package:tripify/widget/place_recommendation_byuser.dart';

int currentHour = DateTime.now().hour;
String greet = '';
int activeIndex = 0;
String currentPlace = '';
final controller = CarouselController();
List<CategoryAll> c = [];
List<IslandAll> ia = [];
List<ServiceAll> sa = [];
List<LatLng> islandCoords = [];
List<Places2> pa = [];

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  List<LatLng> islandCoords = [];

  Future<List<LatLng>> fetchIslandLocation(List<IslandAll> ia) async {
    List<LatLng> islandCoords = [];
    LatLng cameraTarget = const LatLng(0, 0);
    for (var i = 0; i < ia.length; i++) {
      await getCoordinatesFromPace('(andaman and nicobar island) ${ia[i].name}')
          .then((value) => {cameraTarget = value});
      islandCoords.add(cameraTarget);
    }
    return islandCoords;
  }

  @override
  Widget build(BuildContext context) {
    if (currentHour < 12) {
      greet = 'Good morning,';
    } else if (currentHour < 17) {
      greet = 'Good afternoon,';
    } else {
      greet = 'Good evening,';
    }
    return FutureBuilder(
      future: Future.wait([
        APIService.categoryAll().then((value) => {c = value}),
        APIService.islandAll().then((value) => {ia = value}),
        APIService.serviceAll().then((value) => {sa = value}),
        APIService.placeRecommendationByUser().then((value) => {pa = value}),
        getCurrentLocation(),
        SharedService.getSharedLogin(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return HomeMainScreen(islandCoords);
        } else {
          return const LoaderHomeMain();
        }
      },
    );
  }
}

class HomeMainScreen extends StatefulWidget {
  final List<LatLng> islandCoords;
  const HomeMainScreen(this.islandCoords, {super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    SharedService.getSharedLogin();
    locationSubscription = location.onLocationChanged.listen((value) {
      setState(() {
        getPlaceNameFromCoordinate(
            currentLocation.latitude!, currentLocation.longitude!);
        currentPlace = currentLocationName;
      });
    });
  }

  @override
  void dispose() {
    islandCoords = [];
    stopListeningForLocationUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth / 2 - 25;
    double containerHeight = containerWidth * 0.60;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                stopListeningForLocationUpdates();
                HapticFeedback.mediumImpact();
                Navigator.pushNamed(
                  context,
                  LocationWeather.routeName,
                );
              },
              child: FadeAnimation(
                1,
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 23,
                        color: Colors.lightBlue[700],
                      ),
                      Text(
                        currentPlace,
                        style: TextStyle(
                            color: Colors.lightBlue[700], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FadeAnimation(
              1.1,
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      greet,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      ' ${SharedService.name.split(' ').firstWhere((name) => name.length > 2)}',
                      //' ${SharedService.name}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            FadeAnimation(
              1.2,
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(right: 90.0),
                padding: const EdgeInsets.only(bottom: 16.0),
                child: const Text(
                  'Where do you want to go?',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 2, 116, 169)),
                ),
              ),
            ),
            FadeAnimation(
              1.3,
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, SearchPage.routeName);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade200.withOpacity(0.3),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        const Icon(Icons.search_outlined,
                            color: Color.fromARGB(221, 55, 55, 55)),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * .0145),
                          height: MediaQuery.of(context).size.height * .06,
                          child: const Text(
                            'Search Places',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            FadeAnimation(
              1.4,
              CarouselSlider.builder(
                  carouselController: controller,
                  itemCount: ia.length,
                  itemBuilder: (context, index, realIndex) {
                    final urlImage = ia[index].image.secureUrl;
                    final urlImageText = ia[index].name;
                    return buildImage(context, urlImage, urlImageText, index
                        // widget.islandCoords[index]
                        );
                  },
                  options: CarouselOptions(
                      height: 200,
                      viewportFraction: 0.78,
                      autoPlay: true,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) =>
                          setState(() => activeIndex = index))),
            ),
            const SizedBox(height: 12),
            FadeAnimation(1.5, buildIndicator()),
            FadeAnimation(
              1.6,
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                child: const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            FadeAnimation(
              1.7,
              Column(
                children: [
                  for (int i = 0; i < c.length; i += 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              Navigator.pushNamed(context, Category.routeName,
                                  arguments: [
                                    c[i],
                                    ia,
                                  ]);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                CachedNetworkImage(
                                  height: containerHeight,
                                  width: containerWidth,
                                  imageUrl: c[i].image.secureUrl,
                                  placeholder: (context, url) => Image.memory(
                                    kTransparentImage,
                                    fit: BoxFit.cover,
                                  ),
                                  fadeInDuration:
                                      const Duration(milliseconds: 200),
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  height: containerHeight,
                                  width: containerWidth,
                                  color: const Color.fromARGB(69, 0, 0, 0),
                                ),
                                SizedBox(
                                  height: containerHeight,
                                  width: containerWidth - 8,
                                  child: Center(
                                    child: Text(
                                      c[i].name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          if (i + 1 < c.length)
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                Navigator.pushNamed(context, Category.routeName,
                                    arguments: [
                                      c[i + 1],
                                      ia,
                                    ]);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          height: containerHeight,
                                          width: containerWidth,
                                          imageUrl: c[i + 1].image.secureUrl,
                                          placeholder: (context, url) =>
                                              Image.memory(
                                            kTransparentImage,
                                            fit: BoxFit.cover,
                                          ),
                                          fadeInDuration:
                                              const Duration(milliseconds: 200),
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          height: containerHeight,
                                          width: containerWidth,
                                          color:
                                              const Color.fromARGB(69, 0, 0, 0),
                                        ),
                                        SizedBox(
                                          height: containerHeight,
                                          width: containerWidth - 8,
                                          child: Center(
                                            child: Text(
                                              c[i + 1].name,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            FadeAnimation(
                1.8,
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: const Text(
                        'Recommendations for you',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.width / 1.58,
                        child: PlaceRecommendationByUser(pa)),
                    //PlaceHorizontal(item.sId, islandDetails.sId)
                  ],
                )),
            FadeAnimation(
              1.8,
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                child: const Text(
                  'Services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            FadeAnimation(
                1.9,
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(sa.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        if (index == 0) {
                          Navigator.pushNamed(context, HotelScreen.routeName,
                              arguments: [
                                ia,
                              ]);
                        }
                        if (index == 1) {
                          Navigator.pushNamed(
                              context, TourOperatorSceen.routeName);
                        }
                        // Navigator.pushNamed(context, HotelScreen.routeName,
                        //     arguments: c);
                      },
                      child: ClipRRect(
                        child: Column(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: CachedNetworkImage(
                              height: screenWidth / 5.61,
                              width: screenWidth / 5.61,
                              imageUrl: sa[index].image.secureUrl,
                              placeholder: (context, url) => Image.memory(
                                kTransparentImage,
                                fit: BoxFit.cover,
                              ),
                              fadeInDuration: const Duration(milliseconds: 200),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            sa[index].name,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ]),
                      ),
                    );
                  }),
                )),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        onDotClicked: animateToSlide,
        effect: const ExpandingDotsEffect(
            dotHeight: 10,
            dotWidth: 10,
            dotColor: Color.fromARGB(255, 155, 155, 155),
            activeDotColor: Colors.blue),
        activeIndex: activeIndex,
        count: ia.length,
      );

  void animateToSlide(int index) => controller.animateToPage(index);
}

Widget buildImage(
  BuildContext context,
  String urlImage,
  String urlImageText,
  int index,
  //LatLng islandCoord
) {
  return GestureDetector(
    onTap: () {
      HapticFeedback.mediumImpact();
      Navigator.pushNamed(context, Island.routeName, arguments: [c, ia[index]]);
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(children: [
        CachedNetworkImage(
          height: 200,
          width: MediaQuery.of(context).size.width,
          imageUrl: urlImage,
          placeholder: (context, url) => Image.memory(
            kTransparentImage,
            fit: BoxFit.cover,
          ),
          fadeInDuration: const Duration(milliseconds: 200),
          fit: BoxFit.cover,
        ),
        Container(
          margin: const EdgeInsets.only(top: 100.0),
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.0),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              urlImageText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ]),
    ),
  );
}
