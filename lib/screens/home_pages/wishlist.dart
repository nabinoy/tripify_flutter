import 'package:flutter/material.dart';
import 'package:tripify/models/place_response_model.dart';
import 'package:tripify/screens/place.dart';
import 'package:tripify/screens/map_webview.dart';
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
    List<PlaceDetails> pd = [];
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, MapWebView.routeName);
                },
                child: const Text('Map Webview')),
            FutureBuilder(
              future: APIService.placeAll().then((value) => {pd = value}),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  //return Text(pd[1].name);
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2 * 0.75,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      itemCount: pd.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Place.routeName, arguments: [pd[index]]);
                          },
                          child: SizedBox(
                            width: 100.0,
                            child: Text(pd[index].name),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const LoadingScreen();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
