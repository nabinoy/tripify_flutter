import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/models/tour_operator_response_model.dart';
import 'package:tripify/screens/util.dart/pdf_viewer.dart';
import 'package:tripify/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchTourOperator extends StatefulWidget {
  static const String routeName = '/search_tourOperators';
  const SearchTourOperator({super.key});
  @override
  State<SearchTourOperator> createState() => _SearchTourOperatorState();
}

class _SearchTourOperatorState extends State<SearchTourOperator> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  final StreamController<String> _streamController = StreamController<String>();

  List<TourOperators> tourOp = [];

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
      APIService.tourOperatorBySearch(query).then((value) {
        setState(() {
          tourOp = value;
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

  void _makePhoneCall(String phoneNumber) async {
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
            hintText: 'Search tour operator',
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
                    'Search for a tour operator',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          : (tourOp.isEmpty)
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
                        'No tour operator found',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: tourOp.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 5),
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.width * .13,
                            backgroundColor: Colors.transparent,
                            child: SizedBox(
                              child: CachedNetworkImage(
                                imageUrl: tourOp[index].image.secureUrl,
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
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    tourOp[index].name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                ExpandableText(
                                  tourOp[index].description,
                                  animation: true,
                                  expandText: 'show more',
                                  collapseText: 'show less',
                                  maxLines: 5,
                                  linkColor: Colors.blue,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Address',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.blue, size: 18),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        '${tourOp[index].address.street}, ${tourOp[index].address.city}, ${tourOp[index].address.state}, ${tourOp[index].address.zip}',
                                        style: TextStyle(
                                          color: Colors.grey[900],
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Contact',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.person,
                                        color: Colors.lightBlue, size: 18),
                                    const SizedBox(width: 5),
                                    Text(
                                      tourOp[index].contact.name,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.phone,
                                        color: Colors.green, size: 18),
                                    const SizedBox(width: 5),
                                    Text(
                                      tourOp[index].contact.phone,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.email,
                                        color: Colors.redAccent, size: 18),
                                    const SizedBox(width: 5),
                                    Text(
                                      tourOp[index].contact.email,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MaterialButton(
                                      elevation: 0,
                                      onPressed: () {
                                        _makePhoneCall(
                                            tourOp[index].contact.phone);
                                      },
                                      color: Colors.green[600],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.call,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            'Call',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                    MaterialButton(
                                      elevation: 0,
                                      onPressed: () {
                                        _launchEmail(
                                            tourOp[index].contact.email);
                                      },
                                      color: Colors.deepOrange[400],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.mail,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            'Mail',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                    MaterialButton(
                                      elevation: 0,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, PdfViewPage.routeName,
                                            arguments: [
                                              tourOp[index]
                                                  .tariffDocument
                                                  .secureUrl,
                                              'Tarrif Document'
                                            ]);
                                      },
                                      color: Colors.lightBlue[600],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.picture_as_pdf,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            'View tarrif',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                MaterialButton(
                                  elevation: 0,
                                  onPressed: () {
                                    _launchWeb('https://google.com');
                                  },
                                  color: Colors.lightBlue[800],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        MdiIcons.web,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Get a quote',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
