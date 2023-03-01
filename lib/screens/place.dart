import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/place_model.dart';
import 'package:tripify/router.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/services/shared_service.dart';
import 'package:tripify/widget/direction_map.dart';

import '../loader/loader_home_main.dart';

class PlaceCategoryTop extends SliverPersistentHeaderDelegate {
  final ValueChanged<int> onChanged;
  final int selectedIndex;

  PlaceCategoryTop({required this.onChanged, required this.selectedIndex});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 52,
      color: Colors.white,
      child: PlaceCategory(
        onChanged: onChanged,
        selectedIndex: selectedIndex,
      ),
    );
  }

  @override
  double get maxExtent => 52;

  @override
  double get minExtent => 52;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class Place extends StatefulWidget {
  const Place({super.key});
  static const String routeName = '/place';

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PlaceDetails(),
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

class PlaceDetails extends StatefulWidget {
  const PlaceDetails({super.key});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  late StreamSubscription subscription;
  ValueNotifier<double> distance = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      SharedService.getSharedDistance();
      distance.value = SharedService.distance;
    });
    bool flag = false;

    // subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   if (result == ConnectivityResult.none && flag == false) {
    //     flag = true;
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text(
    //         "No internet",
    //         style: TextStyle(fontFamily: fontRegular, fontSize: 12),
    //         textAlign: TextAlign.center,
    //       ),
    //       padding: EdgeInsets.symmetric(
    //         vertical: 3,
    //       ),
    //       duration: Duration(days: 1),
    //       backgroundColor: Colors.grey,
    //     ));
    //   } else if ((result == ConnectivityResult.mobile ||
    //           result == ConnectivityResult.wifi ||
    //           result == ConnectivityResult.bluetooth ||
    //           result == ConnectivityResult.ethernet ||
    //           result == ConnectivityResult.vpn) &&
    //       flag == true) {
    //     flag = false;
    //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text(
    //         "Connected",
    //         style: TextStyle(fontFamily: fontRegular, fontSize: 12),
    //         textAlign: TextAlign.center,
    //       ),
    //       padding: EdgeInsets.symmetric(
    //         vertical: 3,
    //       ),
    //       backgroundColor: Colors.green,
    //     ));
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      body: FutureBuilder(
          future: Future.wait([]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    expandedHeight: 300,
                    pinned: true,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        'https://images.unsplash.com/photo-1473116763249-2faaef81ccda?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1196&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    actions: const [
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            MdiIcons.heartOutline,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      height: 200,
                      child: const Text('This is Container'),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: PlaceCategoryTop(
                        onChanged: (value) {}, selectedIndex: 0),
                    pinned: true,
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.tealAccent,
                      alignment: Alignment.center,
                      height: 200,
                      child: const Text('This is Container2'),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.tealAccent,
                      alignment: Alignment.center,
                      height: 200,
                      child: const Text('This is Container3'),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.tealAccent,
                      alignment: Alignment.center,
                      height: 200,
                      child: const Text('This is Container4'),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.blue,
                      alignment: Alignment.center,
                      height: 200,
                      child: const Text('This is Container5'),
                    ),
                  ),
                ],
              );

              // return SingleChildScrollView(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //     child: Column(
              //       children: [
              //         ValueListenableBuilder(
              //           valueListenable: distance,
              //           builder: (context, value, child) {
              //             return Text(
              //                 'Distance ${distance.value.toStringAsFixed(2)}km');
              //           },
              //         ),
              //         SizedBox(
              //           height: screenWidth * 0.8,
              //           width: screenWidth,
              //           child: FutureBuilder(
              //               future: Future.wait([
              //                 getCurrentLocation(),
              //               ]),
              //               builder: (builder, snapshot) {
              //                 if (snapshot.connectionState ==
              //                     ConnectionState.done) {
              //                   return ClipRRect(
              //                       borderRadius: BorderRadius.circular(15.0),
              //                       child: const DirectionMap());
              //                 } else {
              //                   return Container(
              //                     color: Colors.white,
              //                     child: const Center(
              //                       child: CircularProgressIndicator(),
              //                     ),
              //                   );
              //                 }
              //               }),
              //         ),
              //       ],
              //     ),
              //   ),
              // );
            } else {
              return const LoaderHomeMain();
            }
          }),
    );
  }
}

class PlaceCategory extends StatefulWidget {
  const PlaceCategory({
    Key? key,
    required this.onChanged,
    required this.selectedIndex,
  }) : super(key: key);

  final ValueChanged<int> onChanged;
  final int selectedIndex;

  @override
  State<PlaceCategory> createState() => _PlaceCategoryState();
}

class _PlaceCategoryState extends State<PlaceCategory> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(
              PlaceModel.placeCategory.length,
              (index) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          foregroundColor: widget.selectedIndex == index
                              ? Colors.black
                              : Colors.black45),
                      child: Text(
                        PlaceModel.placeCategory[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ))),
    );
  }
}
