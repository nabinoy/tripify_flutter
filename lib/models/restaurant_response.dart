class RestaurantDetails {
  bool success;
  List<Restaurants> restaurants;

  RestaurantDetails({required this.success, required this.restaurants});

  factory RestaurantDetails.fromJson(Map<String, dynamic> json) {
    return RestaurantDetails(
        success: json['success'],
        restaurants: (json['restaurants'] as List<dynamic>)
            .map((e) => Restaurants.fromJson(e))
            .toList());
  }
}

class Restaurants {
  Location location;
  Address address;
  Contact contact;
  Menu menu;
  Menu governmentAuthorizedLicense;
  String sId;
  String name;
  String description;
  bool isVeg;
  List<Images> images;
  String island;
  bool isApproved;
  String serviceProvider;
  String createdAt;
  int iV;

  Restaurants(
      {required this.location,
      required this.address,
      required this.contact,
      required this.menu,
      required this.governmentAuthorizedLicense,
      required this.sId,
      required this.name,
      required this.description,
      required this.isVeg,
      required this.images,
      required this.island,
      required this.isApproved,
      required this.serviceProvider,
      required this.createdAt,
      required this.iV});

  factory Restaurants.fromJson(Map<String, dynamic> json) {
    return Restaurants(
        location: Location.fromJson(json['location']),
        address: Address.fromJson(json['address']),
        contact: Contact.fromJson(json['contact']),
        menu: Menu.fromJson(json['menu']),
        governmentAuthorizedLicense:
            Menu.fromJson(json['governmentAuthorizedLicense']),
        sId: json['_id'],
        name: json['name'],
        description: json['description'],
        isVeg: json['isVeg'],
        images: (json['images'] as List<dynamic>)
            .map((e) => Images.fromJson(e))
            .toList(),
        island: json['island'],
        isApproved: json['isApproved'],
        serviceProvider: json['serviceProvider'],
        createdAt: json['createdAt'],
        iV: json['__v']);
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
        zip: json['zip']);
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

class Menu {
  String id;
  String secureUrl;

  Menu({required this.id, required this.secureUrl});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(id: json['id'], secureUrl: json['secure_url']);
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
