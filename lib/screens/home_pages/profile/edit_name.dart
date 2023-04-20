import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:tripify/animation/FadeAnimation.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/update_user_model.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/shared_service.dart';

class EditName extends StatefulWidget {
  static const String routeName = '/edit_name';
  const EditName({super.key});

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  bool isLoading = false;
  bool isApiCallProcess = false;
  bool isVisiblepw = false;
  String name = "";
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
            //height: MediaQuery.of(context).size.height - 20,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 90,
                  width: 90,
                  child:
                      FadeAnimation(1,randomAvatar(SharedService.name, height: 70, width: 70)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FadeAnimation(1.1,
                    Text(
                      '${SharedService.name} (Current name)',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FadeAnimation(1.2,
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
                          "Edit name",
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
                              hintText: 'Enter name',
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

                                  UpdateNameModel model = UpdateNameModel(
                                    name: name,
                                  );

                                  APIService.updateName(model).then(
                                    (response) {
                                      setState(() {
                                        isApiCallProcess = false;
                                      });

                                      if (response['success'].toString() ==
                                          'true') {
                                        SharedService.setUserName(name);
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
                                                  'Successfully updated name.',
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
                                      "Change name",
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
