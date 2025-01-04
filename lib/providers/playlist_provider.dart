// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:music/database_handler.dart';
// import 'package:music/model/playlist.dart';
// import 'package:music/model/song_model.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:music/providers/songs_provider.dart';
// // import 'hive_manager.dart';
// // // Import your HiveManager class here
// // import 'package:music/main.dart';

// class PlaylistProvider extends ChangeNotifier {
//   final DatabaseHandler databaseHandler = DatabaseHandler();
//   final SongsProvider _songsProvider;
//   List<Playlist> _playlists = [];

//   // late List<Songs> _playlistSongs = [];
//   late List<SongModel> _playlistSongs = [];

//   List<SongModel> getPlaylistSongs() {
//     return _playlistSongs;
//   }

//   late Playlist currentPlaylist;
//   late SongModel selectedSong;

//   int? _currentSongIndex;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   Duration _currentDuration = Duration.zero;
//   Duration _totalDuration = Duration.zero;
//   bool _isPlaying = false;

//   PlaylistProvider(this._songsProvider) {
//     // Hive.box('playlistBox').clear();
//     _playlistSongs = _songsProvider.songs;
//     _loadPlaylist();
//     listenToDuration();
//   }

//   bool get isPlaying => _isPlaying;
//   Duration get currentDuration => _currentDuration;
//   Duration get totalDuration => _totalDuration;
//   // List<SongModel> get playlistSongs => _playlistSongs.cast<SongModel>();

//   set currentSongIndex(int? newIndex) {
//     _currentSongIndex = newIndex;
//     if (newIndex != null) {
//       play();
//     }
//   }

//   // Get a playlist by its name
//   Future<Playlist> getPlaylistByName(String playlistName) async {
//     _playlists = await databaseHandler.getPlaylists();
//     return _playlists.firstWhere((pl) => pl.playlistName == playlistName);
//   }

//   // Add a playlist and save it to Hive
//   Future<void> addPlaylist(Playlist playlist) async {
//     _playlists.add(playlist);
//     notifyListeners();
//     databaseHandler.insertPlaylist(playlist).catchError((error) {
//       print("error adding playlist to the database: $error");
//     });

//     // _savePlaylist();
//   }

//   Future<void> removePlaylist(Playlist playlist) async {
//     _playlists.remove(playlist);
//     notifyListeners();
//     // ignore: body_might_complete_normally_catch_error
//     databaseHandler.deletePlaylist(playlist.playlistId!).catchError((error) {
//       print("error removing playlist to the database: $error");
//     });
//     // _savePlaylist();
//   }

//   // Add multiple songs to a playlist
//   Future<void> addSongsToPlaylist(List<SongModel> songs, int playlistId) async {
//     _playlistSongs.addAll(songs);
//     notifyListeners();
//     List<Songs> newSongs = songs.map((songmodel) {
//       return Songs(
//           title: songmodel.title,
//           duration: songmodel.duration ?? 0,
//           artist: songmodel.artist,
//           album: songmodel.album,
//           playlistId: playlistId);
//     }).toList();
//     if (newSongs.isNotEmpty) {
//       // _playlistSongs.addAll(newSongs);

//       databaseHandler.insertMultipleSongs(newSongs).catchError((error) {
//         print("error adding playlist to the database: $error");
//       });

//       // _savePlaylist();

//       // Future.microtask(() => notifyListeners());
//       // notifyListeners();
//     }
//     // notifyListeners();
//   }

//   // Update songs in a specific playlist and notify listeners
//   Future<void> updatePlaylistSongs(
//       String playlistName, List<SongModel> songs) async {
//     final playlist = _playlists.firstWhere(
//         (p) => p.playlistName == playlistName,
//         orElse: () => throw Exception("Playlist not found"));
//     playlist.songs = songs;
//     notifyListeners();
//     List<Map<String, dynamic>> songMaps = songs.map((song) {
//       return {
//         'id': song.id,
//         'title': song.title,
//         'artist': song.artist,
//         'album': song.album,
//         'duration': song.duration,
//       };
//     }).toList();
//     databaseHandler.updatePlaylistSongs(playlist.playlistId!, songMaps);
//   }

