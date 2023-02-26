import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripify/services/current_location.dart';

List<LatLng> polylineCoordinates = [];

class MapData extends StatefulWidget {
  const MapData({super.key});

  @override
  State<MapData> createState() => _MapDataState();
}

class _MapDataState extends State<MapData> {
  late GoogleMapController _googleMapController;
  final Set<Marker> _markers = {};
  bool flag = false;

  LatLng cameraTarget = LatLng(lat, long);

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    locationSubscription = location.onLocationChanged.listen((value) {
      setState(() {
        currentLocation = value;
        cameraTarget =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
      if (flag == true) {
        _googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: cameraTarget,
          zoom: 16.5,
          tilt: 40,
        )));
      }
    });
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    stopListeningForLocationUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
      mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(
        target: cameraTarget,
        zoom: 16.5,
        tilt: 40,
      ),
      onMapCreated: (controller) {
        _googleMapController = controller;
        flag = true;
      },
      zoomControlsEnabled: false,
      markers: _markers,
    );
  }
}
