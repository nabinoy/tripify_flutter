import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

const appName = 'Tripify';
const bgColor = Colors.white;
const fontRegular = 'Poppins';
var lightBlue800 = Colors.lightBlue[800];
int placeCount = 4;
int placePageSize = 4;

Map<String, IconData> placeActivityIcons = {
  "Swimming": MdiIcons.swim,
  "Scuba Diving": MdiIcons.divingScuba
};

Map<String, Icon> hotelAmenityIcons = {};

Map<String, Icon> hotelFacilityIcons = {};

Map<String, IconData> hotelBedIcons = {
  "King": MdiIcons.bedKing,
};

Map<String, String> hotelRoomTypeImages = {
  "Suite Room":
      "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
  "Deluxe Room":
      "https://images.unsplash.com/photo-1631049307264-da0ec9d70304?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"
};
