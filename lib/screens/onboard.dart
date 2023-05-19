import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/services.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/onboard_model.dart';
import 'package:lottie/lottie.dart';
import 'package:tripify/router.dart';
import 'package:tripify/screens/welcome.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});
  static const String routeName = '/onboard';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        fontFamily: fontRegular,
        // ignore: deprecated_member_use
        androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              PageView(
                  controller: controller,
                  onPageChanged: (index) {
                    setState(() {
                      onLastPage = (index == 2);
                    });
                  },
                  children: screens
                      .map(
                        (screen) => Container(
                          color: screen.bg,
                          padding: const EdgeInsets.all(28),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(40),
                                width: 384,
                                height: 300,
                                child: Lottie.asset(
                                  screen.img,
                                  animate: true,
                                  frameRate: FrameRate.max,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Text(
                                  screen.text,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Text(
                                  screen.desc,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(162, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList()),
              Container(
                  alignment: const Alignment(0, 0.65),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      onLastPage
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 120),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 10, 24, 10),
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                    ),
                                  ),
                                  onPressed: null,
                                  child: const Text(
                                    'Skip',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 120),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 10, 24, 10),
                                    foregroundColor: Colors.lightBlue[800],
                                    backgroundColor: Colors.transparent,
                                    splashFactory: NoSplash.splashFactory,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                    ),
                                  ),
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    controller.jumpToPage(2);
                                  },
                                  child: const Text(
                                    'Skip',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 2, 119, 189),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: const ExpandingDotsEffect(
                          dotColor: Color(0xffb3e5fc),
                          activeDotColor: Color(0xff01579b),
                          spacing: 8.0,
                          dotWidth: 10.0,
                          dotHeight: 10.0,
                        ),
                      ),
                      onLastPage
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 32, 0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 120),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 10, 24, 10),
                                    backgroundColor: Colors.transparent,
                                    splashFactory: NoSplash.splashFactory,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                    ),
                                  ),
                                  onPressed: null,
                                  child: const Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.transparent,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 32, 0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 120),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 10, 24, 10),
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.lightBlue[800],
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn);
                                  },
                                  child: const Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            )
                    ],
                  )),
              if (onLastPage)
                Container(
                  margin: const EdgeInsets.only(bottom: 100),
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                    child: Builder(builder: (context) {
                      return TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.lightBlue[800],
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                        ),
                        onPressed: () async {
                          HapticFeedback.mediumImpact();
                          Navigator.pushReplacementNamed(
                              context, Welcome.routeName);
                        },
                        child: const Text(
                          'Get started',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
