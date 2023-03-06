final urlImages = [
  'https://images.unsplash.com/photo-1473116763249-2faaef81ccda?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1196&q=80',
  'https://images.unsplash.com/photo-1515238152791-8216bfdf89a7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1172&q=80',
  'https://images.unsplash.com/photo-1468413253725-0d5181091126?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
  'https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
  'https://images.unsplash.com/photo-1473186578172-c141e6798cf4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1073&q=80',
];

final urlImagesText = [
  'North Andaman',
  'Middle Andaman',
  'South Andaman',
  'Swaraj Dweep',
  'Shaheed Dweep'
];

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
