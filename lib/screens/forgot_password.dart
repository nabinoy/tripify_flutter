import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/forgot_password_request_model.dart';
import 'package:tripify/router.dart';
import 'package:tripify/services/api_service.dart';

class ForgotPassword extends StatefulWidget {
  static const String routeName = '/forgotpassword';
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
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
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              color: bgColor,
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 90,
              padding: const EdgeInsets.fromLTRB(32, 40, 32, 80),
              //padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          width: 200,
                          height: 180,
                          child: Lottie.asset(
                            'assets/lottie/forgot_password.json',
                            animate: true,
                          ),
                        ),
                        const Text(
                          "Forgot Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Enter the email associated with your account and we'll send an email with instructions to reset your password.",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.black,
                            style: BorderStyle.solid,
                          ),
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.all(16),
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) => setState(() {
                        email = value;
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      if (_formKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {
                          isApiCallProcess = true;
                        });

                        ForgotPasswordRequestModel model =
                            ForgotPasswordRequestModel(
                          email: email,
                        );

                        APIService.forgotpassword(model).then(
                          (response) {
                            setState(() {
                              isApiCallProcess = false;
                            });

                            if (response) {
                              isLoading = false;
                            } else {
                              isLoading = false;
                            }
                          },
                        );
                      }
                    },
                    color: Colors.lightBlue[800],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Reset Password",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
