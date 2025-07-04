import 'package:rick_and_morty/models/location_model.dart';

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final Origin origin;
  final Location location;
  final String image;
  final List<String> episode;
  final String url;
  final DateTime created;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
      origin: Origin.fromJson(json['origin']),
      location: Location.fromJson(json['location']),
      image: json['image'],
      episode: List<String>.from(json['episode']),
      url: json['url'],
      created: DateTime.parse(json['created']),
    );
  }
}

/// Represents the Origin of a Character.
class Origin {
  final String name;
  final String url;

  Origin({required this.name, required this.url});

  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(
      name: json['name'],
      url: json['url'],
    );
  }
}