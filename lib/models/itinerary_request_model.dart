class ItineraryModel {
  int days;
  double lat;
  double long;

  ItineraryModel({required this.days,required this.lat,required this.long});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['days'] = days;
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}