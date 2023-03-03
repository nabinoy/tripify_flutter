import 'package:flutter/material.dart';
import 'package:tripify/screens/place.dart';
import 'package:tripify/screens/map_webview.dart';

import '../../widget/error_page.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Place.routeName);
            },
            child: const Text('place')),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Details()),
              );
            },
            child: const Text('place 2')),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, MapWebView.routeName);
            },
            child: const Text('Map Webview')),
      ],
    );
  }
}
