import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/episode_model.dart';

class WatchlistManager {
  final ValueNotifier<List<Episode>> _watchlist = ValueNotifier<List<Episode>>([]);

  ValueListenable<List<Episode>> get watchlist => _watchlist;

  //Adds an episode to the watchlist if not already present.
  void addEpisode(Episode episode) {
    if (!_watchlist.value.contains(episode)) {
      _watchlist.value = List.from(_watchlist.value)..add(episode);
      print('Added episode ${episode.name} to watchlist.');
    }
  }

  //Removes an episode from the watchlist.
  void removeEpisode(Episode episode) {
    _watchlist.value = List.from(_watchlist.value)..remove(episode);
    print('Removed episode ${episode.name} from watchlist.');
  }

  //Checks if an episode is in the watchlist.
  bool containsEpisode(Episode episode) {
    return _watchlist.value.contains(episode);
  }
}