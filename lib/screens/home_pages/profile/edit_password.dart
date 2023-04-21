import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:tripify/animation/FadeAnimation.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/update_user_model.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/shared_service.dart';

class EditPassword extends StatefulWidget {
  static const String routeName = '/edit_password';
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  bool isLoading = false;
  bool isApiCallProcess = false;
  bool _isVisible = false;
  bool isVisiblepw = false;
  String password = "";
  String oldPassword = "";
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 90,
                  width: 90,
                  child: FadeAnimation(1,
                      randomAvatar(SharedService.name, height: 70, width: 70)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FadeAnimation(
                    1.1,
                    Text(
                      SharedService.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FadeAnimation(
                    1.2,
                    Text(
                      SharedService.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 100, 100, 100)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: const <Widget>[
                    FadeAnimation(
                        1.3,
                        Text(
                          "Change password",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: FadeAnimation(
                          1.4,
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
                              hintText: 'Old password',
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
                              oldPassword = value;
                            }),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: FadeAnimation(
                          1.5,
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
                              hintText: 'New password',
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
                          1.6,
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
                          1.7,
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

                                  UpdatePasswordModel model =
                                      UpdatePasswordModel(
                                          oldPassword: oldPassword,
                                          password: password);

                                  APIService.updatePassword(model).then(
                                    (response) {
                                      setState(() {
                                        isApiCallProcess = false;
                                      });

                                      if (response['success'].toString() ==
                                          'true') {
                                        //SharedService.setUserName(name);
                                        isLoading = false;
                                        final snackBar = SnackBar(
                                          width: double.infinity,
                                          dismissDirection:
                                              DismissDirection.down,
                                          elevation: 0,
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          content: DefaultTextStyle(
                                            style: const TextStyle(
                                              fontFamily: fontRegular,
                                            ),
                                            child: AwesomeSnackbarContent(
                                              title: 'Successful!',
                                              message:
                                                  'Successfully updated password.',
                                              contentType: ContentType.success,
                                            ),
                                          ),
                                        );
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(snackBar);
                                        setState(() {});
                                        Navigator.pop(context);
                                      } else {
                                        isLoading = false;
                                        final snackBar = SnackBar(
                                          width: double.infinity,
                                          dismissDirection:
                                              DismissDirection.down,
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
                                      "Change password",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}