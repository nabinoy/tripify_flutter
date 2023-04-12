import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/home_main_model.dart';
import 'package:tripify/models/hotel_response_model.dart';
import 'package:tripify/screens/home_services/hotel_details.dart';
import 'package:tripify/services/api_service.dart';

class HotelScreen extends StatefulWidget {
  static const String routeName = '/hotel';
  const HotelScreen({super.key});

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  List<Hotels> hd = [];
  List<IslandAll> ia = [];
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
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: FutureBuilder(
        future: APIService.hotelAll().then((value) => {hd = value}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: [
                // header text
                Container(
                  height: 100,
                  // color: Colors.grey,
                  padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Location",
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  "Demo, Name",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.arrow_upward,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Icon(
                        Icons.notifications_none_outlined,
                        size: 30,
                      ),
                    ],
                  ),
                ),

                // textfield search
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 80,
                  // color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 290,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search address, or near you",
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black38,
                            ),
                            filled: true,
                            fillColor:
                                Colors.lightBlue.shade200.withOpacity(0.1),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 30,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff3dc1fd), Color(0xff8bdafe)],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.list,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  width: double.infinity,
                  height: 40,
                  // color: Colors.black,
                  child: DefaultTabController(
                    length: ia.length + 1,
                    child: TabBar(
                      unselectedLabelStyle:
                          const TextStyle(fontWeight: FontWeight.w100),
                      labelPadding: const EdgeInsets.only(right: 20),
                      physics: const BouncingScrollPhysics(),
                      isScrollable: true,
                      indicatorColor: Colors.transparent,
                      tabs: List.generate(
                        ia.length + 1,
                        (index) => (index == 0)
                            ? Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(5),
                                width: 70,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff3dc1fd),
                                      Color(0xff8bdafe)
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'All',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: fontRegular),
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(5),
                                width: 140,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff3dc1fd),
                                      Color(0xff8bdafe)
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  ia[index - 1].name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: fontRegular),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All places',
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

                // images hotel
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
                  // width: 100,
                  height: 250,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    // padding: EdgeInsets.only(right: 50),
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, HotelDetailsPage.routeName,
                              arguments: [hd.first]);
                        },
                        child: Container(
                          width: 250,
                          height: 250,
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            // color: Colors.green,
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.1),
                                  BlendMode.darken,
                                ),
                                image: NetworkImage(
                                    hd.first.images.first.secureUrl)),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 15,
                                right: 15,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 90,
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
                                    children: const [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '1.8 km',
                                        style: TextStyle(
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        hd.first.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 23,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Jl. Sultan Iskandar Muda",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 250,
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          // color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.1),
                              BlendMode.darken,
                            ),
                            image: const AssetImage(
                              'assets/images/home-2.jpg',
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 15,
                              right: 15,
                              child: Container(
                                alignment: Alignment.center,
                                width: 90,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: const [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '1.8 km',
                                      style: TextStyle(
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "Indonesian House",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 23,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Jl. Ki Lurah Dullah",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 250,
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          // color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.1),
                              BlendMode.darken,
                            ),
                            image: const AssetImage(
                              'assets/images/home-3.jpg',
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 15,
                              right: 15,
                              child: Container(
                                alignment: Alignment.center,
                                width: 90,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: const [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '1.8 km',
                                      style: TextStyle(
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "The Big Villa",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 23,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Jl. Pahlawan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
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
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ListTile(
                    title: const Text(
                      'Orchad House',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '₹2,500 / Day',
                            style: TextStyle(
                              fontSize: 13,
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
                      height: 90,
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
                          image: NetworkImage(hd.first.images.first.secureUrl),
                        ),
                      ),
                    ),
                  ),
                ),

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
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
