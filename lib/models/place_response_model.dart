class PlaceDetails {
  List<Places2> places;
  int filteredPlaceNumber;
  int totalPlaceCount;

  PlaceDetails(
      {required this.places,
      required this.filteredPlaceNumber,
      required this.totalPlaceCount});

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
        places: (json['places'] as List<dynamic>)
            .map((e) => Places2.fromJson(e))
            .toList(),
        filteredPlaceNumber: json['filteredPlaceNumber'],
        totalPlaceCount: json['totalPlaceCount']);
  }
}

class Places2 {
  Location location;
  Address address;
  BestTimeToVisit bestTimeToVisit;
  String sId;
  String name;
  String description;
  bool entry;
  List<EntryCost> entryCost;
  String island;
  List<String> activities;
  List<String> categories;
  String howToReach;
  List<Images> images;
  List<ExternalLinks> externalLinks;
  List<Timings> timings;
  double ratings;
  int numberOfReviews;
  List<String> doS;
  List<String> dontS;
  List<Reviews> reviews;
  String createdAt;
  int iV;

  Places2(
      {required this.location,
      required this.address,
      required this.bestTimeToVisit,
      required this.sId,
      required this.name,
      required this.description,
      required this.entry,
      required this.entryCost,
      required this.island,
      required this.activities,
      required this.categories,
      required this.howToReach,
      required this.images,
      required this.externalLinks,
      required this.timings,
      required this.ratings,
      required this.numberOfReviews,
      required this.doS,
      required this.dontS,
      required this.reviews,
      required this.createdAt,
      required this.iV});

  factory Places2.fromJson(Map<String, dynamic> data) {
    return Places2(
      location: Location.fromJson(data['location']),
      address: Address.fromJson(data['address']),
      bestTimeToVisit: BestTimeToVisit.fromJson(data['bestTimeToVisit']),
      sId: data['_id'],
      name: data['name'],
      description: data['description'],
      entry: data['entry'],
      entryCost: (data['entry_cost'] as List<dynamic>)
          .map((e) => EntryCost.fromJson(e))
          .toList(),
      island: data['island'],
      activities: (data['activities'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      categories: (data['categories'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      howToReach: data['howToReach'],
      images: (data['images'] as List<dynamic>)
          .map((e) => Images.fromJson(e))
          .toList(),
      externalLinks: (data['external_links'] as List<dynamic>)
          .map((e) => ExternalLinks.fromJson(e))
          .toList(),
      timings: (data['timings'] as List<dynamic>)
          .map((e) => Timings.fromJson(e))
          .toList(),
      ratings: data['ratings'].toDouble(),
      numberOfReviews: data['numberOfReviews'],
      doS: (data['do_s'] as List<dynamic>).map((e) => e.toString()).toList(),
      dontS:
          (data['dont_s'] as List<dynamic>).map((e) => e.toString()).toList(),
      reviews: (data['reviews'] as List<dynamic>)
          .map((e) => Reviews.fromJson(e))
          .toList(),
      createdAt: data['createdAt'].toString(),
      iV: data['__v'],
    );
  }
}

class BestTimeToVisit {
  String startMonth;
  String endMonth;

  BestTimeToVisit({required this.startMonth, required this.endMonth});

  factory BestTimeToVisit.fromJson(Map<String, dynamic> json) {
    return BestTimeToVisit(
        startMonth: json['startMonth'], endMonth: json['endMonth']);
  }
}

class Location {
  String type;
  List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        type: json['type'], coordinates: json['coordinates'].cast<double>());
  }
}

class Address {
  String street;
  String landmark;
  String city;
  String state;
  String zip;
  String country;

  Address(
      {required this.street,
      required this.landmark,
      required this.city,
      required this.state,
      required this.zip,
      required this.country});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      landmark: json['landmark'] ?? 'null',
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
    );
  }
}

class EntryCost {
  String category;
  int cost;
  String sId;

  EntryCost({required this.category, required this.cost, required this.sId});

  factory EntryCost.fromJson(Map<String, dynamic> json) {
    return EntryCost(
        category: json['category'], cost: json['cost'], sId: json['_id']);
  }
}

class Images {
  String id;
  String secureUrl;
  String sId;

  Images({required this.id, required this.secureUrl, required this.sId});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
        id: json['id'], secureUrl: json['secure_url'], sId: json['_id']);
  }
}

class ExternalLinks {
  String title;
  String link;
  String sId;

  ExternalLinks({required this.title, required this.link, required this.sId});

  factory ExternalLinks.fromJson(Map<String, dynamic> json) {
    return ExternalLinks(
        title: json['title'], link: json['link'], sId: json['_id']);
  }
}

class Timings {
  String day;
  String openTime;
  String closeTime;
  String sId;

  Timings(
      {required this.day,
      required this.openTime,
      required this.closeTime,
      required this.sId});

  factory Timings.fromJson(Map<String, dynamic> json) {
    return Timings(
        day: json['day'],
        openTime: json['open_time'],
        closeTime: json['close_time'],
        sId: json['_id']);
  }
}

class Reviews {
  String user;
  String name;
  int rating;
  String comment;
  String date;
  String sentiment;
  String sId;

  Reviews({
    required this.user,
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
    required this.sId,
    required this.sentiment,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      user: json['user'],
      name: json['name'],
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'],
      sId: json['_id'],
      sentiment: json['sentiment'],
    );
  }
}
