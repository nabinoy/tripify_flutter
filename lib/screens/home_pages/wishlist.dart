import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/screens/place.dart';
import 'package:tripify/services/api_service.dart';

import '../weather_details.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    late PlaceDetails pd;
    return Scaffold(
      body: FutureBuilder(
        future: APIService.placeAll().then((value) => {pd = value}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    //physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    // padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    itemCount: placeCount,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Place.routeName,
                              arguments: [pd.places[index]]);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        imageUrl: pd.places[index].images.first
                                            .secureUrl,
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
                                  Text(
                                    pd.places[index].name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(pd.places[index].address.city,
                                      style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const LoadingScreen();
          }
        },
      ),
    );
  }
}
