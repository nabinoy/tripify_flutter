import 'package:geocoding/geocoding.dart';

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
