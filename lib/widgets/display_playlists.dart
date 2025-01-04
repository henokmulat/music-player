import 'package:flutter/material.dart';
import 'package:music/database_handler.dart';
import 'package:music/model/playlist.dart';
import 'package:music/providers/playlists_provider.dart';
import 'package:music/providers/theme_provider.dart';
import 'package:music/screens/default_list.dart';
// import 'package:music/providers/playlist_provider.dart';
import 'package:music/screens/on_tap_playlis.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class DisplayPlaylists extends StatefulWidget {
  const DisplayPlaylists({super.key});

  @override
  State<DisplayPlaylists> createState() => _DisplayPlaylistsState();
}

class _DisplayPlaylistsState extends State<DisplayPlaylists> {
  DatabaseHandler databaseHandler = DatabaseHandler();
  List<Playlist> _playlists = [];
  final _playlistNameController = TextEditingController();

  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<AlbumModel>> fetchAlbums() async {
    List<AlbumModel> albums = await _audioQuery.queryAlbums();
    return albums;
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
    Provider.of<PlaylistsProvider>(context, listen: false)
        .initializePlaylists();
  }

  Future<void> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      _loadPlaylists();
    } else {
      print('Storage permission denied');
    }
  }

  Future<void> _loadPlaylists() async {
    List<Playlist> playlists = await databaseHandler.getPlaylists();
    setState(() {
      _playlists = playlists;
    });
  }

  Future<void> createplaylist() async {
    if (_playlistNameController.text.trim() == '') {
      return;
    }
    String playlistName = _playlistNameController.text.trim();
    if (playlistName.isNotEmpty) {
      await databaseHandler.createPlaylist(playlistName);
      _loadPlaylists();
      FocusScope.of(context).unfocus();
      _playlistNameController.clear();
    }
  }

  void openMOdalBottomSheet(String playlistName) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  playlistName,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          iconColor: Colors.white,
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.play_arrow_sharp,
                              size: 28,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Play',
                              style: TextStyle(color: Colors.white),
                            ),
                            // SizedBox(
                            //   width: 15,
                            // ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          iconColor: Colors.white,
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.skip_next_outlined,
                              size: 28,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Play next',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          iconColor: Colors.white,
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.playlist_add,
                              size: 28,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Enqueues',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          iconColor: Colors.white,
                        ),
                        child: const Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.house_outlined,
                              size: 28,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Home',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          iconColor: Colors.white,
                        ),
                        child: const Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.share_outlined,
                              size: 28,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Share',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          iconColor: Colors.white,
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.mobile_friendly,
                              size: 28,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Remove',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return SingleChildScrollView(
          child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 36,
                            child: Image.asset(
                              'lib/icons/musical-note.png',
                              color: themeProvider.getMainColor(
                                  themeProvider.themeData.primaryColor),
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
                    TextButton(
                      onPressed: fetchAlbums,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 36,
                            child: Image.asset(
                              'lib/icons/music-album.png',
                              color: themeProvider.getMainColor(
                                  themeProvider.themeData.primaryColor),
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
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 36,
                            child: Image.asset(
                              'lib/icons/man-user.png',
                              color: themeProvider.getMainColor(
                                  themeProvider.themeData.primaryColor),
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
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 36,
                            child: Image.asset(
                              'lib/icons/folder.png',
                              color: themeProvider.getMainColor(
                                  themeProvider.themeData.primaryColor),
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
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 36,
                            child: Image.asset(
                              'lib/icons/electric-guitar.png',
                              color: themeProvider.getMainColor(
                                  themeProvider.themeData.primaryColor),
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
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 36,
                            child: Image.asset(
                              'lib/icons/zoom.png',
                              color: themeProvider.getMainColor(
                                  themeProvider.themeData.primaryColor),
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
                  ],
                ),
              ),
              // const Spacer(),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  // child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _playlistNameController,
                        decoration: const InputDecoration(
                          labelText: 'Playlist Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: createplaylist,
                        child: const Text('Create Playlist'),
                      ),
                    ],
                  ),
                ),
              ),
              // ),

              // Expanded(
              // child:
              // const SizedBox(
              //   height: 5,
              // ),
              Flexible(
                child: ListTile(
                  leading: const Icon(
                    Icons.queue_music_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Default list",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roberto',
                      color: Colors.white,
                    ),
                  ),
                  subtitle: const Text(
                    "100 songs",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  trailing: IconButton(
                    onPressed: () => openMOdalBottomSheet(
                      "Default list",
                    ),
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const DefaultList(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _playlists.length,
                  itemBuilder: (context, index) {
                    // databaseHandler.insertPlaylist(_playlists[index]);
                    return ListTile(
                      title: Text(
                        _playlists[index].playlistName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roberto',
                          color: Colors.white,
                        ),
                      ),
                      leading: const Icon(
                        Icons.queue_music,
                        color: Colors.white,
                        size: 28,
                      ),
                      subtitle: Text(
                        "${_playlists[index].songs?.length ?? 0}  songs",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      trailing: IconButton(
                        onPressed: () => openMOdalBottomSheet(
                          _playlists[index].playlistName,
                        ),
                        icon: const Icon(
                          Icons.more_vert,
                        ),
                      ),
                      onTap: () async {
                        // await databaseHandler.insertPlaylist(_playlists[index]);
                        // if (mounted && Navigator.canPop(context)) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => Ontapplaylist(
                            currentPlaylist: _playlists[index],
                          ),
                        ));
                        // }
                      },
                    );
                  },
                ),
              ),
              // ),
            ],
          ),
        ),
      ));
    });
  }
}
