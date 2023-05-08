import 'package:flutter/material.dart';

class PlaceToImage extends StatefulWidget {
  const PlaceToImage({super.key});

  @override
  State<PlaceToImage> createState() => _PlaceToImageState();
}

class _PlaceToImageState extends State<PlaceToImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 200,
      color: Colors.amber,
    );
  }
}