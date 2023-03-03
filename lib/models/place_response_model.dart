class Place {
  final String id;
  final String name;
  final String description;
  final bool entry;
  final List<Map<String, dynamic>> entryCost;
  final String island;
  final Map<String, dynamic> address;
  final Map<String, dynamic> location;
  final List<String> activities;
  final List<String> categories;
  final List<Map<String, dynamic>> images;
  final List<Map<String, dynamic>> externalLinks;
  final List<Map<String, dynamic>> timings;
  final double ratings;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.entry,
    required this.entryCost,
    required this.island,
    required this.address,
    required this.location,
    required this.activities,
    required this.categories,
    required this.images,
    required this.externalLinks,
    required this.timings,
    required this.ratings,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      entry: json['entry'],
      entryCost: List<Map<String, dynamic>>.from(json['entry_cost']),
      island: json['island'],
      address: Map<String, dynamic>.from(json['address']),
      location: Map<String, dynamic>.from(json['location']),
      activities: List<String>.from(json['activities']),
      categories: List<String>.from(json['categories']),
      images: List<Map<String, dynamic>>.from(json['images']),
      externalLinks: List<Map<String, dynamic>>.from(json['external_links']),
      timings: List<Map<String, dynamic>>.from(json['timings']),
      ratings: json['ratings'].toDouble(),
    );
  }
}
