class Songs {
  int? id;
  String title;
  String? artist;
  String? album;
  int duration;
  int? playlistId;

  Songs(
      {this.id,
      required this.title,
      this.artist,
      this.album,
      required this.duration,
      this.playlistId});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "artist": artist,
      "album": album,
      "duration": duration,
      "playlist_id": playlistId
    };
  }

  factory Songs.fromMap(Map<String, dynamic> results) {
    return Songs(
        title: results["title"],
        duration: results["duration"],
        album: results["album"],
        artist: results["artist"],
        playlistId: results["playlist_id"]);
  }
}
