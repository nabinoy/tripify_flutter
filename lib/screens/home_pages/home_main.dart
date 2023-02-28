import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/animation/FadeAnimation.dart';
import 'package:tripify/loader/loader_home_main.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/screens/category.dart';
import 'package:tripify/screens/island.dart';
import 'package:tripify/screens/location_weather.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/services/geocoding.dart';
import 'package:tripify/services/shared_service.dart';

int currentHour = DateTime.now().hour;
String greet = '';
int activeIndex = 0;
String currentPlace = '';
final controller = CarouselController();

Future<void> delayMain(int milliseconds) {
  return Future.delayed(Duration(milliseconds: milliseconds), () {
    // code to be executed after the specified duration
  });
}

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
        delayMain(3000),
        getCurrentLocation(),
        SharedService.getSharedLogin(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const HomeMainScreen();
        } else {
          return const LoaderHomeMain();
        }
      },
    );
  }
}

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

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
                      const Icon(
                        Icons.location_pin,
                        size: 23,
                        color: Colors.lightBlue,
                      ),
                      Text(
                        currentPlace,
                        style: const TextStyle(
                            color: Colors.lightBlue, fontSize: 14),
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
                      ' ${SharedService.name}',
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
              CarouselSlider.builder(
                  carouselController: controller,
                  itemCount: urlImages.length,
                  itemBuilder: (context, index, realIndex) {
                    final urlImage = urlImages[index];
                    final urlImageText = urlImagesText[index];
                    return buildImage(context, urlImage, urlImageText, index);
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
            FadeAnimation(1.4, buildIndicator()),
            FadeAnimation(
              1.5,
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
              1.6,
              Column(
                children: [
                  for (int i = 0; i < categories.length; i += 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              Navigator.pushNamed(context, Category.routeName);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                CachedNetworkImage(
                                  height: containerHeight,
                                  width: containerWidth,
                                  imageUrl: catImage[i],
                                  placeholder: (context, url) => Image.memory(
                                    kTransparentImage,
                                    fit: BoxFit.cover,
                                  ),
                                  fadeInDuration:
                                      const Duration(milliseconds: 200),
                                  fit: BoxFit.cover,
                                ),
                                Center(
                                  child: Text(
                                    categories[i],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          if (i + 1 < categories.length)
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                Navigator.pushNamed(
                                    context, Category.routeName);
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
                                          imageUrl: catImage[i + 1],
                                          placeholder: (context, url) =>
                                              Image.memory(
                                            kTransparentImage,
                                            fit: BoxFit.cover,
                                          ),
                                          fadeInDuration:
                                              const Duration(milliseconds: 200),
                                          fit: BoxFit.cover,
                                        ),
                                        Center(
                                          child: Text(
                                            categories[i + 1],
                                            style: const TextStyle(
                                                color: Colors.white),
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
              1.7,
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
        count: urlImages.length,
      );

  void animateToSlide(int index) => controller.animateToPage(index);
}

Widget buildImage(
    BuildContext context, String urlImage, String urlImageText, int index) {
  return GestureDetector(
    onTap: () {
      HapticFeedback.mediumImpact();
      Navigator.pushNamed(context, Island.routeName);
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
