import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/screens/home.dart';
import 'package:tripify/screens/home_pages/profile/edit_name.dart';
import 'package:tripify/screens/home_pages/profile/edit_password.dart';
import 'package:tripify/screens/login.dart';
import 'package:tripify/screens/signup.dart';
import 'package:tripify/services/shared_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    SharedService.getSharedLogin();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: randomAvatar(SharedService.name, height: 70, width: 70),
          ),
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
              style: const TextStyle(color: Color.fromARGB(255, 100, 100, 100)),
            ),
          ),
          const SizedBox(height: 20),
          (SharedService.id == '')
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Please login/signup first to access your profile!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.lightBlue[800],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width * 0.4,
                            height: 40,
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              Navigator.pushNamed(context, LoginPage.routeName);
                            },
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 2,
                                    color: Color.fromRGBO(2, 119, 189, 1)),
                                borderRadius: BorderRadius.circular(50)),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  color: Color.fromRGBO(2, 119, 189, 1),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width * 0.4,
                            height: 40,
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              Navigator.pushNamed(
                                  context, SignupPage.routeName);
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
                                  fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            backgroundColor:
                                const Color.fromARGB(255, 240, 240, 240),
                            foregroundColor:
                                const Color.fromARGB(194, 0, 0, 0)),
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Navigator.pushNamed(context, EditName.routeName);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 20),
                            Expanded(child: Text('Edit name')),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            backgroundColor:
                                const Color.fromARGB(255, 240, 240, 240),
                            foregroundColor:
                                const Color.fromARGB(194, 0, 0, 0)),
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Navigator.pushNamed(context, EditPassword.routeName);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.lock_reset_outlined),
                            SizedBox(width: 20),
                            Expanded(child: Text('Change password')),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          backgroundColor:
                              const Color.fromARGB(255, 240, 240, 240),
                          foregroundColor: const Color.fromARGB(194, 0, 0, 0),
                        ),
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          SharedService.setSharedLogOut();
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
                                title: 'Successful!',
                                message: 'Successfully log out!',
                                contentType: ContentType.success,
                              ),
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Home.routeName,
                            (route) => false,
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 20),
                            Expanded(child: Text('Log out')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
