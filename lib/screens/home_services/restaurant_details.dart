import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/restaurant_response_model.dart';
import 'package:tripify/models/weather_model.dart';
import 'package:tripify/screens/util.dart/image_viewer.dart';
import 'package:tripify/screens/util.dart/pdf_viewer.dart';
import 'package:tripify/services/current_location.dart';
import 'package:tripify/widget/direction_map.dart';
import 'package:tripify/widget/widget_to_image.dart';
import 'package:url_launcher/url_launcher.dart';

late Restaurants currentRestaurant;

class RestaurantDetailsPage extends StatefulWidget {
  static const String routeName = '/restaurant_details';
  const RestaurantDetailsPage({super.key});

  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
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
    Restaurants restaurant = arguments[0];
    weatherLatAPI = restaurant.location.coordinates[1].toString();
    weatherLongAPI = restaurant.location.coordinates[0].toString();
    currentRestaurant = restaurant;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          restaurant.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              HapticFeedback.mediumImpact();
              final tempDir = await getTemporaryDirectory();
              final controller = ScreenshotController();
              final bytes = await controller.captureFromWidget(
                  Material(child: RestaurantToImage([restaurant])));
              final file =
                  await File('${tempDir.path}/image.png').writeAsBytes(bytes);
              await Share.shareFiles([file.path],
                  text: 'Download our app now!\n\n$appLink');
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  MdiIcons.share,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
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
                        imageUrl: restaurant.images.first.secureUrl,
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
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    restaurant.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                MdiIcons.squareCircle,
                                size: 18,
                                color: (restaurant.isVeg)
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${restaurant.address.street}, ${restaurant.address.city}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${restaurant.address.state}, ${restaurant.address.zip}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
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
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ExpandableText(
                      restaurant.description,
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
                        'Menu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PdfViewPage.routeName,
                            arguments: [restaurant.menu.secureUrl, 'Menu']);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.green[400],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'View Menu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
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
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: restaurant.images
                            .map(
                              (item) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageViewer(
                                          imagePath: item.secureUrl),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: item.secureUrl,
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
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Direction',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 16, top: 8),
                    child: Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
                              imageUrl: restaurant.images.first.secureUrl,
                              placeholder: (context, url) => Image.memory(
                                kTransparentImage,
                                fit: BoxFit.cover,
                              ),
                              fadeInDuration: const Duration(milliseconds: 200),
                              fit: BoxFit.cover,
                            ),
                          )),
                      title: Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: const Text('Restaurant'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _makePhoneCall(restaurant.contact.phone);
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
                              _launchEmail(restaurant.contact.email);
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
                ],
              ),
              const SizedBox(
                height: 110,
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
                    _launchWeb(restaurant.contact.website);
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
                      'Visit',
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
