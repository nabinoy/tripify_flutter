import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripify/models/place_model.dart';
import 'package:tripify/services/current_location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;

import 'package:tripify/services/shared_service.dart';

List<LatLng> polylineCoordinates = [];

class DirectionMap extends StatefulWidget {
  const DirectionMap({super.key});

  @override
  State<DirectionMap> createState() => _DirectionMapState();
}

class _DirectionMapState extends State<DirectionMap> {
  late GoogleMapController _googleMapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool flag = false;
  double distance = 100;

  //static LatLng destination = LatLng(PlaceModel.lat, PlaceModel.long); //destination
  //static const LatLng destination = LatLng(11.637482, 92.713127); //destination

  LatLng midpoint =
      LatLng((lat + PlaceModel.lat) / 2, (long + PlaceModel.long) / 2);

  void setPolylines() async {
    polylineCoordinates.clear();
    final uri = Uri.parse(
        "https://router.project-osrm.org/route/v1/driving/${currentLocation.longitude!},${currentLocation.latitude!};${PlaceModel.long},${PlaceModel.lat}?geometries=geojson&overview=full");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var coordinates = data["routes"][0]["geometry"]["coordinates"];
      for (var i = 0; i < coordinates.length; i++) {
        var c = coordinates[i];
        var latLng = LatLng(c[1], c[0]);
        polylineCoordinates.add(latLng);
      }
      setState(() {});
    }
  }

  void getDistance() async {
    final uri = Uri.parse(
        "https://router.project-osrm.org/route/v1/driving/${currentLocation.longitude!},${currentLocation.latitude!};${PlaceModel.long},${PlaceModel.lat}?geometries=geojson&overview=full");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      distance = data['routes'][0]['distance'] / 1000;
      SharedService.setSharedDistance(distance);
    }
  }

  @override
  void initState() {
    super.initState();
    setPolylines();
    _polylines.clear();
    _polylines.add(
      Polyline(
        polylineId: const PolylineId("route"),
        points: polylineCoordinates,
        color: Colors.lightBlue,
        width: 6,
      ),
    );
    locationSubscription = location.onLocationChanged.listen((value) {
      setState(() {
        currentLocation = value;
        getDistance();
        midpoint = LatLng((currentLocation.latitude! + PlaceModel.lat) / 2,
            (currentLocation.longitude! + PlaceModel.long) / 2);
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId("destination_location"),
            position: LatLng(PlaceModel.lat, PlaceModel.long),
            infoWindow: const InfoWindow(
              title: "Destination",
            ),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      });
      if (flag == true) {
        _googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: midpoint,
          zoom: math.log(50157550.5 / (distance * 1000)) / math.log(2),
          tilt: 80,
        )));
      }
    });
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    stopListeningForLocationUpdates();
    polylineCoordinates.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: midpoint,
        zoom: math.log(50157550.5 / (distance * 1000)) / math.log(2),
        tilt: 80,
      ),
      onMapCreated: (controller) {
        _googleMapController = controller;
        flag = true;
      },
      polylines: _polylines,
      zoomControlsEnabled: false,
      markers: _markers,
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