//   // Remove a song from the playlist
//   Future<void> removeSongFromPlaylist(
//       String playlistName, SongModel song) async {
//     _playlistSongs.remove(song);
//     notifyListeners();
//     databaseHandler.delete(song.id!).catchError((error) {
//       print("Error removing song from database: $error");
//     });
//     // _savePlaylist();
//   }

//   // Set the playlist with new songs
//   // void setPlaylist(List<SongModel> songs) {
//   //   _playlistSongs = songs;
//   //   _savePlaylist();
//   //   notifyListeners();
//   // }

//   // Save the playlist to the Hive box
//   // Future<void> _savePlaylist(String playlistName) async {
//   //   _playlistSongs[playlistName] = await databaseHandler.getSongsList();
//   //   Future.microtask(() => notifyListeners());
//   // }

//   // Load the playlist from the Hive box
//   // void _loadPlaylist() {
//   //   final boxPlaylist = HiveManager.getPlaylistBox();
//   //   List<SongModel>? storedSongs =
//   //       (boxPlaylist.get('playlist') as List<dynamic>?)
//   //           ?.map((item) => item as SongModel)
//   //           .toList();

//   //   // List<SongModel>? storedSongs =
//   //   //     boxPlaylist.get('playlist')?.cast<SongModel>();
//   //   if (storedSongs != null) {
//   //     _playlistSongs = storedSongs;
//   //     notifyListeners();
//   //   }
//   // }

//   // void _loadPlaylist() {
//   //   final boxPlaylist = HiveManager.getPlaylistBox();

//   //   // Retrieve the stored playlist and handle the casting
//   //   List<dynamic>? storedSongs = boxPlaylist.get('playlist') as List<dynamic>?;

//   //   // Convert each dynamic item to SongModel, ensuring safe casting
//   //   if (storedSongs != null) {
//   //     _playlistSongs = storedSongs.map((item) {
//   //       if (item is SongModel) {
//   //         return item;
//   //       } else {
//   //         throw Exception('Invalid item in playlist: ${item.runtimeType}');
//   //       }
//   //     }).toList();

//   //     notifyListeners();
//   //   }
//   // }

//   // void _loadPlaylist() {
//   //   final boxPlaylist = HiveManager.getPlaylistBox();

//   //   // Retrieve the stored playlist and handle the casting
//   //   List<dynamic>? storedSongs = boxPlaylist.get('playlist') as List<dynamic>?;

//   //   // Convert each dynamic item to SongModel, ensuring safe casting
//   //   if (storedSongs != null) {
//   //     _playlistSongs = storedSongs.map<SongModel>((item) {
//   //       if (item is SongModel) {
//   //         return item;
//   //       } else {
//   //         throw Exception('Invalid item in playlist: ${item.runtimeType}');
//   //       }
//   //     }).toList();

//   //     notifyListeners();
//   //   }
//   // }
//   // void _loadPlaylist() {
//   // final boxPlaylist = HiveManager.getPlaylistBox();
//   //   var retrievedValue = boxPlaylist.get('playlist');
//   //   if (retrievedValue is List) {
//   //     List<dynamic> storedSongs =
//   //         retrievedValue!; // Now it's safe to treat it as List<dynamic>
//   //     // Proceed with the conversion
//   //     _playlistSongs = storedSongs.map<SongModel>((item) {
//   //       if (item is SongModel) {
//   //         return item;
//   //       } else {
//   //         throw Exception('Invalid item in playlist: ${item.runtimeType}');
//   //       }
//   //     }).toList();
//   //     notifyListeners();
//   //   } else {
//   //     throw Exception('Expected a List but got: ${retrievedValue.runtimeType}');
//   //   }
//   // }
//   // void _loadPlaylist() {
//   //   // final boxPlaylist = HiveManager.getPlaylistBox();
//   //   // var retrievedValue = boxPlaylist.get('playlist');

//   //   // if (retrievedValue is List) {
//   //     // Convert dynamic list into List<SongModel> by manually deserializing each element
//   //     List<SongModel> songList = retrievedValue!.map((item) {
//   //       if (item is Map) {
//   //         // Assuming the SongModel has a fromJson method for deserialization
//   //         return SongModel.fromJson(item);
//   //         // ignore: unnecessary_type_check
//   //       } else if (item is SongModel) {
//   //         return item;
//   //       } else {
//   //         throw Exception('Invalid item in playlist: ${item.runtimeType}');
//   //       }
//   //     }).toList();

