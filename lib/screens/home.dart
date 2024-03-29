import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/router.dart';
import 'package:tripify/screens/chatbot.dart';
import 'package:tripify/screens/drawer/helpline.dart';
import 'package:tripify/screens/drawer/translator.dart';
import 'package:tripify/screens/drawer/transport_service.dart';
import 'package:tripify/screens/home_pages/home_main.dart';
import 'package:tripify/screens/home_pages/profile.dart';
import 'package:tripify/screens/home_pages/wishlist.dart';
import 'package:tripify/screens/login.dart';
import 'package:tripify/screens/signup.dart';
import 'package:tripify/screens/weather_details.dart';
import 'package:tripify/services/shared_service.dart';

class Home extends StatelessWidget {
  static const String routeName = '/home';
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: const Homepage(),
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ignore: deprecated_member_use
        androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
        fontFamily: fontRegular,
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: bgColor,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late StreamSubscription subscription;

  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeMain(),
    const Wishlist(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future showDialogLocationAccess() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Alert',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        content: const Text(
          "Please enable location access for this app from your device settings. This will allow us to provide you with personalized location-based features and services.",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          MaterialButton(
            minWidth: double.infinity,
            elevation: 0,
            color: Colors.lightBlue[800],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () {
              AppSettings.openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Open settings',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void checkLocationAccess() async {
    PermissionStatus permissionGranted;
    Location loc = Location();

    permissionGranted = await loc.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      showDialogLocationAccess();
    }
  }

  Future<bool> readForFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'is_home_first_open';
    return prefs.getBool(key)??true;
  }

  Future<void> checkForFirst() async {
    final prefs = await SharedPreferences.getInstance();
    bool firstValue = false;
    await readForFirstTime().then((value) => firstValue = value);
    await prefs.setBool('is_home_first_open', false);
    if (!firstValue) {
      checkLocationAccess();
    }
  }

  @override
  void initState() {
    super.initState();
    SharedService.getSharedLogin();
    bool flag = false;
    checkForFirst();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await SharedService.getSessionExpire() == true) {
        SharedService.setSessionExpire(false);
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
              title: 'Session expired!',
              message: 'Your session has timed out. Please log in again.',
              contentType: ContentType.warning,
            ),
          ),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }

      if (await SharedService.getSharedHomeAfter() == true) {
        SharedService.setSharedHomeAfter(false);
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
              message:
                  'Welcome ${SharedService.name}, you have successfully logged in! Have a nice day!',
              contentType: ContentType.success,
            ),
          ),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    });

    Connectivity().checkConnectivity().then((result) {
      setState(() {
        if (result == ConnectivityResult.none && flag == false) {
          flag = true;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "No internet",
              style: TextStyle(fontFamily: fontRegular, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 3,
            ),
            duration: Duration(days: 1),
            backgroundColor: Colors.grey,
          ));
        }
      });
    });

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none && flag == false) {
        flag = true;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "No internet",
            style: TextStyle(fontFamily: fontRegular, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 3,
          ),
          duration: Duration(days: 1),
          backgroundColor: Colors.grey,
        ));
      } else if ((result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi ||
              result == ConnectivityResult.bluetooth ||
              result == ConnectivityResult.ethernet ||
              result == ConnectivityResult.vpn) &&
          flag == true) {
        flag = false;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Connected",
            style: TextStyle(fontFamily: fontRegular, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 3,
          ),
          backgroundColor: Colors.green,
        ));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

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
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          appName,
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.pushNamed(context, ChatBot.routeName);
            },
            child: const Icon(MdiIcons.forumOutline),
          ),
          const Padding(padding: EdgeInsets.all(8))
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(
              MdiIcons.home,
              size: 30,
            ),
            icon: Icon(
              MdiIcons.homeOutline,
              size: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.heartOutline,
              size: 30,
            ),
            activeIcon: Icon(
              MdiIcons.heart,
              size: 30,
            ),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.person,
              size: 30,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue[800],
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: DrawerHeader(
                    child: FutureBuilder(
                      future: SharedService.getSharedLogin(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return const DrawerItem();
                        } else {
                          return const LoadingScreen();
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            MdiIcons.weatherPartlyCloudy,
                            color: Colors.grey[800],
                            size: 30,
                          ),
                        ),
                        const Text('Weather'),
                      ],
                    ),
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pushNamed(
                        context,
                        WeatherDetails.routeName,
                        arguments: ['Current', 'Location'],
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.call,
                            color: Colors.grey[800],
                            size: 30,
                          ),
                        ),
                        const Text('Helpline'),
                      ],
                    ),
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pushNamed(
                        context,
                        Helpline.routeName,
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.emoji_transportation,
                            color: Colors.grey[800],
                            size: 30,
                          ),
                        ),
                        const Text('Transport service'),
                      ],
                    ),
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pushNamed(
                        context,
                        TransportService.routeName,
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.translate_outlined,
                            color: Colors.grey[800],
                            size: 30,
                          ),
                        ),
                        const Text('Translator'),
                      ],
                    ),
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pushNamed(
                        context,
                        TranslatorWebView.routeName,
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Divider(),
                FutureBuilder(
                  future: SharedService.getSharedLogin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return (SharedService.id == '')
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MaterialButton(
                                    minWidth: 120,
                                    height: 40,
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.pushNamed(
                                          context, LoginPage.routeName);
                                    },
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 2,
                                            color:
                                                Color.fromRGBO(2, 119, 189, 1)),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Color.fromRGBO(2, 119, 189, 1),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ),
                                  MaterialButton(
                                    minWidth: 120,
                                    height: 40,
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.pushNamed(
                                          context, SignupPage.routeName);
                                    },
                                    color: Colors.lightBlue[800],
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Text(
                                      "Sign up",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        MdiIcons.logout,
                                        color: Colors.grey[800],
                                        size: 30,
                                      ),
                                    ),
                                    const Text('Log out'),
                                  ],
                                ),
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  SharedService.setSharedLogOut();
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Home.routeName,
                                  );
                                },
                              ),
                            );
                    } else {
                      return const LoadingScreen();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.only(left: 8),
            child: randomAvatar(SharedService.name, height: 70, width: 70)),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            overflow: TextOverflow.ellipsis,
            SharedService.name,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            overflow: TextOverflow.ellipsis,
            SharedService.email,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
