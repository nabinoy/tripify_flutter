class HotelDetails {
  List<Hotels> hotels;
  int filteredNumber;
  int totalHotelCount;

  HotelDetails(
      {required this.hotels,
      required this.filteredNumber,
      required this.totalHotelCount});

  factory HotelDetails.fromJson(Map<String, dynamic> json) {
    return HotelDetails(
      hotels: (json['hotels'] as List<dynamic>)
          .map((e) => Hotels.fromJson(e))
          .toList(),
      filteredNumber: json['filteredPlaceNumber'],
      totalHotelCount: json['totalPlaceCount'],
    );
  }
}

class Hotels {
  Address address;
  Location location;
  Contact contact;
  String sId;
  String name;
  String description;
  List<Images> images;
  String checkinTime;
  String checkoutTime;
  String island;
  List<Rooms> rooms;
  List<String> facilities;
  int ratings;
  int numberOfReviews;
  bool isApproved;
  String serviceProvider;
  List<HotelReviews> reviews;
  String createdAt;
  int iV;

  Hotels(
      {required this.address,
      required this.location,
      required this.contact,
      required this.sId,
      required this.name,
      required this.description,
      required this.images,
      required this.checkinTime,
      required this.checkoutTime,
      required this.island,
      required this.rooms,
      required this.facilities,
      required this.ratings,
      required this.numberOfReviews,
      required this.isApproved,
      required this.serviceProvider,
      required this.reviews,
      required this.createdAt,
      required this.iV});

  factory Hotels.fromJson(Map<String, dynamic> json) {
    return Hotels(
      address: Address.fromJson(json['address']),
      location: Location.fromJson(json['location']),
      contact: Contact.fromJson(json['contact']),
      sId: json['_id'],
      name: json['name'],
      description: json['description'],
      images: (json['images'] as List<dynamic>)
          .map((e) => Images.fromJson(e))
          .toList(),
      checkinTime: json['checkinTime'],
      checkoutTime: json['checkoutTime'],
      island: json['island'],
      rooms: (json['rooms'] as List<dynamic>)
          .map((e) => Rooms.fromJson(e))
          .toList(),
      facilities: (json['facilities'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      ratings: json['ratings'],
      numberOfReviews: json['numberOfReviews'],
      isApproved: json['isApproved'],
      serviceProvider: json['serviceProvider'],
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => HotelReviews.fromJson(e))
          .toList(),
      createdAt: json['createdAt'],
      iV: json['__v'],
    );
  }
}

class Address {
  String street;
  String city;
  String state;
  String zip;

  Address(
      {required this.street,
      required this.city,
      required this.state,
      required this.zip});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
    );
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

class Contact {
  String phone;
  String email;
  String website;

  Contact({required this.phone, required this.email, required this.website});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
    );
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

class Rooms {
  Beds beds;
  String roomType;
  String description;
  int price;
  int maxOccupancy;
  List<String> amenities;
  String sId;

  Rooms(
      {required this.beds,
      required this.roomType,
      required this.description,
      required this.price,
      required this.maxOccupancy,
      required this.amenities,
      required this.sId});

  factory Rooms.fromJson(Map<String, dynamic> json) {
    return Rooms(
      beds: Beds.fromJson(json['beds']),
      roomType: json['roomType'],
      description: json['description'],
      price: json['price'],
      maxOccupancy: json['maxOccupancy'],
      amenities: json['amenities'].cast<String>(),
      sId: json['_id'],
    );
  }
}

class Beds {
  String bedType;
  int quantity;

  Beds({required this.bedType, required this.quantity});

  factory Beds.fromJson(Map<String, dynamic> json) {
    return Beds(
      bedType: json['bedType'],
      quantity: json['quantity'],
    );
  }
}

class HotelReviews {
  String user;
  String name;
  int rating;
  String comment;
  String date;
  String sentiment;
  String sId;

  HotelReviews({
    required this.user,
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
    required this.sId,
    required this.sentiment,
  });

  factory HotelReviews.fromJson(Map<String, dynamic> json) {
    return HotelReviews(
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
