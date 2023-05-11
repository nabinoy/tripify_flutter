import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripify/constants/global_variables.dart';
import 'package:tripify/models/weather_model.dart';
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
  late GoogleMapController googleMapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool flag = false;
  bool isOutsider = false;
  double distance = 100;
  double destinationLat = double.parse(weatherLatAPI);
  double destinationLong = double.parse(weatherLongAPI);

  LatLng midpoint = LatLng((portBlairLat + double.parse(weatherLatAPI)) / 2,
      (portBlairLong + double.parse(weatherLongAPI)) / 2);

  void setPolylines(double lat, double long) async {
    polylineCoordinates.clear();
    final uri = Uri.parse(
        "https://router.project-osrm.org/route/v1/driving/$long,$lat;$destinationLong,$destinationLat?geometries=geojson&overview=full");
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

  void getDistance(double lat, double long) async {
    final uri = Uri.parse(
        "https://router.project-osrm.org/route/v1/driving/$long,$lat;$destinationLong,$destinationLat?geometries=geojson&overview=full");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      distance = data['routes'][0]['distance'] / 1000;
      SharedService.setSharedDistance(distance);
    }
  }

  bool isWithinRadius(double currentLat, double currentLng, double centerLat,
      double centerLng) {
    const int earthRadius = 6371; // in kilometers
    double latDistance = math.pi / 180 * (centerLat - currentLat);
    double lngDistance = math.pi / 180 * (centerLng - currentLng);
    double a = math.sin(latDistance / 2) * math.sin(latDistance / 2) +
        math.cos(math.pi / 180 * (currentLat)) *
            math.cos(math.pi / 180 * (centerLat)) *
            math.sin(lngDistance / 2) *
            math.sin(lngDistance / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;
    return distance <= 415;
  }

  @override
  void initState() {
    super.initState();
    isOutsider = isWithinRadius(currentLocation.latitude!,
        currentLocation.longitude!, 10.160268, 93.234438);

    if (!isOutsider) {
      setPolylines(portBlairLat, portBlairLong);
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
          getDistance(portBlairLat, portBlairLong);

          midpoint = LatLng((portBlairLat + destinationLat) / 2,
              (portBlairLong + destinationLong) / 2);

          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId("destination_location"),
              position: LatLng(destinationLat, destinationLong),
              infoWindow: const InfoWindow(
                title: "Destination",
              ),
              icon: BitmapDescriptor.defaultMarker,
            ),
          );
          _markers.add(
            Marker(
              markerId: const MarkerId("source_location"),
              position: LatLng(portBlairLat, portBlairLong),
              infoWindow: const InfoWindow(
                title: "Port Blair",
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(200),
            ),
          );
          if (flag == true) {
            googleMapController
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: midpoint,
              zoom: math.log(50157550.5 / (distance * 1000)) / math.log(2),
              tilt: 80,
            )));
          }
        });
      });
    } else {
      setPolylines(currentLocation.latitude!, currentLocation.longitude!);
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
          getDistance(currentLocation.latitude!, currentLocation.longitude!);
          midpoint = LatLng((currentLocation.latitude! + destinationLat) / 2,
              (currentLocation.longitude! + destinationLong) / 2);
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId("destination_location"),
              position: LatLng(destinationLat, destinationLong),
              infoWindow: const InfoWindow(
                title: "Destination",
              ),
              icon: BitmapDescriptor.defaultMarker,
            ),
          );
        });

        if (flag == true) {
          googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: midpoint,
            zoom: math.log(50157550.5 / (distance * 1000)) / math.log(2),
            tilt: 80,
          )));
        }
      });
    }
  }

  @override
  void dispose() {
    googleMapController.dispose();
    stopListeningForLocationUpdates();
    polylineCoordinates.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: (isOutsider),
      initialCameraPosition: CameraPosition(
        target: midpoint,
        zoom: math.log(50157550.5 / (distance * 1000)) / math.log(2),
        tilt: 80,
      ),
      onMapCreated: (controller) {
        googleMapController = controller;
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
