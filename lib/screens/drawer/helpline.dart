import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/router.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpline extends StatelessWidget {
  static const String routeName = '/helpline';
  const Helpline({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

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
        scaffoldBackgroundColor: bgColor,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          leading: IconButton(
            onPressed: () async {
              HapticFeedback.mediumImpact();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Row(children: [
            const Text('Call here'),
            ElevatedButton(
              onPressed: () {
                _makePhoneCall('+919531839056');
              },
              child: const Text('Call'),
            )
          ]),
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
