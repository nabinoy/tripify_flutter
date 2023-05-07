import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/loader/loader_review_all.dart';
import 'package:tripify/loader/loader_review_user.dart';
import 'package:tripify/models/hotel_response_model.dart';
import 'package:tripify/models/review_rating_model.dart';
import 'package:tripify/models/user_hotel_review_model.dart';
import 'package:tripify/models/weather_model.dart';
import 'package:tripify/screens/review_all.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/services/shared_service.dart';
import 'package:tripify/widget/direction_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

late Hotels currentHotel;

class HotelDetailsPage extends StatefulWidget {
  static const String routeName = '/hotel_details';
  const HotelDetailsPage({super.key});

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  ReviewUser ru = ReviewUser.fromJson({
    "user": "",
    "name": "",
    "rating": 0,
    "comment": "",
    "sentiment": "",
    "_id": "",
    "date": ""
  });

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
    await launchUrl(Uri.parse(website), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    Hotels hotel = arguments[0];
    weatherLatAPI = hotel.location.coordinates[1].toString();
    weatherLongAPI = hotel.location.coordinates[0].toString();
    currentHotel = hotel;
    late ReviewRatings r;
    double userRating = 0;
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
                                '${hotel.address.street}, ${hotel.address.city}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${hotel.address.state}, ${hotel.address.zip}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // Container(
                              //   margin: const EdgeInsets.only(top: 20),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.center,
                              //         children: [
                              //           Container(
                              //             margin:
                              //                 const EdgeInsets.only(right: 10),
                              //             width: 30,
                              //             height: 30,
                              //             decoration: BoxDecoration(
                              //               borderRadius:
                              //                   BorderRadius.circular(10),
                              //               color:
                              //                   Colors.white.withOpacity(0.4),
                              //             ),
                              //             child: const Icon(
                              //               Icons.bed,
                              //               color: Colors.white,
                              //               size: 20,
                              //             ),
                              //           ),
                              //           const Text(
                              //             "4 Bedroom",
                              //             style: TextStyle(
                              //               color: Colors.white,
                              //               // fontWeight: FontWeight.w400,
                              //               fontSize: 14,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       const SizedBox(
                              //         width: 30,
                              //       ),
                              //       Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.center,
                              //         children: [
                              //           Container(
                              //             margin:
                              //                 const EdgeInsets.only(right: 10),
                              //             width: 30,
                              //             height: 30,
                              //             decoration: BoxDecoration(
                              //               borderRadius:
                              //                   BorderRadius.circular(10),
                              //               color:
                              //                   Colors.white.withOpacity(0.4),
                              //             ),
                              //             child: const Icon(
                              //               Icons.bathroom,
                              //               color: Colors.white,
                              //               size: 20,
                              //             ),
                              //           ),
                              //           const Text(
                              //             "3 Bathroom",
                              //             style: TextStyle(
                              //               color: Colors.white,
                              //               // fontWeight: FontWeight.w500,
                              //               fontSize: 14,
                              //             ),
                              //           ),
                              //         ],
                              //       )
                              //     ],
                              //   ),
                              // ),
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
                    ExpandableText(
                      hotel.description,
                      animation: true,
                      expandText: 'show more',
                      collapseText: 'show less',
                      maxLines: 5,
                      linkColor: Colors.blue,
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 25, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Facilities',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      children: hotel.facilities.map((facility) {
                        return Card(
                          color: Colors.lightBlue[200],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(facility,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rooms',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 23),
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
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      hotelRoomTypeImages[room.roomType]!),
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
                                                .8,
                                        child: Text(
                                          room.roomType,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                    'Bed type',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            hotelBedIcons[room.beds.bedType],
                                            color: Colors.lightBlue[800],
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            room.beds.bedType,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          )
                                        ],
                                      ),
                                      Text(
                                        'Quantity: ${room.beds.quantity.toString()}',
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    'Amenities',
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
                    }).toList(),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Direction',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 23,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder(
                      future: Future.wait([
                        getCurrentLocation(),
                      ]),
                      builder: (builder, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: const DirectionMap());
                        } else {
                          return Container(
                            color: Colors.white,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      }),
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
                              (item) => GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: CachedNetworkImage(
                                          height: 430,
                                          alignment: Alignment.bottomCenter,
                                          imageUrl: item.secureUrl,
                                          placeholder: (context, url) =>
                                              Image.memory(
                                            kTransparentImage,
                                            fit: BoxFit.cover,
                                          ),
                                          fadeInDuration:
                                              const Duration(milliseconds: 200),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 160,
                                  height: 160,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      height: 430,
                                      alignment: Alignment.bottomCenter,
                                      imageUrl: item.secureUrl,
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
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 16, top: 8),
                    child: Text(
                      'Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 23,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    child: ListTile(
                      leading: SizedBox(
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
                      subtitle: const Text('Hotel'),
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
                ],
              ),

              (SharedService.id.isEmpty)
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rate this place',
                            style: TextStyle(
                              fontSize: 23,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RatingBar.builder(
                                initialRating: ru.rating.toDouble(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.blue,
                                ),
                                onRatingUpdate: (rating) {
                                  userRating = rating;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width - 200,
                              height: 40,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Alert'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    content: const Text(
                                        "Please login with your email first!"),
                                    actions: <Widget>[
                                      MaterialButton(
                                        minWidth: double.infinity,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                              color: Colors.lightBlue[800]),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              color: Colors.lightBlue[800],
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Text(
                                'Write a review',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : FutureBuilder(
                      future: Future.wait([
                        APIService.reviewHotelRatingUser(hotel.sId)
                            .then((value) => {ru = value}),
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return (ru.rating.toDouble() == 0)
                              ? Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Rate this place',
                                        style: TextStyle(
                                          fontSize: 23,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          RatingBar.builder(
                                            initialRating: ru.rating.toDouble(),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.blue,
                                            ),
                                            onRatingUpdate: (rating) {
                                              userRating = rating;
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: MaterialButton(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              200,
                                          height: 40,
                                          onPressed: () {
                                            if (userRating == 0) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const RatingErrorDialog(),
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    WriteReviewDialog(
                                                        userRating),
                                              );
                                            }
                                          },
                                          color: Colors.lightBlue[800],
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: const Text(
                                            'Write a review',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Your review',
                                        style: TextStyle(
                                          fontSize: 23,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      UserReviewWidget(ru)
                                    ],
                                  ),
                                );
                        } else {
                          return const LoaderReviewUser();
                        }
                      },
                    ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ratings and reviews',
                      style: TextStyle(
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FutureBuilder(
                      future: Future.wait([
                        APIService.reviewHotelRatingAll(hotel.sId)
                            .then((value) => {r = value}),
                        SharedService.getSharedLogin()
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (r.numberOfReviews == 0) {
                            return Container(
                              padding: const EdgeInsets.only(top: 30),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    MdiIcons.emoticonSadOutline,
                                    size: 58,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No data available',
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          r.ratingsAverage.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize: 50,
                                          ),
                                        ),
                                        RatingBar.builder(
                                          initialRating:
                                              r.ratingsAverage.toDouble(),
                                          ignoreGestures: true,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 14.0,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.blue,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                        Text(
                                          r.numberOfReviews.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            const Text('5'),
                                            LinearPercentIndicator(
                                              backgroundColor:
                                                  Colors.grey[300] as Color,
                                              animation: true,
                                              animationDuration: 3000,
                                              width: 160.0,
                                              lineHeight: 10.0,
                                              percent: (r.numberOfReviews == 0)
                                                  ? 0
                                                  : (r.fiveCount /
                                                      r.numberOfReviews),
                                              barRadius:
                                                  const Radius.circular(16),
                                              progressColor: Colors.blue,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            const Text('4'),
                                            LinearPercentIndicator(
                                              backgroundColor:
                                                  Colors.grey[300] as Color,
                                              animation: true,
                                              animationDuration: 3000,
                                              width: 160.0,
                                              lineHeight: 10.0,
                                              percent: (r.numberOfReviews == 0)
                                                  ? 0
                                                  : (r.fourCount /
                                                      r.numberOfReviews),
                                              barRadius:
                                                  const Radius.circular(16),
                                              progressColor: Colors.blue,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            const Text('3'),
                                            LinearPercentIndicator(
                                              backgroundColor:
                                                  Colors.grey[300] as Color,
                                              animation: true,
                                              animationDuration: 3000,
                                              width: 160.0,
                                              lineHeight: 10.0,
                                              percent: (r.numberOfReviews == 0)
                                                  ? 0
                                                  : (r.threeCount /
                                                      r.numberOfReviews),
                                              barRadius:
                                                  const Radius.circular(16),
                                              progressColor: Colors.blue,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            const Text('2'),
                                            LinearPercentIndicator(
                                              backgroundColor:
                                                  Colors.grey[300] as Color,
                                              animation: true,
                                              animationDuration: 3000,
                                              width: 160.0,
                                              lineHeight: 10.0,
                                              percent: (r.numberOfReviews == 0)
                                                  ? 0
                                                  : (r.twoCount /
                                                      r.numberOfReviews),
                                              barRadius:
                                                  const Radius.circular(16),
                                              progressColor: Colors.blue,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            const Text('1 '),
                                            LinearPercentIndicator(
                                              backgroundColor:
                                                  Colors.grey[300] as Color,
                                              animation: true,
                                              animationDuration: 3000,
                                              width: 160.0,
                                              lineHeight: 10.0,
                                              percent: (r.numberOfReviews == 0)
                                                  ? 0
                                                  : (r.oneCount /
                                                      r.numberOfReviews),
                                              barRadius:
                                                  const Radius.circular(16),
                                              progressColor: Colors.blue,
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: (r.numberOfReviews == 1)
                                      ? 1
                                      : (r.numberOfReviews == 2)
                                          ? 2
                                          : 3,
                                  itemBuilder: (context, index) {
                                    final review = r.reviews[index];
                                    return ReviewWidget(review: review);
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, ReviewAll.routeName,
                                        arguments: r);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'View more',
                                      style: TextStyle(
                                          color:
                                              Colors.lightBlue[700] as Color),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                        } else {
                          return const LoaderReviewAll();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .11,
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

class ReviewWidget extends StatelessWidget {
  final Reviews2 review;

  const ReviewWidget({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(review.date);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.grey[300] as Color,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor:
                        Color((math.Random().nextDouble() * 0x333333).toInt())
                            .withOpacity(1.0),
                    child: Text(
                      review.name[0],
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    review.name,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  RatingBar.builder(
                    initialRating: review.rating.toDouble(),
                    ignoreGestures: true,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 16,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.blue,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                review.comment,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700] as Color),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}

class UserReviewWidget extends StatefulWidget {
  final ReviewUser ru;
  const UserReviewWidget(this.ru, {Key? key}) : super(key: key);

  @override
  State<UserReviewWidget> createState() => _UserReviewWidgetState();
}

class _UserReviewWidgetState extends State<UserReviewWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.ru.date);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.grey[300] as Color,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: Color(
                                (math.Random().nextDouble() * 0x333333).toInt())
                            .withOpacity(1.0),
                        child: Text(
                          widget.ru.name[0],
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.ru.name,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.lightBlue,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              MdiIcons.checkDecagram,
                              size: 12,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              'You',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'update',
                        child: Text(
                          'Update review',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete review',
                            style: TextStyle(fontSize: 15)),
                      ),
                    ],
                    onSelected: (String value) {
                      if (value == 'update') {
                        showDialog(
                          context: context,
                          builder: (context) => EditReviewDialog(widget.ru),
                        );
                      } else if (value == 'delete') {
                        APIService.deleteUserHotelReview(currentHotel.sId);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Review deleted",
                            style: TextStyle(
                                fontFamily: fontRegular, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 3,
                          ),
                          backgroundColor: Colors.green,
                        ));
                      }
                    },
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  RatingBar.builder(
                    initialRating: widget.ru.rating.toDouble(),
                    ignoreGestures: true,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 16,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.blue,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.ru.comment,
                style: TextStyle(color: Colors.grey[700] as Color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WriteReviewDialog extends StatefulWidget {
  final double rating;
  const WriteReviewDialog(this.rating, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<WriteReviewDialog> createState() => _WriteReviewDialogState(rating);
}

class _WriteReviewDialogState extends State<WriteReviewDialog> {
  final double rating;
  _WriteReviewDialogState(this.rating);
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Write a review'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Your rating: ',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RatingBar.builder(
                        initialRating: rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 18.0,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 6.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.blue,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              TextFormField(
                controller: _controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write a review!';
                  }
                  return null;
                },
                maxLines: null,
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Write a review..',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.lightBlue[800]),
          ),
        ),
        MaterialButton(
          onPressed: () {
            //Navigator.of(context).pop();
            isLoading = true;
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            if (_formKey.currentState!.validate()) {
              UserHotelReviewModel model = UserHotelReviewModel(
                  hotelId: currentHotel.sId,
                  rating: rating.toInt(),
                  comment: _controller.text);
              APIService.userHotelReview(model).then(
                (response) {
                  if (response.contains('Done')) {
                    Navigator.of(context).pop();
                    isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Successfully submitted!',
                        style: TextStyle(fontFamily: fontRegular, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 3,
                      ),
                      backgroundColor: Colors.green,
                    ));
                  } else {
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
                          title: 'Error 500',
                          message: response,
                          contentType: ContentType.warning,
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  }
                },
              );
            }
          },
          color: Colors.lightBlue[800],
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: isLoading
              ? const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }
}

class EditReviewDialog extends StatefulWidget {
  final ReviewUser ru;
  const EditReviewDialog(this.ru, {Key? key}) : super(key: key);

  @override
  State<EditReviewDialog> createState() => _EditReviewDialogState();
}

class _EditReviewDialogState extends State<EditReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameNotifier = ValueNotifier<String>('');
  double userRating = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    userRating = widget.ru.rating.toDouble();
    return AlertDialog(
      title: const Text('Edit review'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Give rating: ',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RatingBar.builder(
                        initialRating: widget.ru.rating.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 18.0,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 6.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.blue,
                        ),
                        onRatingUpdate: (rating) {
                          userRating = rating;
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              TextFormField(
                //controller: _controller,
                initialValue: widget.ru.comment,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write a review!';
                  }
                  return null;
                },
                maxLines: null,
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Write a review..',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
                onChanged: (value) {
                  _nameNotifier.value = value;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.lightBlue[800]),
          ),
        ),
        MaterialButton(
          onPressed: () {
            //Navigator.of(context).pop();
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            if (_formKey.currentState!.validate()) {
              isLoading = true;
              UserHotelReviewModel model = UserHotelReviewModel(
                hotelId: currentHotel.sId,
                rating: userRating.toInt(),
                comment: (_nameNotifier.value == '')
                    ? widget.ru.comment
                    : _nameNotifier.value,
              );
              APIService.userHotelReview(model).then(
                (response) {
                  if (response.contains('Done')) {
                    Navigator.of(context).pop();
                    isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Successfully updated!',
                        style: TextStyle(fontFamily: fontRegular, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 3,
                      ),
                      backgroundColor: Colors.green,
                    ));
                  } else {
                    isLoading = false;
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
                          title: 'Error 500',
                          message: response,
                          contentType: ContentType.warning,
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  }
                },
              );
            }
          },
          color: Colors.lightBlue[800],
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: isLoading
              ? const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }
}

class RatingErrorDialog extends StatefulWidget {
  const RatingErrorDialog({super.key});

  @override
  State<RatingErrorDialog> createState() => _RatingErrorDialogState();
}

class _RatingErrorDialogState extends State<RatingErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alert'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: const Text("Please rate this place first!"),
      actions: <Widget>[
        MaterialButton(
          minWidth: double.infinity,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'OK',
            style: TextStyle(color: Colors.lightBlue[800]),
          ),
        ),
      ],
    );
  }
}
