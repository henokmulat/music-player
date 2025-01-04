import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class SongsProvider extends ChangeNotifier {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];
  List<SongModel> get songs => _songs;

  Future<void> fetchSong() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      _songs = await _audioQuery.querySongs();
      notifyListeners();
    } else {
      print('Storage permission denied!');
    }
  }
}
