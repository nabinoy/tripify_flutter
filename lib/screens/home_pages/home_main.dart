import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:georange/georange.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/loader/loader_home_main.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/nearby_request_model.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/screens/category.dart';
import 'package:tripify/screens/filter_page/place_filter.dart';
import 'package:tripify/screens/home_services/hotel.dart';
import 'package:tripify/screens/home_services/restaurant.dart';
import 'package:tripify/screens/home_services/tour_operator.dart';
import 'package:tripify/screens/island.dart';
import 'package:tripify/screens/itinerary/itinerary_page.dart';
import 'package:tripify/screens/location_weather.dart';
import 'package:tripify/screens/home_services/map_webview.dart';
import 'package:tripify/screens/login.dart';
import 'package:tripify/screens/place.dart';
import 'package:tripify/screens/search/search_place.dart';
import 'package:tripify/screens/signup.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/services/geocoding.dart';
import 'package:tripify/services/shared_service.dart';
import 'package:tripify/widget/place_recommendation_byuser.dart';

int currentHour = DateTime.now().hour;
String greet = '';

String currentPlace = '';
final controller = CarouselController();
List<CategoryAll> c = [];
List<IslandAll> ia = [];
List<ServiceAll> sa = [];
List<LatLng> islandCoords = [];
List<Places2> pa = [];
List<String> wishlistPlaceIdList = [];

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
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
        APIService.checkUserWishlist()
            .then((value) => {wishlistPlaceIdList.addAll(value)}),
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
  int activeIndex = 0;
  late Future dataNearby;
  List<Places2> nearbyPd = [];
  GeoRange georange = GeoRange();

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    SharedService.getSharedLogin();
    NearbyModel model = NearbyModel(
        lat: currentLocation.latitude!.toString(),
        long: currentLocation.longitude!.toString(),
        maxRad: maxRadius.toString());
    dataNearby =
        APIService.nearbyPlace(model).then((value) => {nearbyPd = value});
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 23,
                      color: Colors.lightBlue[800],
                    ),
                    Text(
                      currentPlace,
                      style:
                          TextStyle(color: Colors.lightBlue[800], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
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
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SearchPlace.routeName,
                        arguments: [wishlistPlaceIdList]);
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
                                    MediaQuery.of(context).size.height * .0143),
                            width: MediaQuery.of(context).size.width * .48,
                            child: const Text(
                              'Search Places',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: MaterialButton(
                    elevation: 0,
                    minWidth: MediaQuery.of(context).size.width * .2,
                    onPressed: () {
                      Navigator.pushNamed(context, FilterPlace.routeName,
                          arguments: [c, ia, wishlistPlaceIdList]);
                    },
                    color: Colors.lightBlue[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.filter_list_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * .016),
                          child: const Text(
                            'Filter',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            CarouselSlider.builder(
                carouselController: controller,
                itemCount: ia.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = ia[index].image.secureUrl;
                  final urlImageText = ia[index].name;
                  return buildImage(context, urlImage, urlImageText, index);
                },
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.25,
                    viewportFraction: 0.78,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index))),
            const SizedBox(height: 12),
            buildIndicator(),
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
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: const Text(
                    'Recommendations for you',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                (SharedService.id == '')
                    ? Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Lottie.asset(
                                  'assets/lottie/login_wishlist.json',
                                  frameRate: FrameRate.max),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Unlock your dream destinations! Sign up or log in now to discover personalized place recommendations based on your interests!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 40,
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    Navigator.pushNamed(
                                        context, LoginPage.routeName);
                                  },
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 2,
                                          color:
                                              Color.fromRGBO(2, 119, 189, 1)),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Color.fromRGBO(2, 119, 189, 1),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ),
                                MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 40,
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    Navigator.pushNamed(
                                        context, SignupPage.routeName);
                                  },
                                  color: Colors.lightBlue[800],
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Text(
                                    "Sign up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 265, child: PlaceRecommendationByUser(pa)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
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
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Itinerary Generator',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.38,
                              child: const Text(
                                  "Unlock your perfect holiday\nLet our Machine Learning algorithm curate your ultimate travel itinerary!"),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            MaterialButton(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.38,
                              height: 40,
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                Navigator.pushNamed(
                                    context, ItineraryPage.routeName,
                                    arguments: [c, ia, currentLocation]);
                              },
                              color: Colors.lightBlue[800],
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Text(
                                "Generate",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Lottie.asset(
                              'assets/lottie/itinerary_home.json',
                              frameRate: FrameRate.max),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16.0),
              child: const Text(
                'Nearby places',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
              future: dataNearby,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return (nearbyPd.isEmpty)
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 60),
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
                                'No places found!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Wrap(
                              children: nearbyPd.map((widget) {
                                Point point1 = Point(
                                    latitude: currentLocation.latitude!,
                                    longitude: currentLocation.longitude!);
                                Point point2 = Point(
                                    latitude: widget.location.coordinates[1],
                                    longitude: widget.location.coordinates[0]);

                                var distance =
                                    georange.distance(point1, point2);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Place.routeName,
                                        arguments: [
                                          [widget],
                                          (wishlistPlaceIdList
                                                  .contains(widget.sId))
                                              ? true
                                              : false
                                        ]);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    margin: const EdgeInsets.only(
                                      top: 8.0,
                                    ),
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
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 12),
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
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                                  widget.ratings.toStringAsFixed(1),
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                                Text(
                                                    ' (${widget.reviews.length})',
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                      horizontal: 8),
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
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
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
            const SizedBox(
              height: 14,
            ),
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
                    if (sa[index].name.contains('Hotel')) {
                      Navigator.pushNamed(context, HotelScreen.routeName,
                          arguments: [
                            ia,
                          ]);
                    }
                    if (sa[index].name.contains('Tour Operator')) {
                      Navigator.pushNamed(context, TourOperatorSceen.routeName);
                    }
                    if (sa[index].name.contains('Nearby ATMs')) {
                      Navigator.pushNamed(context, MapWebView.routeName);
                    }
                    if (sa[index].name.contains('Nearby Restrooms')) {
                      Navigator.pushNamed(context, ToiletMapWebView.routeName);
                    }
                    if (sa[index].name.contains('Restaurant')) {
                      Navigator.pushNamed(context, RestaurantScreen.routeName,
                          arguments: [
                            ia,
                          ]);
                    }
                    if (sa[index].name.contains('Nearby Hospitals')) {
                      Navigator.pushNamed(
                          context, HospitalMapWebView.routeName);
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(children: [
                      CachedNetworkImage(
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
                      Text(
                        sa[index].name,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ]),
                  ),
                );
              }),
            )
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
            dotColor: Color.fromARGB(255, 200, 222, 232),
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
          height: MediaQuery.of(context).size.height * 0.25,
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
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.13),
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
