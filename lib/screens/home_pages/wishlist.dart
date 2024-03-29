import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/screens/login.dart';
import 'package:tripify/screens/place.dart';
import 'package:tripify/screens/signup.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/shared_service.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
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
    List<Places2> pd = [];
    List<String> wishlistPlaceIdList = [];
    String message = '';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: const Text(
                    'Your wishlist',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: Future.wait([
                APIService.userWishlist().then((value) => {pd.addAll(value)}),
                APIService.checkUserWishlist()
                    .then((value) => {wishlistPlaceIdList.addAll(value)}),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return (SharedService.id == '')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(40),
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Lottie.asset(
                                'assets/lottie/login_wishlist.json',
                                animate: true,
                                frameRate: FrameRate.max,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Please login/signup first to access your wishlist!',
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
                                    minWidth:
                                        MediaQuery.of(context).size.width * 0.4,
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
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: MaterialButton(
                                    minWidth:
                                        MediaQuery.of(context).size.width * 0.4,
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
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      : (pd.isEmpty)
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.65,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 250,
                                    child: Lottie.asset(
                                      'assets/lottie/empty_wishlist.json',
                                      animate: true,
                                      frameRate: FrameRate.max,
                                    ),
                                  ),
                                  Text(
                                    'Your wishlist is empty!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: pd.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2.0,
                                          blurRadius: 5.0,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      color: Colors.white,
                                    ),
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: CachedNetworkImage(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .25,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .25,
                                              imageUrl: pd[index]
                                                  .images
                                                  .first
                                                  .secureUrl,
                                              placeholder: (context, url) =>
                                                  Image.memory(
                                                kTransparentImage,
                                                fit: BoxFit.cover,
                                              ),
                                              fadeInDuration: const Duration(
                                                  milliseconds: 200),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .55,
                                              child: Text(
                                                pd[index].name,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .55,
                                              child: Text(
                                                  pd[index].address.city,
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                MaterialButton(
                                                  elevation: 0,
                                                  onPressed: () {
                                                    Navigator.pushNamed(context,
                                                        Place.routeName,
                                                        arguments: [
                                                          [pd[index]],
                                                          (wishlistPlaceIdList
                                                                  .contains(
                                                                      pd[index]
                                                                          .sId))
                                                              ? true
                                                              : false
                                                        ]);
                                                  },
                                                  color: Colors.lightBlue[600],
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: const Row(
                                                    children: [
                                                      Text(
                                                        'Visit',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .arrow_forward_sharp,
                                                        size: 16,
                                                        color: Colors.white,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                MaterialButton(
                                                  elevation: 0,
                                                  onPressed: () {
                                                    APIService
                                                            .deleteFromWishlist(
                                                                pd[index].sId)
                                                        .then((value) {
                                                      message = value;
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                          message,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  fontRegular,
                                                              fontSize: 12),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 3,
                                                        ),
                                                        backgroundColor:
                                                            Colors.blue,
                                                      ));
                                                      setState(() {});
                                                    });
                                                  },
                                                  color: Colors.red[400],
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
