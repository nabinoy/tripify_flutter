import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/screens/place.dart';
import 'package:tripify/services/api_service.dart';

int page = 1;
List<Places2> pd = [];

class PlaceHorizontal extends StatefulWidget {
  const PlaceHorizontal({super.key});

  @override
  State<PlaceHorizontal> createState() => _PlaceHorizontalState();
}

class _PlaceHorizontalState extends State<PlaceHorizontal> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    page = 1;
    controller.dispose();
    super.dispose();
  }

  Future fetch() async {
    setState(() {
      page++;
      APIService.placePagination(page.toString())
          .then((value) => {pd.addAll(value)});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        APIService.placeAll().then((value) => {pd = value}),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
              controller: controller,
              itemCount: pd.length + 1,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                if (index < pd.length) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Place.routeName,
                          arguments: [pd[index]]);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(
                                  height:
                                      MediaQuery.of(context).size.width / 2.5,
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
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
                            Positioned(
                              top: 15,
                              right: 15,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 17,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      pd[index].ratings.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                          Container(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pd[index].name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  pd[index].address.city,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              });
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
