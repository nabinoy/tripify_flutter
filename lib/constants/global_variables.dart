import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

const appName = 'Tripify Andaman';
const bgColor = Colors.white;
const fontRegular = 'Poppins';
var lightBlue800 = Colors.lightBlue[800];
int placePageSize = 4;
int hotelPageSize = 6;
int restaurantPageSize = 6;
int tourOpPageSize = 6;
double portBlairLat = 11.650475999232123;
double portBlairLong = 92.73356876475748;
String byAir = 'https://www.andaman.gov.in/helicopter-schedule';
String bySea =
    'https://dss.andaman.gov.in/ShipAndamanWebSite/services/passenger-services/online_enquiry.html';
String byRoad = 'https://ants.andaman.gov.in/';
String appLink =
    'https://play.google.com/store/apps/details?id=com.example.tripify';

Map<String, IconData> hotelBedIcons = {
  "King": MdiIcons.bedKing,
  "Single": MdiIcons.bedSingle,
  "Queen": MdiIcons.bedQueen,
  "Double": MdiIcons.bedDouble,
  "Super King": Icons.king_bed,
  "Bunk King": MdiIcons.bunkBed,
  "Sofa Bed": MdiIcons.sofaSingle,
  "Twin": MdiIcons.bed,
  "Futon": MdiIcons.bed,
  "Trundle Bed": MdiIcons.bed,
  "Murphy Bed": MdiIcons.bed,
  "Day Bed": MdiIcons.bed,
};

Map<String, String> hotelRoomTypeImages = {
  "Single Room":
      "https://res.cloudinary.com/diowg4rud/image/upload/v1684061312/hotels/Bed%20images/single-room-1_zatew9.jpg",
  "Twin Room":
      "https://res.cloudinary.com/diowg4rud/image/upload/v1684061373/hotels/Bed%20images/84b71477-06b3-43f1-8a9a-00afa518e07f_hxql1j.jpg",
  "Triple Room":
      "https://res.cloudinary.com/diowg4rud/image/upload/v1684061415/hotels/Bed%20images/hotel-louis-fitzgerald-082_brfer5.jpg",
  "Family Room":
      "https://res.cloudinary.com/diowg4rud/image/upload/v1684061457/hotels/Bed%20images/gettyimages-670913803-1515521778_djeofn.jpg",
  "Cottage":
      "https://res.cloudinary.com/diowg4rud/image/upload/v1684061524/hotels/Bed%20images/202108122021419955-150ddef4330211ec82820a58a9feac02_q0axdk.jpg",
  "Dormitory Room":
      "https://res.cloudinary.com/diowg4rud/image/upload/v1684061565/hotels/Bed%20images/160849727_bf15lx.jpg",
  "Executive Suite":
      "https://res.cloudinary.com/diowg4rud/image/upload/v1684061633/hotels/Bed%20images/rwgzu-executive-suite-living-room-dusk_sttzbk.jpg",
  "Suite Room":
      "https://res.cloudinary.com/diowg4rud/image/upload/v1684061691/hotels/Bed%20images/photo-1560448204-e02f11c3d0e2_lsuqip.jpg",
  "Deluxe Room":
      "https://res.cloudinary.com/diowg4rud/image/upload/v1684061739/hotels/Bed%20images/photo-1631049307264-da0ec9d70304_zmzg6v.jpg"
};
