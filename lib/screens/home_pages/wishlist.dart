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
    List<Places2> pd = [];
    return Scaffold(
      body: FutureBuilder(
        future: APIService.placeAll().then((value) => {pd.addAll(value)}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: const Text(
                        'Your wishlist',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    //physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    // padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    itemCount: placeCount,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(
                                  height:
                                      MediaQuery.of(context).size.width * .25,
                                  width:
                                      MediaQuery.of(context).size.width * .25,
                                  imageUrl: pd[index].images.first.secureUrl,
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
                            const SizedBox(
                              width: 6,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .55,
                                  child: Text(
                                    pd[index].name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(pd[index].address.city,
                                    style: const TextStyle(fontSize: 12)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MaterialButton(
                                      elevation: 0,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, Place.routeName,
                                            arguments: [pd[index]]);
                                      },
                                      color: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Row(
                                        children: const [
                                          Text(
                                            'Visit',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_sharp,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    MaterialButton(
                                      elevation: 0,
                                      onPressed: () {},
                                      color: Colors.red[400],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                )
                              ],
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
