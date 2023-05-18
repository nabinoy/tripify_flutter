import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/models/itinerary_request_model.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/services/api_service.dart';

class ItineraryDetails extends StatefulWidget {
  static const String routeName = '/itinerary_detail';
  const ItineraryDetails({super.key});

  @override
  State<ItineraryDetails> createState() => _ItineraryDetailsState();
}

class _ItineraryDetailsState extends State<ItineraryDetails> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    final ItineraryModel model = arguments[0];
    final List<String> categories = arguments[1];
    final List<String> island = arguments[2];

    late List<List<Places2>> itineraryPlace;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: Future.wait([
          APIService.itineraryAll(model, categories, island)
              .then((value) => {itineraryPlace = value}),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                      'Your itinerary for ${itineraryPlace.length.toString()} days is here!'),
                      ListView.builder(
                  itemCount: itineraryPlace.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text('Day ${itineraryPlace[index]}'),
                        ListView.builder(
                  itemCount: itineraryPlace[index].length,
                  itemBuilder: (context, indexNew) {
                    return GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(context, Place.routeName,
                        //     arguments: [
                        //       [pd[index]],
                        //       (wishlistPlaceIdList.contains(pd[index].sId))
                        //           ? true
                        //           : false
                        //     ]);
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                height: 60,
                                width: 60,
                                imageUrl: itineraryPlace[index][indexNew].images.first.secureUrl,
                                placeholder: (context, url) => Image.memory(
                                  kTransparentImage,
                                  fit: BoxFit.cover,
                                ),
                                fadeInDuration:
                                    const Duration(milliseconds: 200),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .65,
                                      child: Text(
                                        itineraryPlace[index][indexNew].name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_outlined,
                                        size: 18,
                                        color: Color.fromARGB(255, 0, 0, 0))
                                  ],
                                ),
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
                                      width: MediaQuery.of(context).size.width *
                                          .6,
                                      child: Text(
                                        itineraryPlace[index][indexNew].address.city,
                                        overflow: TextOverflow.ellipsis,
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
                    
                  },
                ),
                        ],
                    );
                  },
                ),
    
                ],
              ),
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
