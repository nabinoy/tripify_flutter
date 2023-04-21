import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';
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
      if (now.isAfter(expiryTokenDate)){
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
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(top: 100),
                    child: Lottie.asset('assets/onboard/onboard_image1.json'),
                  ),
                  Container(
                    width: 250.0,
                    margin: const EdgeInsets.only(bottom: 120),
                    child: TextLiquidFill(
                      text: 'Tripify',
                      waveColor: Colors.lightBlue,
                      loadDuration: const Duration(seconds: 3),
                      waveDuration: const Duration(seconds: 1),
                      boxBackgroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      boxHeight: 100.0,
                    ),
                  ),
                  const SpinKitThreeBounce(
                    size: 25,
                    color: Color(0xff01579b),
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
