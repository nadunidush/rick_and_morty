import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rick_and_morty/models/character_model.dart';
import 'package:rick_and_morty/models/episode_model.dart';

class RickAndMortyApiService {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';
  static const String _tmdbBaseEpisodeUrl = 'https://api.themoviedb.org/3/tv/60625-rick-and-morty/season/1/episode';
  static const String _tmdbImageUrlPrefix = 'https://image.tmdb.org/t/p/w500';
  static const String _tmdbApiKey = 'fb7bb23f03b6994dafc674c074d01761';

  //Fetches a list of all characters with pagination.
  Future<List<Character>> fetchCharacters(int page) async {
    final response = await http.get(Uri.parse('$_baseUrl/character/?page=$page'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters: ${response.statusCode}');
    }
  }

  //Get a single character by ID.
  Future<Character> fetchCharacterById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/character/$id'));

    if (response.statusCode == 200) {
      return Character.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load character with ID: $id - ${response.statusCode}');
    }
  }


  //Currently fetches all episodes by iterating through pages.
  Future<List<Episode>> fetchAllEpisodes() async {
    List<Episode> allEpisodes = [];
    int page = 1;
    bool hasMore = true;

    while (hasMore) {
      final response = await http.get(Uri.parse('$_baseUrl/episode/?page=$page'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        allEpisodes.addAll(results.map((json) => Episode.fromJson(json)).toList());

        final Map<String, dynamic> info = data['info'];
        hasMore = info['next'] != null;
        if (hasMore) {
          page++;
        }
      } else {
        throw Exception('Failed to load episodes on page $page: ${response.statusCode}');
      }
    }
    for (var episode in allEpisodes) {
      try {
        final episodeNumberMatch = RegExp(r'E(\d+)').firstMatch(episode.episode);
        if (episodeNumberMatch != null) {
          final tmdbEpisodeId = int.tryParse(episodeNumberMatch.group(1)!);
          if (tmdbEpisodeId != null) {
            episode.imageUrl = await fetchEpisodeImage(tmdbEpisodeId);
          }
        }
      } catch (e) {
        print('Error fetching image for episode ${episode.id}: $e');
        episode.imageUrl = null; // Set to null if image fetching fails
      }
    }
    return allEpisodes;
  }

  //get episode image
  Future<String?> fetchEpisodeImage(int tmdbEpisodeNumber) async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/tv/60625-rick-and-morty/season/1/episode/$tmdbEpisodeNumber/images?api_key=$_tmdbApiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['stills'] != null && data['stills'].isNotEmpty) {
        final String filePath = data['stills'][0]['file_path'];
        return '$_tmdbImageUrlPrefix$filePath';
      }
    }
    return null; 
  }
}