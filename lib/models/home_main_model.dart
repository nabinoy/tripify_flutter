class IslandAll {
  IslandImage image;
  String sId;
  String name;
  String description;
  String createdAt;
  int iV;

  IslandAll(
      {required this.image,
      required this.sId,
      required this.name,
      required this.description,
      required this.createdAt,
      required this.iV});

  factory IslandAll.fromJson(Map<String, dynamic> json) {
    return IslandAll(
        image: (json['image'] != null
            ? IslandImage.fromJson(json['image'])
            : null)!,
        sId: json['_id'],
        name: json['name'],
        description: json['description'],
        createdAt: json['createdAt'],
        iV: json['__v']);
  }
}

class IslandImage {
  String id;
  String secureUrl;

  IslandImage({required this.id, required this.secureUrl});

  factory IslandImage.fromJson(Map<String, dynamic> json) {
    return IslandImage(id: json['id'], secureUrl: json['secure_url']);
  }
}

class CategoryAll {
  CategoryImage image;
  String sId;
  String name;
  String description;
  String createdAt;
  int iV;

  CategoryAll(
      {required this.image,
      required this.sId,
      required this.name,
      required this.description,
      required this.createdAt,
      required this.iV});

  factory CategoryAll.fromJson(Map<String, dynamic> json) {
    return CategoryAll(
      image: (json['image'] != null
          ? CategoryImage.fromJson(json['image'])
          : null)!,
      sId: json['_id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['createdAt'],
      iV: json['__v'],
    );
  }
}

class CategoryImage {
  String id;
  String secureUrl;

  CategoryImage({required this.id, required this.secureUrl});

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(id: json['id'], secureUrl: json['secure_url']);
  }
}

class ServiceAll {
  ServiceImage? image;
  String? sId;
  String? name;
  String? description;
  String? createdAt;
  int? iV;

  ServiceAll(
      {required this.image,
      required this.sId,
      required this.name,
      required this.description,
      required this.createdAt,
      required this.iV});

  factory ServiceAll.fromJson(Map<String, dynamic> json) {
    return ServiceAll(
      image:
          json['image'] != null ? ServiceImage.fromJson(json['image']) : null,
      sId: json['_id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['createdAt'],
      iV: json['__v'],
    );
  }
}

class ServiceImage {
  String? id;
  String? secureUrl;

  ServiceImage({required this.id, required this.secureUrl});

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    return ServiceImage(
      id: json['id'],
      secureUrl: json['secure_url'],
    );
  }
}
