import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerLists extends StatelessWidget {
  PlayerLists({super.key});
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<AlbumModel>> fetchAlbums() async {
    List<AlbumModel> albums = await _audioQuery.queryAlbums();
    return albums;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {},
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 36,
                        child: Image.asset(
                          'lib/icons/musical-note.png',
                          color: Colors.yellow,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'TRACKS',
                        style: TextStyle(color: Colors.white),
                      ),
                      const Text(
                        '(444)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: fetchAlbums,
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 36,
                        child: Image.asset(
                          'lib/icons/music-album.png',
                          color: Colors.yellow,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'ALBUMS',
                        style: TextStyle(color: Colors.white),
                      ),
                      const Text(
                        '(444)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 36,
                        child: Image.asset(
                          'lib/icons/man-user.png',
                          color: Colors.yellow,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'ARTISTS',
                        style: TextStyle(color: Colors.white),
                      ),
                      const Text(
                        '(444)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {},
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 36,
                        child: Image.asset(
                          'lib/icons/folder.png',
                          color: Colors.yellow,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Folders',
                        style: TextStyle(color: Colors.white),
                      ),
                      const Text(
                        '(444)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 36,
                        child: Image.asset(
                          'lib/icons/electric-guitar.png',
                          color: Colors.yellow,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'GENRES',
                        style: TextStyle(color: Colors.white),
                      ),
                      const Text(
                        '(444)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 36,
                        child: Image.asset(
                          'lib/icons/zoom.png',
                          color: Colors.yellow,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'VIDEOS',
                        style: TextStyle(color: Colors.white),
                      ),
                      const Text(
                        '(444)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
