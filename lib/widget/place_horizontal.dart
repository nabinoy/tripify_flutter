import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/screens/place.dart';

class PlaceHorizontal extends StatefulWidget {
  const PlaceHorizontal({super.key});

  @override
  State<PlaceHorizontal> createState() => _PlaceHorizontalState();
}

class _PlaceHorizontalState extends State<PlaceHorizontal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      margin: const EdgeInsets.only(top: 16),
      height: MediaQuery.of(context).size.width / 1.64,
      child: ListView.builder(
          itemCount: 3,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => DetailView(id: index)));
              },
              child: Column(
                children: [
                  Container(
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
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              height: MediaQuery.of(context).size.width / 2.5,
                              width: MediaQuery.of(context).size.width / 1.4,
                              imageUrl:
                                  'https://res.cloudinary.com/diowg4rud/image/upload/v1677664292/places/ra0cbg8ewbjumsgvwtxx.jpg',
                              placeholder: (context, url) => Image.memory(
                                kTransparentImage,
                                fit: BoxFit.cover,
                              ),
                              fadeInDuration: const Duration(milliseconds: 200),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          'pd.places[index].name',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text('pd.places[index].address.city',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
