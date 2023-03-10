import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/animation/FadeAnimation.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/router.dart';
import 'package:tripify/screens/login.dart';
import 'package:tripify/screens/signup.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  static const String routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        fontFamily: fontRegular,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () async {
              HapticFeedback.mediumImpact();
              SystemNavigator.pop();
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
        //padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                const FadeAnimation(
                    1,
                    Text(
                      "Welcome",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    )),
                const SizedBox(
                  height: 20,
                ),
                FadeAnimation(
                    1.2,
                    Text(
                      "Automatic identity verification which enables you to verify your identity",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    )),
              ],
            ),
            FadeAnimation(
                1.4,
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/illustration.png'))),
                )),
            Column(
              children: <Widget>[
                FadeAnimation(
                    1.5,
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
                    )),
                const SizedBox(
                  height: 20,
                ),
                FadeAnimation(
                    1.6,
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
                    ))
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
