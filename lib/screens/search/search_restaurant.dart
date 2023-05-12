import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/models/restaurant_response_model.dart';
import 'package:tripify/screens/home_services/restaurant_details.dart';
import 'package:tripify/services/api_service.dart';

class SearchRestaurant extends StatefulWidget {
  static const String routeName = '/search_restaurant';
  const SearchRestaurant({super.key});
  @override
  State<SearchRestaurant> createState() => _SearchRestaurantState();
}

class _SearchRestaurantState extends State<SearchRestaurant> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  final StreamController<String> _streamController = StreamController<String>();

  List<Restaurants> restaurant = [];

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
      APIService.restaurantBySearch(query).then((value) {
        setState(() {
          restaurant = value;
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
            hintText: 'Search restaurants',
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
                    'Search for a restaurant',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          : (restaurant.isEmpty)
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
                        'No restaurant found',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: restaurant.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RestaurantDetailsPage.routeName,
                            arguments: [restaurant[index]]);
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
                                imageUrl:
                                    restaurant[index].images.first.secureUrl,
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
                                        restaurant[index].name,
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
                                        restaurant[index].address.city,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Icon(
                                  MdiIcons.squareCircle,
                                  size: 14,
                                  color: (restaurant[index].isVeg)
                                      ? Colors.green
                                      : Colors.red,
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
