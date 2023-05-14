import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/animation/FadeAnimation.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/login_request_model.dart';
import 'package:tripify/screens/forgot_password.dart';
import 'package:tripify/screens/home.dart';
import 'package:tripify/screens/signup.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/shared_service.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
            //SystemNavigator.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: const LoginPageScreen(),
    );
  }
}

class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});

  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  bool isApiCallProcess = false;
  String email = "";
  String password = "";
  bool _isVisible = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const FadeAnimation(
                        1,
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 14,
                    ),
                    FadeAnimation(
                        1.2,
                        Text(
                          "Login to your account",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: FadeAnimation(
                            1.2,
                            TextFormField(
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
                        ),
                        FadeAnimation(
                          1.3,
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: !_isVisible,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isVisible = !_isVisible;
                                  });
                                },
                                icon: _isVisible
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                              ),
                              hintText: 'Password',
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
                              password = value;
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FadeAnimation(
                    1.3,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                            enableFeedback: false,
                            foregroundColor: Colors.lightBlue[800],
                            backgroundColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ForgotPassword.routeName);
                          },
                          child: const Text(
                            'Forgot password',
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 119, 189),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    )),
                FadeAnimation(
                    1.4,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            if (_formKey.currentState!.validate()) {
                              isLoading = true;
                              setState(() {
                                isApiCallProcess = true;
                              });

                              LoginRequestModel model = LoginRequestModel(
                                email: email,
                                password: password,
                              );

                              APIService.login(model).then(
                                (response) {
                                  setState(() {
                                    isApiCallProcess = false;
                                  });
                                  if (response) {
                                    SharedService.setSharedHomeAfter(true);
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      Home.routeName,
                                      (route) => false,
                                    );
                                  } else {
                                    isLoading = false;
                                    final snackBar = SnackBar(
                                      width: double.infinity,
                                      dismissDirection: DismissDirection.down,
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: DefaultTextStyle(
                                        style: const TextStyle(
                                          fontFamily: fontRegular,
                                        ),
                                        child: AwesomeSnackbarContent(
                                          title: 'Error!',
                                          message:
                                              'Email or password is incorrect, please try again!',
                                          contentType: ContentType.failure,
                                        ),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                  }
                                },
                              );
                            }
                          },
                          color: Colors.lightBlue[800],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                        ),
                      ),
                    )),
                FadeAnimation(
                    1.5,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Don't have an account?"),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            enableFeedback: false,
                            backgroundColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, SignupPage.routeName);
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Color.fromRGBO(2, 119, 189, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          FadeAnimation(
              1.2,
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/login_background.jpg'),
                        fit: BoxFit.cover)),
              ))
        ],
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
