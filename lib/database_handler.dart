// import 'dart:async';
import 'dart:core';

import 'package:music/model/playlist.dart';
import 'package:music/model/song_model.dart';
// import 'package:music/song_model_extension.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  final _dbVersion = 2;
  static Database? _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, "playlist.db");
    final db = openDatabase(
      dbPath,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON;");
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE playlists ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "title TEXT NOT NULL"
        ");");
    await db.execute("CREATE TABLE songs ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "title TEXT NOT NULL,"
        "artist TEXT,"
        "album TEXT,"
        "duration INTEGER NOT NULL,"
        "playlist_id INTEGER,"
        "FOREIGN KEY (playlist_id) REFERENCES playlists(id)"
        ");");
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // await db.execute("ALTER TABLE songs ADD COLUMN playlist_id INTEGER;");
      await db.execute("CREATE TABLE playlists ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title TEXT NOT NULL"
          ")");
    }
  }

  Future<void> deleteDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, "playlist.db");
    await databaseFactory.deleteDatabase(dbPath);
    _db = null; // Reset the database instance
  }

  Future<int> insert(Songs song) async {
    final dbClient = await db;
    return await dbClient.insert("songs", song.toMap());
  }

  Future<List<Songs>> insertMultipleSongs(List<Songs> songs) async {
    final dbClient = await db;
    if (songs.isEmpty) return [];
    Batch batch = dbClient.batch();

    for (var song in songs) {
      batch.insert("songs", song.toMap());
    }

    await batch.commit(noResult: true);
    return songs;
  }

  Future<void> insertPlaylist(Playlist playlist) async {
    final dbClient = await db;
    await dbClient.insert("playlists", playlist.toMap());
  }

  Future<void> createPlaylist(String playlistName) async {
    final dbClient = await db;
    await dbClient.insert(
      "playlists",
      {"title": playlistName},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Songs>> getSongsList() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> queryResults =
        await dbClient.query("songs");
    List<Songs> songsList =
        queryResults.map((song) => Songs.fromMap(song)).toList();
    return songsList.reversed.toList();
  }

  Future<List<Playlist>> getPlaylists() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> queryResults =
        await dbClient.query("playlists");
    List<Playlist> playlists =
        queryResults.map((playlist) => Playlist.fromMap(playlist)).toList();
    return playlists.reversed.toList();
  }

  Future<int> delete(int id) async {
    final dbClient = await db;
    return dbClient.delete("songs", where: "id=?", whereArgs: [id]);
  }

  Future<int> deletePlaylist(int id) async {
    final dbClient = await db;
    return dbClient.delete("playlists", where: "id=?", whereArgs: [id]);
  }

  Future<int> update(Songs song) async {
    final dbClient = await db;
    return await dbClient
        .update("songs", song.toMap(), where: "id=?", whereArgs: [song.id]);
  }

  Future<void> updatePlaylistSongs(
      int playlistId, List<Map<String, dynamic>> songsMap) async {
    final dbClient = await db;
    for (var songMap in songsMap) {
      await dbClient.update(
          "songs",
          {
            ...songMap,
            "playlist_id": playlistId,
          },
          where: "playlist_id=? AND id=?",
          whereArgs: [playlistId, songMap["id"]],
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
