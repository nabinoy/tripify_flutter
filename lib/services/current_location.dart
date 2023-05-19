import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:location/location.dart';

late LocationData currentLocation;

double lat = 0;
double long = 0;
Location location = Location();

late StreamSubscription locationSubscription;

Future<void> getCurrentLocation() async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted == PermissionStatus.denied) {
      AppSettings.openAppSettings();
      return;
    }
  }

  currentLocation = await location.getLocation();
  lat = currentLocation.latitude!;
  long = currentLocation.longitude!;
}

double getlat() {
  if (lat != 0) {
    return lat;
  } else {
    return 0;
  }
}

double getlong() {
  if (long != 0) {
    return long;
  } else {
    return 0;
  }
}

Future<void> stopListeningForLocationUpdates() async {
  locationSubscription.cancel();
}
