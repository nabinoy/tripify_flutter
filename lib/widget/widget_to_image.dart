import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/place_response_model.dart';

class PlaceToImage extends StatefulWidget {
  final List<Places2> placeList;
  const PlaceToImage(this.placeList, {super.key});

  @override
  State<PlaceToImage> createState() => _PlaceToImageState();
}

class _PlaceToImageState extends State<PlaceToImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 530,
        width: 1000,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  height: 350,
                  width: 360,
                  alignment: Alignment.bottomCenter,
                  imageUrl: widget.placeList.first.images.first.secureUrl,
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
              widget.placeList.first.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 24,
                  fontFamily: fontRegular,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_pin,
                    size: 16, color: Colors.lightBlue[800]),
                Text(
                  widget.placeList.first.address.city,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.lightBlue[800],
                    fontFamily: fontRegular,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LAT: ${widget.placeList.first.location.coordinates[1]}',
                  style: const TextStyle(
                      color: Colors.black54,
                      fontFamily: fontRegular,
                      fontSize: 10),
                ),
                const SizedBox(width: 8),
                Text(
                  'LONG: ${widget.placeList.first.location.coordinates[0]}',
                  style: const TextStyle(
                      color: Colors.black54,
                      fontFamily: fontRegular,
                      fontSize: 10),
                ),
              ],
            ),
            const Text(
              'Discover more tourism places of Andaman and Nicobar island and exciting features by visiting our app!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(255, 51, 51, 51),
                  fontFamily: fontRegular,
                  fontSize: 12),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tripify',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontFamily: fontRegular,
              ),
            ),
          ],
        ));
  }
}
