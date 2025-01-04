import 'package:flutter/material.dart';
import 'package:music/database_handler.dart';
// import 'package:hive/hive.dart';
import 'package:music/model/playlist.dart';
// import 'package:music/model/song_model.dart';
import 'package:music/providers/playlists_provider.dart';
import 'package:music/providers/theme_provider.dart';
import 'package:music/screens/player.dart';
import 'package:music/screens/selectable_music_list.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
// import 'package:music/widgets/music_enquery.dart';

class Ontapplaylist extends StatefulWidget {
  const Ontapplaylist({required this.currentPlaylist, super.key});

  final Playlist currentPlaylist;

  @override
  State<Ontapplaylist> createState() => _OntapplaylistState();
}

class _OntapplaylistState extends State<Ontapplaylist> {
  // List<SongModel>? playlistSongs;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlaylistsProvider>(context, listen: false)
          .addPlaylist(widget.currentPlaylist);
      // playlistSongs = widget.currentPlaylist.songs;
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

  DatabaseHandler databaseHandler = DatabaseHandler();

  late List<SongModel> selectedSongs;

  // @override
  // Widget build(BuildContext context) {
  //   // Widget content = const Text('oops');
  //   return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
  //     return Container(
  //         decoration: BoxDecoration(
  //           image: themeProvider.backgroundImagePath != null
  //               ? DecorationImage(
  //                   image: AssetImage(themeProvider.backgroundImagePath!),
  //                   fit: BoxFit.cover)
  //               : const DecorationImage(
  //                   image: AssetImage(
  //                     "assets/images/beauty.jpg",
  //                   ),
  //                   fit: BoxFit.cover,
  //                 ),
  //         ),
  //         child: Scaffold(
  //           appBar: AppBar(
  //             title: Text(widget.currentPlaylist.playlistName),
  //             actions: [
  //               IconButton(
  //                 icon: const Icon(Icons.search),
  //                 onPressed: () {},
  //               ),
  //               (
  //                 icon: const Icon(Icons.more_vert),
  //                 itemBuilder: (context) => [
  //                   PopupMenuItem(
  //                     child: TextButton(
  //                       child: const Text('Select'),
  //                       onPressed: () {},
  //                     ),
  //                   ),
  //                   PopupMenuItem(
  //                     child: TextButton(
  //                       child: const Text('Shuffle all'),
  //                       onPressed: () {},
  //                     ),
  //                   ),
  //                   PopupMenuItem(
  //                     child: TextButton(
  //                       child: const Text('Play next'),
  //                       onPressed: () {},
  //                     ),
  //                   ),
  //                   PopupMenuItem(
  //                     child: TextButton(
  //                       child: const Text('Add songs'),
  //                       onPressed: () {},
  //                     ),
  //                   ),
  //                   PopupMenuItem(
  //                     child: TextButton(
  //                       child: const Text('Sort by'),
  //                       onPressed: () {},
  //                     ),
  //                   ),
  //                   PopupMenuItem(
  //                     child: TextButton(
  //                       child: Text(
  //                           'Clear ${widget.currentPlaylist.playlistName}'),
  //                       onPressed: () {},
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           body: Consumer<PlaylistsProvider>(
  //             builder: (context, playlistProvider, child) {
  //               // return FutureBuilder<Playlist>(
  //               //     future: playlistProvider.getPlaylistByName(widget
  //               //         .currentPlaylist.playlistName), // Get the playlist future
  //               //     builder: (context, snapshot) {
  //               //       if (snapshot.connectionState == ConnectionState.waiting) {
  //               //         return const Center(
  //               //             child:
  //               //                 CircularProgressIndicator()); // Show a loading indicator while waiting
  //               //       } else if (snapshot.hasError) {
  //               //         return Text('Error: ${snapshot.error}');
  //               //       } else if (!snapshot.hasData || snapshot.data == null) {
  //               //         return const Text('Playlist not found');
  //               //       } else {
  //               // final playlist = snapshot.data!;
  //               playlistProvider.addPlaylist(widget.currentPlaylist);
  //               final playlist = playlistProvider
  //                   .getPlaylistByName(widget.currentPlaylist.playlistName);
  //               List<SongModel>? playlistSongs = playlist.songs;
  //               if (playlistSongs == null || playlistSongs.isEmpty) {
  //                 return Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                  PopupMenuButton     SizedBox(
  //                         height: 150,
  //                         child: Image.asset(
  //                           'lib/icons/musical-note.png',
  //                           fit: BoxFit.cover,
  //                           color: const Color.fromARGB(150, 158, 158, 158),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 18,
  //                       ),
  //                       const Text(
  //                         'No music Found',
  //                         style: TextStyle(color: Colors.white54),
  //                       ),
  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                       ElevatedButton.icon(
  //                         onPressed: () async {
  //                           final currentContext = context;
  //                           final providerInstance =
  //                               Provider.of<PlaylistsProvider>(currentContext,
  //                                   listen: false);
  //                           final result = await Navigator.of(context)
  //                               .push<List<SongModel>>(
  //                             MaterialPageRoute(
  //                               builder: (ctx) => SelectableMusicScreen(
  //                                   currentPlaylist: widget.currentPlaylist),
  //                             ),
  //                           );

  //                           if (result != null && mounted) {
  //                             // ignore: use_build_context_synchronously
  //                             setState(() {
  //                               playlistSongs = result;
  //                             });

  //                             providerInstance.updatePlaylistSongs(
  //                                 widget.currentPlaylist.playlistName, result);
  //                           }
  //                         },
  //                         icon: const Icon(
  //                           Icons.add,
  //                           color: Colors.yellow,
  //                         ),
  //                         label: const Text('Add song',
  //                             style: TextStyle(color: Colors.yellow)),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               }
  //               return FutureBuilder<List<Songs>>(
  //                   future: databaseHandler.getSongsList(),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.connectionState == ConnectionState.waiting) {
  //                       return const Center(child: CircularProgressIndicator());
  //                     } else if (snapshot.hasError) {
  //                       return Center(
  //                         child: Text('Error: ${snapshot.error}'),
  //                       );
  //                     } else if (snapshot.hasData) {
  //                       // final songs = snapshot.data!;
  //                       return ListView.builder(
  //                           itemCount: playlistSongs!.length,
  //                           itemBuilder: (context, index) {
  //                             final song = playlistSongs![index];
  //                             return ListTile(
  //                               title: Text(song.title),
  //                               subtitle: Text(song.artist ?? 'Unknown artist'),
  //                               leading: QueryArtworkWidget(
  //                                 id: song.id,
  //                                 type: ArtworkType.AUDIO,
  //                                 nullArtworkWidget:
  //                                     const Icon(Icons.music_note),
  //                               ),
  //                               // trailing: IconButton(
  //                               //   icon: const Icon(Icons.remove),
  //                               //   onPressed: () {
  //                               //     Provider.of<PlaylistProvider>(context, listen: false)
  //                               //         .removeSongFromPlaylist(
  //                               //             playlistProvider.playlistSongs[index]);
  //                               //   },
  //                               // ),
  //                               onTap: () {
  //                                 Navigator.of(context).push(
  //                                   MaterialPageRoute(
  //                                     builder: (ctx) => MusicPlayer(
  //                                         // onSelectedSong: (String song) =>
  //                                         //     currentPlaylist.songs[index],
  //                                         currentPlaylist:
  //                                             widget.currentPlaylist,
  //                                         initialSong: song),
  //                                   ),
  //                                 );
  //                               },
  //                             );
  //                           });
  //                     } else {
  //                       return const Center(
  //                         child: Text("No songs found"),
  //                       );
  //                     }
  //                   });
  //             },
  //           ),
  //         ));
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            image: themeProvider.backgroundImagePath != null
                ? DecorationImage(
                    image: AssetImage(themeProvider.backgroundImagePath!),
                    fit: BoxFit.cover)
                : const DecorationImage(
                    image: AssetImage("assets/images/eight.jpg"),
                    fit: BoxFit.cover,
                  ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.currentPlaylist.playlistName),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                // Popup menu items...
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: TextButton(
                        child: const Text('Select'),
                        onPressed: () {},
                      ),
                    ),
                    PopupMenuItem(
                      child: TextButton(
                        child: const Text('Shuffle all'),
                        onPressed: () {},
                      ),
                    ),
                    PopupMenuItem(
                      child: TextButton(
                        child: const Text('Play next'),
                        onPressed: () {},
                      ),
                    ),
                    PopupMenuItem(
                      child: TextButton(
                        child: const Text('Add songs'),
                        onPressed: () {},
                      ),
                    ),
                    PopupMenuItem(
                      child: TextButton(
                        child: const Text('Sort by'),
                        onPressed: () {},
                      ),
                    ),
                    PopupMenuItem(
                      child: TextButton(
                        child: Text(
                            'Clear ${widget.currentPlaylist.playlistName}'),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Consumer<PlaylistsProvider>(
                builder: (context, playlistProvider, child) {
              // return FutureBuilder<Playlist>(
              // future: playlistProvider.getPlaylistByName(widget
              //     .currentPlaylist.playlistName), // Await the playlist
              // builder: (context, snapshot) {
              //   if (snapshot.connectionState == ConnectionState.waiting) {
              //     return const Center(child: CircularProgressIndicator());
              //   } else if (snapshot.hasError) {
              //     return Center(child: Text('Error: ${snapshot.error}'));
              //   } else if (!snapshot.hasData) {
              //     return const Center(child: Text('Playlist not found'));
              //   } else {
              // Playlist playlist = snapshot.data!;
              // playlistSongs = playlist.songs;
              Playlist playlist = playlistProvider
                  .getPlaylistByName(widget.currentPlaylist.playlistName);
              List<SongModel>? playlistSongs = playlist.songs;
              print("playlistSongs1:$playlistSongs");
              // List<SongModel>? playlistSongs = playlistProvider
              //     .getPlaylistByName(
              //         widget.currentPlaylist.playlistName)
              //     ?.songs;

              print("playlist:$playlist");
              if (playlistSongs == null) {
                // return const Center(
                //   child: Text(" playlistSongs is null"),
                // );
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image and message...
                      SizedBox(
                        height: 150,
                        child: Image.asset(
                          'lib/icons/musical-note.png',
                          fit: BoxFit.cover,
                          color: const Color.fromARGB(150, 158, 158, 158),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const Text(
                        'playlistSongs is null',
                        style: TextStyle(color: Colors.white54),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, color: Colors.yellow),
                        label: const Text('Add song',
                            style: TextStyle(color: Colors.yellow)),
                        onPressed: () {
                          Navigator.of(context)
                              .push<List<SongModel>>(
                            MaterialPageRoute(
                              builder: (ctx) => SelectableMusicScreen(
                                  currentPlaylist: widget.currentPlaylist),
                            ),
                          )
                              .then((result) {
                            if (result != null && mounted) {
                              print("result:$result");
                              // playlistSongs = result;
                              // setState(() {

                              print(
                                  "playlistSongs:$playlistSongs"); // Update local state with new songs
                              // });

                              // Update provider
                              playlistProvider.updatePlaylistSongs(
                                  widget.currentPlaylist.playlistName, result);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              }
              // Check if songs are empty
              if (playlistSongs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image and message...
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, color: Colors.yellow),
                        label: const Text('Add song',
                            style: TextStyle(color: Colors.yellow)),
                        onPressed: () {
                          Navigator.of(context)
                              .push<List<SongModel>>(
                            MaterialPageRoute(
                              builder: (ctx) => SelectableMusicScreen(
                                  currentPlaylist: widget.currentPlaylist),
                            ),
                          )
                              .then((result) {
                            if (result != null && mounted) {
                              print("result:$result");
                              setState(() {
                                playlistSongs = result;
                              });
                              // playlistSongs = result;
                              // setState(() {

                              print(
                                  "playlistSongs:$playlistSongs"); // Update local state with new songs
                              // });

                              // Update provider
                              playlistProvider.updatePlaylistSongs(
                                  widget.currentPlaylist.playlistName, result);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              }

              // If we have songs, display them
              print("we try to display selected songs");
              return ListView.builder(
                itemCount: playlistSongs.length,
                itemBuilder: (context, index) {
                  final song = playlistSongs![index];
                  return ListTile(
                    title: Text(song.title),
                    subtitle: Text(song.artist ?? 'Unknown artist'),
                    leading: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(Icons.music_note),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MusicPlayer(
                            currentPlaylist: widget.currentPlaylist,
                            initialSong: song,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
                // },
                // );
                // },
                ),
          ),
        );
      },
    );
  }
}
