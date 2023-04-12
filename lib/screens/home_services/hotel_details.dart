import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/models/hotel_response_model.dart';

class HotelDetailsPage extends StatefulWidget {
  static const String routeName = '/hotel_details';
  const HotelDetailsPage({super.key});

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    Hotels hotel = arguments[0];
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                // padding: EdgeInsets.only(top: 20),
                margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
                width: double.infinity,
                height: 430,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        height: 430,
                        alignment: Alignment.bottomCenter,
                        imageUrl: hotel.images.first.secureUrl,
                        placeholder: (context, url) => Image.memory(
                          kTransparentImage,
                          fit: BoxFit.cover,
                        ),
                        fadeInDuration: const Duration(milliseconds: 200),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 15,
                      top: 15,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: 15,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: const Icon(
                          Icons.bookmark_border_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  hotel.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '${hotel.address.street},${hotel.address.city}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${hotel.address.state},${hotel.address.zip}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Colors.white.withOpacity(0.4),
                                          ),
                                          child: const Icon(
                                            Icons.bed,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        const Text(
                                          "4 Bedroom",
                                          style: TextStyle(
                                            color: Colors.white,
                                            // fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Colors.white.withOpacity(0.4),
                                          ),
                                          child: const Icon(
                                            Icons.bathroom,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        const Text(
                                          "3 Bathroom",
                                          style: TextStyle(
                                            color: Colors.white,
                                            // fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // description
              Container(
                // color: Colors.amber,
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 25, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    Text(
                      hotel.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: Colors.black54,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // owner hotel
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://api.lorem.space/image/face?w=150&h=150',
                        ),
                      ),
                    ),
                    // child: Image(
                    //   fit: BoxFit.cover,
                    //   image: NetworkImage(
                    //       'https://api.lorem.space/image/face?w=150&h=150'),
                    // ),
                  ),
                  title: Text(
                    hotel.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: const Text('Owner'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.mail_outline,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rooms:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    ...hotel.rooms.map<Widget>((room) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Room Type: ${room.roomType}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.0),
                          Text('Description: ${room.description}'),
                          SizedBox(height: 4.0),
                          Text('Price: ${room.price}'),
                          SizedBox(height: 4.0),
                          Text('Max Occupancy: ${room.maxOccupancy}'),
                          SizedBox(height: 4.0),
                          Text('Amenities:'),
                          ...room.amenities
                              .map((amenity) => Text('- $amenity'))
                              .toList(),
                          SizedBox(height: 16.0),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              // gallery
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Text(
                        'Gallery',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: hotel.images
                            .map(
                              (item) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 160,
                                height: 160,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    height: 430,
                                    alignment: Alignment.bottomCenter,
                                    imageUrl: item.secureUrl,
                                    placeholder: (context, url) => Image.memory(
                                      kTransparentImage,
                                      fit: BoxFit.cover,
                                    ),
                                    fadeInDuration:
                                        const Duration(milliseconds: 200),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Text(
                        'Reviews',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  // height: 50,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, -19),
                        spreadRadius: -5,
                        blurRadius: 22,
                        color: Color.fromRGBO(255, 246, 246, 1),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Book Now',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff3dc1fd), Color(0xff8bdafe)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
