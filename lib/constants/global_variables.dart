import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

const appName = 'Tripify';
const bgColor = Colors.white;
const fontRegular = 'Poppins';
var lightBlue800 = Colors.lightBlue[800];
int placePageSize = 4;
int hotelPageSize = 6;
double portBlairLat = 11.650475999232123;
double portBlairLong = 92.73356876475748;

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
      "https://hotelhavanabulgaria.com/wp-content/uploads/2020/07/single-room-1.jpg",
  "Twin Room":
      "https://www.collinsdictionary.com/images/full/twinroom_310855142_1000.jpg",
  "Triple Room":
      "https://www.louisfitzgeraldhotel.com/wp-content/uploads/2020/03/hotel-louis-fitzgerald-082.jpg",
  "Family Room":
      "https://hips.hearstapps.com/hmg-prod/images/gettyimages-670913803-1515521778.jpg?crop=1xw:1xh;center,top&resize=980:*",
  "Cottage":
      "https://r2imghtlak.mmtcdn.com/r2-mmt-htl-image/htl-imgs/202108122021419955-150ddef4330211ec82820a58a9feac02.jpg?&output-quality=75&downsize=910:612&crop=910:612;4,0&output-format=jpg",
  "Dormitory Room":
      "https://cf.bstatic.com/xdata/images/hotel/max1024x768/160849727.jpg?k=0d56f62be9551f18ca73fe31a5f67208a142a8c5b3ef9bb9154b0ded1c087646&o=&hp=1",
  "Executive Suite":
      "https://images.rosewoodhotels.com/is/image/rwhg/rwgzu-executive-suite-living-room-dusk",
  "Suite Room":
      "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
  "Deluxe Room":
      "https://images.unsplash.com/photo-1631049307264-da0ec9d70304?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"
};
