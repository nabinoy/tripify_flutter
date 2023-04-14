import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/hotel_response_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HotelDetailsPage extends StatefulWidget {
  static const String routeName = '/hotel_details';
  const HotelDetailsPage({super.key});

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void _launchEmail(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(params);
  }

  void _launchWeb(String website) async {
    // final Uri params = Uri(
    //   scheme: 'https',
    //   host: website,
    // );
    await launchUrl(Uri.parse(website), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    Hotels hotel = arguments[0];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          hotel.name,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                width: double.infinity,
                height: 330,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        height: 330,
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${hotel.address.state},${hotel.address.zip}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          alignment: Alignment.bottomCenter,
                          imageUrl: hotel.images.first.secureUrl,
                          placeholder: (context, url) => Image.memory(
                            kTransparentImage,
                            fit: BoxFit.cover,
                          ),
                          fadeInDuration: const Duration(milliseconds: 200),
                          fit: BoxFit.cover,
                        ),
                      )),
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
                      GestureDetector(
                        onTap: () {
                          _makePhoneCall(hotel.contact.phone);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 5),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _launchEmail(hotel.contact.email);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 5),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.mail_outline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Check-in Time',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                hotel.checkinTime,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 30),
                          Column(
                            children: [
                              const Text(
                                'Check-out Time',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                hotel.checkoutTime,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                    const Text(
                      'Rooms:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    ...hotel.rooms.map<Widget>((room) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2.0,
                              blurRadius: 5.0,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150.0,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://via.placeholder.com/150'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .6,
                                        child: Text(
                                          room.roomType,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Quantity: ${room.beds.quantity.toString()}',
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    room.description,
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    'Amenities:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Wrap(
                                    children: room.amenities
                                        .map((amenity) => Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: Colors.lightBlue[100],
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 9, vertical: 5),
                                            margin: const EdgeInsets.all(4),
                                            child: Text(
                                              amenity,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            )))
                                        .toList(),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${room.price.toString()}',
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          color:
                                              Color.fromARGB(255, 76, 175, 119),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.people,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 5.0),
                                          Text(
                                              'Max Occupancy: ${room.maxOccupancy}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       'Room Type: ${room.roomType}',
                      //       style: const TextStyle(fontWeight: FontWeight.bold),
                      //     ),
                      //     const SizedBox(height: 4.0),
                      //     Text('Description: ${room.description}'),
                      //     const SizedBox(height: 4.0),
                      //     Text('Price: ${room.price}'),
                      //     const SizedBox(height: 4.0),
                      //     Text('Max Occupancy: ${room.maxOccupancy}'),
                      //     const SizedBox(height: 4.0),

                      //     const SizedBox(height: 16.0),
                      //   ],
                      // );
                    }).toList(),
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
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
          Positioned(
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
                child: GestureDetector(
                  onTap: () {
                    _launchWeb(hotel.contact.website);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.lightBlue,
                          Color.fromARGB(255, 76, 182, 231)
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      'Book Now',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
