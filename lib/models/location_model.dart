class Location {
  final String name;
  final String url;

  Location({required this.name, required this.url});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      url: json['url'],
    );
  }
}