import 'package:flutter/material.dart';
import 'package:music/providers/songs_provider.dart';
import 'package:music/model/playlist.dart';
import 'package:music/screens/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MusicEnquery extends StatefulWidget {
  const MusicEnquery({super.key, required this.currentPlaylist});
  final Playlist currentPlaylist;

  @override
  State<MusicEnquery> createState() => _MusicEnqueryState();
}

class _MusicEnqueryState extends State<MusicEnquery> {
  // final OnAudioQuery _audioQuery = OnAudioQuery();
  // List<SongModel> _songs = [];
  SongModel? selectedSong;

  void selectSong(SongModel song) {
    setState(() {
      selectedSong = song;
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SongsProvider>(context, listen: false).fetchSong();
  }

  // Future<void> _requestPermissionAndFetchSongs() async {
  //   if (await Permission.storage.request().isGranted) {
  //     List<SongModel> songs = await _audioQuery.querySongs();
  //     setState(() {
  //       _songs = songs;
  //     });
  //   } else {
  //     print('Storage permission denied');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SongsProvider>(
        builder: (context, songProvider, child) {
          if (songProvider.songs.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: songProvider.songs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(songProvider.songs[index].title),
                subtitle:
                    Text(songProvider.songs[index].artist ?? 'Unknown artist'),
                leading: const Icon(Icons.music_note),
                onTap: () {
                  String songPath = songProvider.songs[index].data;
                  print("Selected song path: $songPath");
                  selectSong(songProvider.songs[index]);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => MusicPlayer(
                        // onSelectedSong: selectSong,
                        initialSong: songProvider.songs[index],
                        currentPlaylist: widget.currentPlaylist,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
