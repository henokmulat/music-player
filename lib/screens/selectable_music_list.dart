import 'package:flutter/material.dart';
import 'package:music/database_handler.dart';
import 'package:music/model/playlist.dart';
// import 'package:music/model/song_model.dart';r
// import 'package:music/providers/playlist_provider.dart';
import 'package:music/providers/playlists_provider.dart';
import 'package:music/providers/songs_provider.dart';
import 'package:music/providers/theme_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

class SelectableMusicScreen extends StatefulWidget {
  const SelectableMusicScreen({required this.currentPlaylist, super.key});
  final Playlist currentPlaylist;

  @override
  State<SelectableMusicScreen> createState() => _SelectableMusicScreenState();
}

class _SelectableMusicScreenState extends State<SelectableMusicScreen> {
  List<SongModel> selectedSongs = [];
  // late Future<List<Songs>> songList = Future.value([]);
  DatabaseHandler databaseHandler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((callback) {
    Future.microtask(() {
      Provider.of<SongsProvider>(
        context,
        listen: false,
      ).fetchSong();
    });
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

  Future<void> onDone() async {
    if (selectedSongs.isNotEmpty) {
      Provider.of<PlaylistsProvider>(context, listen: false).addSongsToPlaylist(
          selectedSongs, widget.currentPlaylist.playlistId!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${selectedSongs.length} songs add to the playlist"),
          ),
        );
      }
      if (mounted) {
        print("Popping the screen");
        print("Selected songs: $selectedSongs");
        Navigator.of(context).pop(selectedSongs);
      }
    } else {
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Container(
        decoration: BoxDecoration(
          image: themeProvider.backgroundImagePath != null
              ? DecorationImage(
                  image: AssetImage(themeProvider.backgroundImagePath!),
                  fit: BoxFit.cover)
              : const DecorationImage(
                  image: AssetImage(
                    "assets/images/moon.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Select songs'),
            actions: [
              IconButton(
                icon: const Icon(Icons.done),
                onPressed: onDone,
              ),
            ],
          ),
          body:
              Consumer<SongsProvider>(builder: (context, songProvider, child) {
            if (songProvider.songs.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: songProvider.songs.length,
                itemBuilder: (context, index) {
                  SongModel song = songProvider.songs[index];
                  bool isSelected = selectedSongs.contains(song);

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
                    trailing: Icon(
                      isSelected
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                      color: isSelected ? Colors.green : null,
                    ),
                    onTap: () {
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          if (isSelected) {
                            selectedSongs.remove(song);
                          } else {
                            selectedSongs.add(song);
                          }
                          // });
                          // Add Your Code here.
                        });
                      }
                      // setState(() {
                      //   if (isSelected) {
                      //     selectedSongs.remove(song);
                      //   } else {
                      //     selectedSongs.add(song);
                      //   }
                      //   // });
                      //   // Add Your Code here.
                      // });
                    },
                  );
                });
          }),
        ),
      );
    });
  }
}
