class TourOperators {
  Document image;
  Address address;
  Contact contact;
  Document tariffDocument;
  String sId;
  String name;
  String description;
  bool isApproved;
  String serviceProvider;
  String createdAt;
  int iV;

  TourOperators(
      {required this.image,
      required this.address,
      required this.contact,
      required this.tariffDocument,
      required this.sId,
      required this.name,
      required this.description,
      required this.isApproved,
      required this.serviceProvider,
      required this.createdAt,
      required this.iV});

  factory TourOperators.fromJson(Map<String, dynamic> json) {
    return TourOperators(
        image: Document.fromJson(json['image']),
        address: Address.fromJson(json['address']),
        contact: Contact.fromJson(json['contact']),
        tariffDocument: Document.fromJson(json['tariffDocument']),
        sId: json['_id'],
        name: json['name'],
        description: json['description'],
        isApproved: json['isApproved'],
        serviceProvider: json['serviceProvider'],
        createdAt: json['createdAt'],
        iV: json['__v']);
  }
}

class Document {
  String id;
  String secureUrl;

  Document({required this.id, required this.secureUrl});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(id: json['id'], secureUrl: json['secure_url']);
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
  String name;
  String phone;
  String email;

  Contact({required this.name, required this.phone, required this.email});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
        name: json['name'], phone: json['phone'], email: json['email']);
  }
}
