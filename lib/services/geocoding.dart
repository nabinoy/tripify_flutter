import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String currentLocationName = '';

getPlaceNameFromCoordinate(double lat, double long) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
  currentLocationName =
      '${placemarks[0].subLocality!}, ${placemarks[0].locality!}';
}

Future<String?> getNameFromCoordinate(double lat, double long) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
  return placemarks[0].locality;
}

Future<LatLng> getCoordinatesFromPace(String name) async {
  List<Location> locations = await locationFromAddress(name);
  LatLng cameraTarget =
      LatLng(locations.first.latitude, locations.first.longitude);
  return cameraTarget;
  //return locations;
}
