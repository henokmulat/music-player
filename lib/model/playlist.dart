import 'package:on_audio_query/on_audio_query.dart';

class Playlist {
  Playlist({required this.playlistName, this.songs, this.playlistId});
  final String playlistName;
  List<SongModel>? songs;
  int? playlistId;

  Map<String, dynamic> toMap() {
    return {
      "id": playlistId,
      "title": playlistName,
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> results) {
    return Playlist(playlistName: results["title"], playlistId: results["id"]);
  }
}
