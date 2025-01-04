import 'dart:io';
import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/database_handler.dart';
import 'package:music/model/playlist.dart';
import 'package:music/model/song_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlaylistsProvider extends ChangeNotifier {
  final DatabaseHandler databaseHandler = DatabaseHandler();

  List<Playlist> _playlists = [];
  late Playlist currentPlaylist;

  List<SongModel> _playlistSongs = [];
  List<SongModel> songs = [];
  List<SongModel> _originalSongs = [];

  List<SongModel> _currentSongs = [];
  bool _isShuffling = false;
  //wave form
  late PlayerController _waveformController;
  PlayerController get waveformController => _waveformController;

  // Setter for _waveformController
  set waveformController(PlayerController controller) {
    // Optionally dispose the old controller before setting a new one
    _waveformController.dispose();
    _waveformController = controller;
  }

  void fetchSongs() async {
    final List<SongModel> fetchedSongs = await OnAudioQuery().querySongs();
    songs = fetchedSongs;
    intializeShuffleList();
  }

  void intializeShuffleList() {
    if (songs.isNotEmpty) {
      _originalSongs = List.from(songs);
      _currentSongs = List.from(songs);
    }
  }

  void shuffleSongs() {
    final random = Random();
    // _currentSongs = List.from(_originalSongs);
    _currentSongs.shuffle(random);
    currentSongIndex = 0;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffling = !_isShuffling;
    if (_isShuffling) {
      shuffleSongs();
      loadSong(_currentSongs[_currentSongIndex!]);
    } else {
      _currentSongs = List.from(_originalSongs);
      loadSong(_currentSongs[_currentSongIndex!]);
    }
    notifyListeners();
  }

  List<SongModel> getPlaylistSongs() {
    return _playlistSongs;
  }

  late SongModel selectedSong;

  int? _currentSongIndex;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;
  int? get currentSongIndex => _currentSongIndex;

  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentDuration(Duration newDuration) {
    _currentDuration = newDuration;
  }

  PlaylistsProvider() {
    _loadPlaylist();
    listenToDuration();
    // listenToDurationDefault();
  }

  set currentSongIndex(int? newIndex) {
    print("setter for currentSongIndex is called with newIndex:$newIndex");
    if (_currentSongs.isEmpty) {
      print("_currentSongs is empty");
    }
    if (newIndex != null && newIndex >= 0 && newIndex < _currentSongs.length) {
      _currentSongIndex = newIndex; // Set the current song index
      play();
      notifyListeners(); // Call play only if the new index is valid
    } else {
      print("Invalid index for currentSongIndex: $newIndex");
    }
  }

  // String get currentSongTitle {
  //   return _currentSongIndex != null &&
  //           _currentSongIndex! < _currentSongs.length - 1
  //       ? _currentSongs[_currentSongIndex!].title
  //       : "No Song Playing"; // Default text if no song is playing
  // }

  String get currentSongTitle {
    return _currentSongIndex != null &&
            _currentSongIndex! >= 0 &&
            _currentSongIndex! < _currentSongs.length
        ? _currentSongs[_currentSongIndex!].title
        : "No Song Playing"; // Default text if no song is playing
  }

  SongModel get currentDefaultSong {
    return _currentSongIndex != null &&
            _currentSongIndex! < _currentSongs.length
        ? _currentSongs[_currentSongIndex!]
        : _currentSongs[0];
  }

  //default play next
  void playNextSongDefault() {
    if (_currentSongIndex! < _currentSongs.length - 1) {
      _currentSongIndex = _currentSongIndex! + 1;
    } else {
      _currentSongIndex = 0; // Loop back to the first song.
    }
    loadSong(_currentSongs[_currentSongIndex!]);
    notifyListeners();
  }

  // Play the previous song
  void playPreviousSongDefault() {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _currentSongs.length - 1;
      }
      loadSong(_currentSongs[_currentSongIndex!]);
      notifyListeners();
    }
  }

  Playlist getPlaylistByName(String playlistName) {
    // _playlists = await databaseHandler.getPlaylists();
    return _playlists.firstWhere(
      (pl) => pl.playlistName == playlistName,
      orElse: () => Playlist(playlistName: "Default", songs: []),
    );
  }

  // void loadSong(SongModel song) async {
  //   selectedSong = song;
  //   String path = song.data;
  //   print("Selected song path: ${song.data}");

  //   _audioPlayer.stop();
  //   try {
  //     await _audioPlayer.play(DeviceFileSource(path));
  //     _isPlaying = true;
  //     _currentDuration = Duration.zero;

  //     _audioPlayer.onDurationChanged.listen((duration) {
  //       _totalDuration = duration;
  //       notifyListeners();
  //     });

  //     _audioPlayer.onPositionChanged.listen((newPosition) {
  //       _currentDuration = newPosition;
  //       notifyListeners();
  //     });

  //     _audioPlayer.onPlayerComplete.listen((_) {
  //       _isPlaying = false;
  //       _currentDuration = Duration.zero;
  //       notifyListeners();
  //       playNextSong();
  //     });
  //   } catch (e) {
  //     print("Error playing song:$e");
  //   }

  //   notifyListeners();
  // }
  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  void loadSong(SongModel song) async {
    requestStoragePermission();
    selectedSong = song;
    _waveformController = PlayerController();

    String path = song.data;

    File file = File(path);
    if (!await file.exists()) {
      print("File does not exist or cannot be accessed at path: $path");
      return;
    }
    print("Selected song path: ${song.data}");

    if (_isPlaying) {
      await _audioPlayer.stop();
    }

    try {
      _audioPlayer.onDurationChanged.listen((duration) {
        _totalDuration = duration;
        notifyListeners();
      });

      _audioPlayer.onPositionChanged.listen((newPosition) {
        _currentDuration = newPosition;
        notifyListeners();
      });

      _audioPlayer.onPlayerComplete.listen((_) {
        _isPlaying = false;
        _currentDuration = Duration.zero;
        playNextSongDefault();
        notifyListeners();
      });

      await _audioPlayer.play(DeviceFileSource(path));
      _isPlaying = true;
      _currentDuration = Duration.zero;
      _waveformController.startPlayer();
    } catch (e) {
      print("Error playing song: $e");
    }

    notifyListeners(); // Notify listeners once at the end
  }

  void updatePosition(Duration position) {
    _currentDuration = position;
    notifyListeners();
  }

  // Example using SQLite
  Future<void> initializePlaylists() async {
    // Check if default playlists exist
    final defaultPlaylist = getPlaylistByName("Default list");
    final recentPlaylist = getPlaylistByName('Recently Added');

    // Create "Default" playlist if it doesn't exist
    if (defaultPlaylist == Playlist(playlistName: "Default", songs: [])) {
      await databaseHandler.createPlaylist("Default list");
    }

    // Create "Recently Added" playlist if it doesn't exist
    if (recentPlaylist == Playlist(playlistName: "Default list", songs: [])) {
      await databaseHandler.createPlaylist("Recently Added");
    }
  }

  // Add a playlist and save it to Hive
  void addPlaylist(Playlist playlist) async {
    _playlists.add(playlist);
    notifyListeners();
    databaseHandler.insertPlaylist(playlist).catchError((error) {
      print("error adding playlist to the database: $error");
    });

    // _savePlaylist();
  }

  void removePlaylist(Playlist playlist) async {
    _playlists.remove(playlist);
    notifyListeners();
    // ignore: body_might_complete_normally_catch_error
    databaseHandler.deletePlaylist(playlist.playlistId!).catchError((error) {
      print("error removing playlist to the database: $error");
    });
    // _savePlaylist();
  }

  // Add multiple songs to a playlist
  void addSongsToPlaylist(List<SongModel> songs, int playlistId) async {
    // await databaseHandler.deleteDatabase();
    // await databaseHandler.db;
    _playlistSongs.addAll(songs);
    notifyListeners();
    List<Songs> newSongs = songs.map((songmodel) {
      return Songs(
          title: songmodel.title,
          duration: songmodel.duration ?? 0,
          artist: songmodel.artist,
          album: songmodel.album,
          playlistId: playlistId);
    }).toList();
    if (newSongs.isNotEmpty) {
      // _playlistSongs.addAll(newSongs);

      databaseHandler.insertMultipleSongs(newSongs).catchError((error) {
        print("error adding playlist to the database: $error");
      });
    }
  }

  // Update songs in a specific playlist and notify listeners
  void updatePlaylistSongs(String playlistName, List<SongModel> songs) async {
    final playlist = _playlists.firstWhere(
        (p) => p.playlistName == playlistName,
        orElse: () => throw Exception("Playlist not found"));
    playlist.songs = songs;
    _playlistSongs = songs;
    _loadPlaylist();
    notifyListeners();
    List<Map<String, dynamic>> songMaps = songs.map((song) {
      return {
        'id': song.id,
        'title': song.title,
        'artist': song.artist,
        'album': song.album,
        'duration': song.duration,
      };
    }).toList();
    databaseHandler.updatePlaylistSongs(playlist.playlistId!, songMaps);
  }

  // Remove a song from the playlist
  void removeSongFromPlaylist(String playlistName, SongModel song) {
    _playlistSongs.remove(song);
    notifyListeners();
    // ignore: body_might_complete_normally_catch_error
    databaseHandler.delete(song.id).catchError((error) {
      print("Error removing song from database: $error");
    });
    // _savePlaylist();
  }

  void _loadPlaylist() async {
    _playlistSongs = [];
    notifyListeners();

    _playlists = await databaseHandler.getPlaylists();

    // Await the Future to get the list of items
    var items = await databaseHandler.getSongsList();

    // Filter and validate the items
    List<Songs> queryList = items.map((item) {
      if (item is SongModel) {
        return item;
      } else {
        throw Exception("Invalid item in playlist");
      }
    }).toList();
    // List<SongModel> songList = queryList.toSongModel();
    _playlistSongs = queryList.toSongModel();
    notifyListeners();
  }

  //play the selected song
  void play() async {
    final String path = selectedSong.data;
    await _audioPlayer.stop(); // Stop current song
    await _audioPlayer.play(DeviceFileSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // Pause the current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Resume the song
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // Pause or resume the song
  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  // Seek to a specific position
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Play the next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _currentSongs.length - 1) {
        currentSongIndex = _currentSongs.length + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  // Play the previous song
  void playPreviousSong() {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = currentPlaylist.songs!.length - 1;
      }
    }
  }

  // Listen to audio durations and song completion
  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      if (currentPlaylist.playlistName == "Default") {
        playNextSongDefault();
      } else {
        playNextSong();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
