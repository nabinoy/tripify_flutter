import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/router.dart';
import 'package:tripify/screens/home.dart';
import 'package:tripify/screens/login.dart';
import 'package:tripify/screens/signup.dart';
import 'package:tripify/services/shared_service.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  static const String routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        fontFamily: fontRegular,
        scaffoldBackgroundColor: bgColor,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              SystemNavigator.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pushReplacementNamed(context, Home.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Login as guest',
                    style: TextStyle(
                        color: Colors.lightBlue[800],
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: const WelcomePage(),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();
    SharedService.setNoFirstTime();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return SafeArea(
      child: Container(
        color: bgColor,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                const Text(
                  "Welcome",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Ready to Explore the Andamans? Login or Sign up for Tripify to Unlock Endless Possibilities!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Image.asset('assets/images/welcome_background.png'),),
            Column(
              children: <Widget>[
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pushNamed(context, LoginPage.routeName);
                  },
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 2, color: Color.fromRGBO(2, 119, 189, 1)),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        color: Color.fromRGBO(2, 119, 189, 1),
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pushNamed(context, SignupPage.routeName);
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
                          fontSize: 18),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: obscureText,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
