class NearbyModel {
  String lat;
  String long;
  String maxRad;

  NearbyModel({required this.lat,required this.long,required this.maxRad});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    data['maxRad'] = maxRad;
    return data;
  }
}
