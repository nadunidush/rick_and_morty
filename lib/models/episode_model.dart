class Episode {
  final int id;
  final String name;
  final String airDate;
  final String episode; 
  final List<String> characters;
  final String url;
  final DateTime created;
  String? imageUrl; 
  double userRating; 

  Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
    required this.url,
    required this.created,
    this.imageUrl,
    this.userRating = 0.0,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      name: json['name'],
      airDate: json['air_date'],
      episode: json['episode'],
      characters: List<String>.from(json['characters']),
      url: json['url'],
      created: DateTime.parse(json['created']),
      imageUrl: json['imageUrl'], 
      userRating: (json['userRating'] as num?)?.toDouble() ?? 0.0, 
    );
  }

  //equality for easy comparison in watchlist
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Episode && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}