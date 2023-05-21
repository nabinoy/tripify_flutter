import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/user_dashboard_model.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/shared_service.dart';

class FeedBack extends StatefulWidget {
  static const String routeName = '/feedback';
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  bool isLoading = false;
  bool isApiCallProcess = false;
  bool isVisiblepw = false;
  String description = "";
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(
                    height: 90,
                    width: 90,
                    child: randomAvatar(SharedService.name,
                        height: 70, width: 70)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    SharedService.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    SharedService.email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 100, 100, 100)),
                  ),
                ),
                const SizedBox(height: 20),
                const Column(
                  children: <Widget>[
                    Text(
                      "Feedback",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please write a review!';
                          }
                          return null;
                        },
                        maxLines: 10,
                        style: const TextStyle(fontSize: 16),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Write a feedback..',
                          hintStyle: const TextStyle(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
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
                          description = value;
                        }),
                      ),
                      const SizedBox(height: 20),
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

                              FeedBackModel model = FeedBackModel(
                                description: description,
                              );

                              APIService.submitFeedback(model).then(
                                (response) {
                                  setState(() {
                                    isApiCallProcess = false;
                                  });

                                  if (response['success'].toString() ==
                                      'true') {
                                    SharedService.setUserName(description);
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
                                          title: 'Thank you!',
                                          message:
                                              'Your feedback has been successfully submitted.',
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
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        'Error! Please try again!',
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 3,
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
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
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
