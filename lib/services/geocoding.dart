import 'package:geocoding/geocoding.dart';

String currentLocationName = '';

getPlaceNameFromCoordinate(double lat, double long) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
  currentLocationName =
      '${placemarks[0].subLocality!}, ${placemarks[0].locality!}';
  // getPlaceNameFromCoordinate(currentLocation.latitude!, currentLocation.longitude!);
  // print('Hello $currentLocationName');
}
