import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripify/screens/onboard.dart';
import 'package:tripify/services/shared_service.dart';
import '../screens/home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool value = true;
  bool userToken = false;
  DateTime now = DateTime.now();

  Future<PageTransition> loadFromFuture() async {
    return PageTransition(
      child: const Home(),
      type: PageTransitionType.fade,
    );
  }

  Future<void> readForOnboard() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'is_first_time_open';
    value = prefs.getBool(key) ?? true;
  }

  Future<void> readForUser() async {
    const storage = FlutterSecureStorage();
    String userValue = await storage.read(key: 'token') ?? 'NO_USER_FOUND';
    if (userValue == 'NO_USER_FOUND') {
      userToken = false;
      SharedService.setSharedUserToken(userToken);
    } else {
      userToken = true;
      SharedService.setSharedUserToken(userToken);
      Map<String, dynamic> decodedToken = JwtDecoder.decode(userValue);
      DateTime expiryTokenDate =
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      if (now.isAfter(expiryTokenDate)) {
        SharedService.setSharedLogOut();
        SharedService.setSessionExpire(true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SharedService.shareInit();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return FutureBuilder(
      future: Future.wait([readForOnboard(), readForUser()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AnimatedSplashScreen(
              curve: Curves.easeIn,
              duration: 3000,
              splashIconSize: 600,
              splash: Column(
                children: [
                  Animate(
                    effects: [
                      FadeEffect(duration: 1000.ms),
                      ShimmerEffect(delay:800.ms,duration: 1500.ms),
                      ScaleEffect(duration: 800.ms,curve: Curves.fastEaseInToSlowEaseOut)
                    ],
                    child: Container(
                      height: 150,
                      width: 250,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.22),
                      child: Image.asset('assets/images/tripify_logo.png'),
                    ),
                  ),
                  Animate(
                    effects: [
                      FadeEffect(duration: 500.ms,delay: 1000.ms),
                      SlideEffect(duration: 800.ms,curve: Curves.elasticOut)
                    ],
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Tripify\nAndaman",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.2,
                          color: Colors.lightBlue[800],
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Animate(
                    effects: [
                      FadeEffect(duration: 1000.ms,delay: 1000.ms),
                      SlideEffect(duration: 800.ms,curve: Curves.decelerate)
                    ],
                    child: Container(
                      margin: const EdgeInsets.only(top: 7),
                      child: const Text(
                        "Dream it, Visit it",
                        style: TextStyle(
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              nextScreen: (value) ? const OnBoardingScreen() : const Home(),
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.fade,
              backgroundColor: Colors.white);
        } else {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
      },
    );
  }
}
