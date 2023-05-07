import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/models/hotel_response_model.dart';
import 'package:tripify/screens/home_services/hotel_details.dart';
import 'package:tripify/services/api_service.dart';

class SearchHotel extends StatefulWidget {
  static const String routeName = '/search_hotel';
  const SearchHotel({super.key});
  @override
  State<SearchHotel> createState() => _SearchHotelState();
}

class _SearchHotelState extends State<SearchHotel> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  final StreamController<String> _streamController = StreamController<String>();

  List<Hotels> hotel = [];

  bool _isEditingText = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchFocusNode.requestFocus());
    _searchController.addListener(() {
      if (_isEditingText) {
        _isEditingText = true;
        _streamController.add(_searchController.text);
      }
    });

    _streamController.stream.listen((query) {
      APIService.hotelBySearch(query).then((value) {
        setState(() {
          hotel = value;
          _isEditingText = false;
        });
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          onChanged: (query) {
            _streamController.add(query);
            _isEditingText = true;
          },
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search hotels',
            border: InputBorder.none,
          ),
        ),
      ),
      body: (_searchController.text.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 100.0,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Search for a hotel',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          : (hotel.isEmpty)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        size: 100.0,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'No hotel found',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: hotel.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                                  context, HotelDetailsPage.routeName,
                                  arguments: [hotel[index]]);
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
                                imageUrl: hotel[index].images.first.secureUrl,
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
                                        hotel[index].name,
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
                                        hotel[index].address.city,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          hotel[index].ratings.toString(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          ' (${hotel[index].reviews.length})',
                                          style: const TextStyle(
                                              fontSize: 9,
                                              color: Colors.black45),
                                        ),
                                      ],
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
    );
  }
}
