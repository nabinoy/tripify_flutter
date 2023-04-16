import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/loader/loader_hotel_card.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/hotel_response_model.dart';
import 'package:tripify/screens/home_services/hotel_details.dart';
import 'package:tripify/screens/search_hotel.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/shared_service.dart';

class HotelScreen extends StatefulWidget {
  static const String routeName = '/hotel';
  const HotelScreen({super.key});

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  List<Hotels> hd = [];
  List<IslandAll> ia = [];
  late Future dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = APIService.hotelAll().then((value) => {hd = value});
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    ia = arguments[0] as List<IslandAll>;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          centerTitle: true,
          title: const Text(
            "Hotel",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        body: ListView(
          children: [
            // header text
            Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 16, right: 16, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${SharedService.name.split(' ').firstWhere((name) => name.length > 2)}',
                    //' ${SharedService.name}',
                    style:
                        const TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Looking for a hotel?",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.lightBlue[800],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SearchHotel.routeName);
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade200.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      const Icon(Icons.search_outlined,
                          color: Color.fromARGB(221, 55, 55, 55)),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * .0145),
                        height: MediaQuery.of(context).size.height * .06,
                        child: const Text(
                          'Search Hotels',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
              width: double.infinity,
              height: 40,
              child: DefaultTabController(
                length: ia.length + 1,
                child: TabBar(
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.w100),
                  physics: const BouncingScrollPhysics(),
                  isScrollable: true,
                  indicatorPadding: const EdgeInsets.symmetric(vertical: 3),
                  indicatorColor: Colors.lightBlue,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: List.generate(
                      ia.length + 1,
                      (index) => (index == 0)
                          ? const Text(
                              'All',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily: fontRegular),
                            )
                          : Text(
                              ia[index - 1].name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily: fontRegular),
                            )),
                  onTap: (value) {
                    if (value == 0) {
                      dataFuture =
                          APIService.hotelAll().then((value) => {hd = value});
                      setState(() {});
                    } else {
                      dataFuture = APIService.hotelByIslandId(ia[value - 1].sId)
                          .then((value) => {hd = value});
                      setState(() {});
                    }
                  },
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(right: 16, left: 16, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hotels',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'See more',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            FutureBuilder(
              future: dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (hd.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 85),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.alertCircleOutline,
                            size: 58,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hotels found!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.only(left: 20, top: 20),
                      // width: 100,
                      height: 250,
                      child: ListView.builder(
                        itemCount: hd.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, HotelDetailsPage.routeName,
                                  arguments: [hd[index]]);
                            },
                            child: Container(
                              width: 250,
                              height: 250,
                              margin: const EdgeInsets.only(right: 20),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      height: 330,
                                      alignment: Alignment.bottomCenter,
                                      imageUrl:
                                          hd[index].images.first.secureUrl,
                                      placeholder: (context, url) =>
                                          Image.memory(
                                        kTransparentImage,
                                        fit: BoxFit.cover,
                                      ),
                                      fadeInDuration:
                                          const Duration(milliseconds: 200),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 100.0),
                                    height: 330,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          Colors.black.withOpacity(0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 15,
                                    right: 15,
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            hd[index].ratings.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: SizedBox(
                                            width: 210,
                                            child: Text(
                                              hd[index].name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 23,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            SizedBox(
                                              width: 180,
                                              child: Text(
                                                hd[index].address.city,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else {
                  return const LoaderHotelCard();
                }
              },
            ),

            Container(
              margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
              width: double.infinity,
              height: 50,
              // color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Near from you",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'See more',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // image list tile
            // Container(
            //   margin: const EdgeInsets.only(bottom: 20),
            //   child: ListTile(
            //     title: const Text(
            //       'Orchad House',
            //       style: TextStyle(
            //         fontWeight: FontWeight.w500,
            //         fontSize: 16,
            //       ),
            //     ),
            //     subtitle: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 4),
            //           child: Text(
            //             '₹2,500 / Day',
            //             style: TextStyle(
            //               fontSize: 13,
            //               color: Colors.lightBlue.withOpacity(0.7),
            //             ),
            //           ),
            //         ),
            //         Row(
            //           // mainAxisAlignment: MainAxisAlignment.,
            //           children: [
            //             Row(
            //               children: const [
            //                 Icon(Icons.bed),
            //                 Padding(
            //                   padding: EdgeInsets.only(left: 5),
            //                   child: Text('6 Bedroom'),
            //                 ),
            //               ],
            //             ),
            //             Container(
            //               margin: const EdgeInsets.only(left: 10),
            //               child: Row(
            //                 children: const [
            //                   Icon(Icons.bathroom),
            //                   Padding(
            //                     padding: EdgeInsets.only(left: 5),
            //                     child: Text('3 Bathroom'),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         )
            //       ],
            //     ),
            //     isThreeLine: true,
            //     leading: Container(
            //       height: 90,
            //       width: 90,
            //       decoration: BoxDecoration(
            //         color: Colors.lightBlue,
            //         borderRadius: BorderRadius.circular(10),
            //         image: DecorationImage(
            //           colorFilter: ColorFilter.mode(
            //             Colors.black.withOpacity(0.2),
            //             BlendMode.darken,
            //           ),
            //           fit: BoxFit.cover,
            //           image: NetworkImage(hd.first.images.first.secureUrl),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                title: const Text(
                  'Open House',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Rp. 2.500.000.000 / Year',
                        style: TextStyle(
                          color: Colors.lightBlue.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.bed),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('6 Bedroom'),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: const [
                              Icon(Icons.bathroom),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text('3 Bathroom'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                isThreeLine: true,
                leading: Container(
                  height: 200,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2),
                        BlendMode.darken,
                      ),
                      fit: BoxFit.cover,
                      image: const AssetImage('assets/images/home-8.jpg'),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                title: const Text(
                  'Majapahit House',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Rp. 2.500.000.000 / Year',
                        style: TextStyle(
                          color: Colors.lightBlue.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.bed),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('6 Bedroom'),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: const [
                              Icon(Icons.bathroom),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text('3 Bathroom'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                isThreeLine: true,
                leading: Container(
                  height: 200,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2),
                        BlendMode.darken,
                      ),
                      fit: BoxFit.cover,
                      image: const AssetImage('assets/images/home-6.jpg'),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                title: const Text(
                  'Charis House',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Rp. 2.500.000.000 / Year',
                        style: TextStyle(
                          color: Colors.lightBlue.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.bed),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('6 Bedroom'),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: const [
                              Icon(Icons.bathroom),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text('3 Bathroom'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                isThreeLine: true,
                leading: Container(
                  height: 200,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2),
                        BlendMode.darken,
                      ),
                      fit: BoxFit.cover,
                      image: const AssetImage('assets/images/home-7.jpg'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
