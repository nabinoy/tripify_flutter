import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapIsland extends StatelessWidget {
  final LatLng cameraTarget;
  final String placeName;
  const MapIsland(this.cameraTarget, this.placeName, {super.key});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: cameraTarget,
        zoom: 11,
      ),
      zoomControlsEnabled: false,
      markers: {
        Marker(
          markerId: MarkerId(placeName),
          position: cameraTarget,
          infoWindow: InfoWindow(
            title: placeName,
          ),
        ),
      },
    );
  }
}
