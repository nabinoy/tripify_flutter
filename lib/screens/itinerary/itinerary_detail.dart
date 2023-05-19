import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/models/itinerary_request_model.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/screens/place.dart';
import 'package:tripify/services/api_service.dart';
import 'package:tripify/services/itinerary_pdf.dart';

class ItineraryDetails extends StatefulWidget {
  static const String routeName = '/itinerary_detail';
  const ItineraryDetails({super.key});

  @override
  State<ItineraryDetails> createState() => _ItineraryDetailsState();
}

class _ItineraryDetailsState extends State<ItineraryDetails> {
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    final ItineraryModel model = arguments[0];
    final List<String> categories = arguments[1];
    final List<String> island = arguments[2];

    late List<List<Places2>> itineraryPlace;

    List<String> wishlistPlaceIdList = [];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              createPDF(itineraryPlace);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, value, child) {
                  if (!isLoading.value) {
                    return const Row(
                      children: [Text('Share'), Icon(MdiIcons.share)],
                    );
                  } else {
                    return const Text('');
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          APIService.itineraryAll(model, categories, island).then(
              (value) => {itineraryPlace = value, isLoading.value = false}),
          APIService.checkUserWishlist()
              .then((value) => {wishlistPlaceIdList.addAll(value)}),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    child: Lottie.asset(
                        'assets/lottie/itinerary_animation.json',
                        frameRate: FrameRate.max,
                        repeat: false),
                  ),
                  Text(
                    'Your itinerary for ${itineraryPlace.length.toString()} days is here!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue[800]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Wrap(
                      children: itineraryPlace.map((day) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(top: 28),
                                    child: Text(
                                      'Day ${itineraryPlace.indexOf(day) + 1}',
                                      style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ],
                            ),
                            Wrap(
                              children:
                                  itineraryPlace[itineraryPlace.indexOf(day)]
                                      .map((widget) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Place.routeName,
                                        arguments: [
                                          [widget],
                                          (wishlistPlaceIdList
                                                  .contains(widget.sId))
                                              ? true
                                              : false
                                        ]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 4,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(
                                        top: 12.0, left: 12.0, right: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: CachedNetworkImage(
                                            height: 60,
                                            width: 60,
                                            imageUrl:
                                                widget.images.first.secureUrl,
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
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .65,
                                                  child: Text(
                                                    widget.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 16,
                                                  color: Colors.lightBlue,
                                                ),
                                                const SizedBox(
                                                  width: 4.0,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .6,
                                                  child: Text(
                                                    widget.address.city,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Want another itinerary?'),
                        const SizedBox(
                          width: 6,
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              isLoading.value = true;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                'Refresh',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlue[800]),
                              ),
                              Icon(
                                MdiIcons.reload,
                                size: 17,
                                color: Colors.lightBlue[800],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250,
                  child: Lottie.asset('assets/lottie/itinerary_working.json',
                      frameRate: FrameRate.max, repeat: false),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Unlock the Power of Travel\nLet our ML algorithm create your perfect itinerary!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.lightBlue[800]),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
