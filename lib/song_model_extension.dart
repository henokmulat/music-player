import 'package:on_audio_query/on_audio_query.dart'; // Import the SongModel

extension SongModelExtension on SongModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      // Add any other fields you need to store
    };
  }
}
