import 'package:flutter/material.dart';
import 'package:music/providers/playlists_provider.dart';
import 'package:music/providers/songs_provider.dart';
import 'package:music/providers/theme_provider.dart';
import 'package:music/screens/default_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

class DefaultList extends StatefulWidget {
  const DefaultList({super.key});

  @override
  State<DefaultList> createState() => _DefaultListState();
}

class _DefaultListState extends State<DefaultList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SongsProvider>(
        context,
        listen: false,
      ).fetchSong();
    });
    requestPermissions();
    _updateThemeFromImage(
        context,
        Provider.of<ThemeProvider>(context, listen: false)
                .backgroundImagePath ??
            "assets/images/eight.jpg");
  }

  Future<void> _updateThemeFromImage(
      BuildContext context, String imagePath) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      AssetImage(imagePath),
      maximumColorCount: 10,
    );
    final primaryColor = paletteGenerator.dominantColor?.color ?? Colors.yellow;
    final accentColor = paletteGenerator.paletteColors.length > 1
        ? paletteGenerator.paletteColors[1].color
        : primaryColor;
    if (mounted) {
      Provider.of<ThemeProvider>(this.context, listen: false)
          .updateThemeFromColors(primaryColor, accentColor);
      Provider.of<ThemeProvider>(this.context, listen: false)
          .updateBackgroundImage(imagePath);
    }
  }

  final OnAudioQuery audioQuery = OnAudioQuery();

  Future<void> requestPermissions() async {
    // Check if permissions are granted
    bool permissionStatus = await audioQuery.permissionsStatus();

    if (!permissionStatus) {
      // Request permissions
      permissionStatus = await audioQuery.permissionsRequest();
    }

    if (!permissionStatus) {
      print("Permissions are not granted. Cannot play the song.");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SongModel selectedSong;
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            image: themeProvider.backgroundImagePath != null
                ? DecorationImage(
                    image: AssetImage(themeProvider.backgroundImagePath!),
                    fit: BoxFit.cover)
                // : const DecorationImage(
                //     image: AssetImage(
                //       "assets/images/eight.jpg",
                //     ),
                //     fit: BoxFit.cover,
                //   ),
                : null,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Default list'),
              actions: [
                Consumer<PlaylistsProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                        PopupMenuButton(
                          color: Colors.black,
                          shadowColor: Colors.white10,
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: TextButton(
                                child: const Text(
                                  'Select',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  // style: themeProvider
                                  //     .themeData.textTheme.titleSmall,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: provider.toggleShuffle,
                                child: const Text(
                                  'Shuffle all',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: provider.playNextSongDefault,
                                child: const Text(
                                  'Play next',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              child: TextButton(
                                child: const Text(
                                  'Sort by',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
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
                    SongModel song = songProvider.songs[index];

                    return ListTile(
                      title: Text(song.title,
                          style: TextStyle(color: Colors.grey.shade50)),
                      subtitle: Text(song.artist ?? 'Unknown artist'),
                      leading: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: Icon(
                          Icons.music_note,
                          color: Colors.grey.shade50,
                        ),
                      ),
                      onTap: () {
                        final playlistProvider = Provider.of<PlaylistsProvider>(
                            context,
                            listen: false);
                        playlistProvider.currentPlaylist =
                            playlistProvider.getPlaylistByName("Default");
                        playlistProvider.currentSongIndex = index;
                        print("index:$index");
                        print(
                            "currentIndex:${playlistProvider.currentSongIndex}");
                        selectedSong = song;

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => DefaultPlayer(
                                initialSong: selectedSong,
                                currentPlaylist:
                                    playlistProvider.currentPlaylist)));
                        // final playlistProvider = Provider.of<PlaylistsProvider>(
                        //     context,
                        //     listen: false);
                        // playlistProvider.loadSong(song);
                        print("selected song:$selectedSong");
                      },
                    );
                  });
            }),
          ),
        );
      },
    );
  }
}
