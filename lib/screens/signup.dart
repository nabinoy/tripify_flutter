import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:tripify/animation/FadeAnimation.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/signup_request_model.dart';
import 'package:tripify/screens/otp_form.dart';
import 'package:tripify/screens/login.dart';
import 'package:tripify/services/api_service.dart';

class SignupPage extends StatelessWidget {
  static const String routeName = '/signup';
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: const SignupPageScreen(),
    );
  }
}

class SignupPageScreen extends StatefulWidget {
  const SignupPageScreen({super.key});

  @override
  State<SignupPageScreen> createState() => _SignupPageScreenState();
}

class _SignupPageScreenState extends State<SignupPageScreen> {
  bool isLoading = false;
  bool isApiCallProcess = false;
  bool _isVisible = false;
  bool isVisiblepw = false;
  String name = "";
  String email = "";
  String password = "";
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
        height: MediaQuery.of(context).size.height - 20,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                const FadeAnimation(
                    1,
                    Text(
                      "Sign up",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 14,
                ),
                FadeAnimation(
                    1.2,
                    Text(
                      "Create an account, It's free",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: FadeAnimation(
                      1.1,
                      TextFormField(
                        onTap: () {
                          isVisiblepw = false;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Name',
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
                          name = value;
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: FadeAnimation(
                      1.2,
                      TextFormField(
                        onTap: () {
                          isVisiblepw = false;
                        },
                        validator: (value) {
                          final bool isValid = EmailValidator.validate(email);
                          if (!isValid && value != null && value.isNotEmpty) {
                            return 'Please enter a valid email';
                          }
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: FadeAnimation(
                      1.3,
                      TextFormField(
                        onTap: () {
                          isVisiblepw = true;
                        },
                        controller: pass,
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
                  ),
                  Visibility(
                    visible: isVisiblepw,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FlutterPwValidator(
                        controller: pass,
                        minLength: 8,
                        uppercaseCharCount: 1,
                        numericCharCount: 3,
                        specialCharCount: 1,
                        width: 400,
                        height: 140,
                        onSuccess: () {
                          isVisiblepw = false;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: FadeAnimation(
                      1.4,
                      TextFormField(
                        controller: confirmPass,
                        onTap: () {
                          isVisiblepw = false;
                        },
                        validator: (value) {
                          if (value != pass.text &&
                              value != null &&
                              value.isNotEmpty) {
                            return 'Password not matched';
                          }
                          if (value == null || value.isEmpty) {
                            return 'Please confirm password';
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
                          hintText: 'Confirm Password',
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
                      ),
                    ),
                  ),
                  FadeAnimation(
                      1.5,
                      Container(
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

                              SignupRequestModel model = SignupRequestModel(
                                name: name,
                                password: password,
                                email: email,
                              );

                              APIService.signup(model).then(
                                (response) {
                                  setState(() {
                                    isApiCallProcess = false;
                                  });
                                  if (response['notVerified'] ==
                                      true) {
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
                                          title: 'Warning!',
                                          message: 'User with $email is already in our database but it is not verified. Please verify this email.',
                                          contentType: ContentType.warning,
                                        ),
                                      ),
                                    );
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                    Navigator.pushNamed(
                                        context, OtpForm.routeName,
                                        arguments: email);
                                  }

                                  if (response['success'].toString() ==
                                      'true') {
                                    Navigator.pushNamed(
                                        context, OtpForm.routeName,
                                        arguments: email);
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
                                          title: 'Warning!',
                                          message: response['message'],
                                          contentType: ContentType.warning,
                                        ),
                                      ),
                                    );
                                    // ignore: use_build_context_synchronously
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
                                  "Sign up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                        ),
                      )),
                  FadeAnimation(
                      1.6,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Already have an account?"),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                  context, LoginPage.routeName);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Color.fromRGBO(2, 119, 189, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
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
