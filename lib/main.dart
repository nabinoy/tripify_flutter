import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/router.dart';
import 'package:tripify/splash/splash_screen.dart';
import 'constants/global_variables.dart';

void main() => runApp(const Tripify());

class Tripify extends StatelessWidget {
  const Tripify({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: fontRegular,
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: bgColor,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const SplashScreen(),
    );
  }
}
