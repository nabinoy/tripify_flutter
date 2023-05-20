import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:georange/georange.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/loader/loader_hotel_card.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/hotel_response_model.dart';
import 'package:tripify/models/nearby_request_model.dart';
import 'package:tripify/screens/home_services/hotel_details.dart';
import 'package:tripify/screens/search/search_hotel.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/services/shared_service.dart';

class HotelScreen extends StatefulWidget {
  static const String routeName = '/hotel';
  const HotelScreen({super.key});

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  GeoRange georange = GeoRange();
  List<Hotels> hd = [];
  List<Hotels> nearbyHd = [];
  List<IslandAll> ia = [];
  late Future dataFuture;
  late Future dataNearby;
  int page = 1;
  int isEndLoading = 1;
  int hotelCount = 1;
  final controller = ScrollController();
  String islandId = 'All';

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    NearbyModel model = NearbyModel(
        lat: currentLocation.latitude!.toString(),
        long: currentLocation.longitude!.toString(),
        maxRad: '3000');
    dataFuture = APIService.hotelCount().then((value) async => {
          hotelCount = value,
          await APIService.hotelAll().then((value) => {hd = value})
        });

    dataNearby =
        APIService.nearbyHotel(model).then((value) => {nearbyHd = value});
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch(islandId);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future fetch(String islandId) async {
    List<Hotels> temp = [];
    page++;
    if (islandId == 'All') {
      await APIService.allHotelPagination(page.toString())
          .then((value) => {temp = value});
      setState(() {
        hd.addAll(temp);
      });
    } else {
      await APIService.hotelPagination(islandId, page.toString())
          .then((value) => {temp = value});
      setState(() {
        hd.addAll(temp);
      });
    }
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
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 10, left: 16, right: 16, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${SharedService.name.split(' ').firstWhere((name) => name.length > 2)}',
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
                    page = 1;
                    isEndLoading = 1;
                    hd = [];
                    if (value == 0) {
                      islandId = 'All';
                      dataFuture =
                          APIService.hotelCount().then((value) async => {
                                hotelCount = value,
                                await APIService.hotelAll()
                                    .then((value) => {hd = value})
                              });
                      setState(() {});
                    } else {
                      islandId = ia[value - 1].sId;
                      dataFuture =
                          APIService.islandHotelCount(ia[value - 1].sId)
                              .then((value) async => {
                                    hotelCount = value,
                                    await APIService.hotelByIslandId(islandId)
                                        .then((value) => {hd = value})
                                  });
                      setState(() {});
                    }
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16, left: 16, top: 30),
              child: Text(
                'Hotels',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
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
                    if (hotelCount <= (page * hotelPageSize)) {
                      isEndLoading = 0;
                    }
                    return Container(
                      margin: const EdgeInsets.only(left: 20, top: 20),
                      height: 250,
                      child: ListView.builder(
                        controller: (isEndLoading == 0) ? null : controller,
                        itemCount: hd.length + isEndLoading,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index < hd.length) {
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                                          borderRadius:
                                              BorderRadius.circular(40),
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
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                          } else {
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
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
              margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
              width: double.infinity,
              child: const Text(
                "Near from you",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FutureBuilder(
              future: dataNearby,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (nearbyHd.isEmpty) {
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
                    return Column(
                      children: [
                        Wrap(
                          children: nearbyHd.map((widget) {
                            Point point1 = Point(
                                latitude: currentLocation.latitude!,
                                longitude: currentLocation.longitude!);
                            Point point2 = Point(
                                latitude: widget.location.coordinates[1],
                                longitude: widget.location.coordinates[0]);

                            var distance = georange.distance(point1, point2);
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, HotelDetailsPage.routeName,
                                    arguments: [widget]);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
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
                                          imageUrl:
                                              widget.images.first.secureUrl,
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
                                            widget.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .55,
                                          child: Text(widget.address.city,
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
                                            RatingBar.builder(
                                              initialRating:
                                                  widget.ratings.toDouble(),
                                              ignoreGestures: true,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 16,
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              widget.ratings.toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                            Text(
                                                ' (${widget.reviews.length} reviews)',
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black54)),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.lightBlue[700],
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                '${distance.toStringAsFixed(1)}km away',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ));
  }
}