//   //     _playlistSongs = songList; // Now this is safely a List<SongModel>
//   //     notifyListeners(); // Notify listeners that the playlist has changed
//   //   } else {
//   //     throw Exception('Expected a List but got: ${retrievedValue.runtimeType}');
//   //   }
//   // }

//   // Future<void> _loadPlaylist() async {
//   //   return databaseHandler.getSongsList().then((items) {
//   //     List<SongModel> songList = items.map((item) {
//   //       if (item is SongModel) {
//   //         return item;
//   //       } else {
//   //         throw Exception("invalid item in playlist");
//   //       }
//   //     }).toList();
//   //   });
//   //   // List<SongModel> songList = retrivedValue.then((items) {
//   //   //   items.map((item) {
//   //   //     if (item is SongModel) {
//   //   //       return item;
//   //   //     } else {
//   //   //       throw Exception("invalid item in playlist");
//   //   //     }
//   //   //   }).toList();
//   //   // });
//   // }

//   Future<void> _loadPlaylist() async {
//     _playlistSongs = [];
//     notifyListeners();
//     // Await the Future to get the list of items
//     var items = await databaseHandler.getSongsList();

//     // Filter and validate the items
//     List<Songs> queryList = items.map((item) {
//       if (item is SongModel) {
//         return item;
//       } else {
//         throw Exception("Invalid item in playlist");
//       }
//     }).toList();
//     // List<SongModel> songList = queryList.toSongModel();
//     _playlistSongs = queryList.toSongModel();
//     notifyListeners();

//     // Now songList contains a valid List<SongModel>
//   }
//   // Future<void> _loadPlaylist() async {
//   //   var items = await databaseHandler.getSongsList();

//   //   // Convert Songs to SongModel if necessary
//   //   List<SongModel> songList = items.map((item) {
//   //     return SongModel(
//   //       id: item.id,
//   //       title: item.title,
//   //       artist: item.artist,
//   //       album: item.album,
//   //       duration:
//   //           item.duration, // Ensure this matches the expected type in SongModel
//   //     );
//   //   }).toList();

//   //   _playlistSongs = songList;
//   //   notifyListeners();
//   // }

//   // Play the selected song
//   void play() async {
//     final String path = selectedSong.data;
//     await _audioPlayer.stop(); // Stop current song
//     await _audioPlayer.play(DeviceFileSource(path));
//     _isPlaying = true;
//     notifyListeners();
//   }

//   // Pause the current song
//   void pause() async {
//     await _audioPlayer.pause();
//     _isPlaying = false;
//     notifyListeners();
//   }

//   // Resume the song
//   void resume() async {
//     await _audioPlayer.resume();
//     _isPlaying = true;
//     notifyListeners();
//   }

//   // Pause or resume the song
//   void pauseOrResume() {
//     if (_isPlaying) {
//       pause();
//     } else {
//       resume();
//     }
//   }

//   // Seek to a specific position
//   void seek(Duration position) async {
//     await _audioPlayer.seek(position);
//   }

//   // Play the next song
//   void playNextSong() {
//     if (_currentSongIndex != null) {
//       if (_currentSongIndex! < currentPlaylist.songs!.length - 1) {
//         currentSongIndex = _currentSongIndex! + 1;
//       } else {
//         currentSongIndex = 0;
//       }
//     }
//   }

//   // Play the previous song
//   void playPreviousSong() {
//     if (_currentDuration.inSeconds > 2) {
//       seek(Duration.zero);
//     } else {
//       if (_currentSongIndex! > 0) {
//         currentSongIndex = _currentSongIndex! - 1;
//       } else {
//         currentSongIndex = currentPlaylist.songs!.length - 1;
//       }
//     }
//   }

//   // Listen to audio durations and song completion
//   void listenToDuration() {
//     _audioPlayer.onDurationChanged.listen((newDuration) {
//       _totalDuration = newDuration;
//       notifyListeners();
//     });
//     _audioPlayer.onPositionChanged.listen((newPosition) {
//       _currentDuration = newPosition;
//       notifyListeners();
//     });
//     _audioPlayer.onPlayerComplete.listen((event) {
//       playNextSong();
//     });
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     Hive.close();
//     super.dispose();
//   }
// }
