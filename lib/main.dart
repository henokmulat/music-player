import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';
import 'package:music/providers/playlists_provider.dart';
import 'package:music/providers/songs_provider.dart';
import 'package:music/providers/theme_provider.dart';
import 'package:music/screens/add_playlist.dart';
import 'package:provider/provider.dart';

// import 'package:on_audio_query/on_audio_query.dart';

// import 'package:music/song_model.dart';

// Future<void> openPlaylistBox() async {
//   if (!Hive.isBoxOpen('playlistBox')) {
//     // var box = Hive.box<List<SongModel>>('boxPlaylist');
//     // Hive.deleteBoxFromDisk('boxPlaylist');
//     await Hive.openBox('boxPlaylist');
//     print('deleting box from the disk succesfully completed');
//   }
// }
// class HiveManager {
//   static Future<void> initHive() async {
//     // Initialize Hive
//     await Hive.initFlutter();

//     // Register adapters here if needed
//     Hive.registerAdapter(HiveSongModelAdapter());

//     // Open the box if it isn't already open
//     if (!Hive.isBoxOpen('playlistBox')) {
//       await Hive.openBox<List<SongModel>>('playlistBox');
//     }
//   }

//   static Box<List<SongModel>> getPlaylistBox() {
//     return Hive.box<List<SongModel>>('playlistBox');
// }
// }
//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await HiveManager.initHive();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => SongsProvider(),
      ),
      ChangeNotifierProxyProvider<SongsProvider, PlaylistsProvider>(
        create: (context) => PlaylistsProvider(
            // Provider.of<SongsProvider>(context, listen: false),
            ),
        update: (context, songsProvider, playlistProvider) =>
            PlaylistsProvider(),
      ),
      // ChangeNotifierProvider(
      //   create: (context) => PlaylistProvider(
      //     Provider.of<SongsProvider>(context, listen: false),
      //   ),
      //   // update: (context, songProvider, playlistProvider) =>
      //   //     PlaylistProvider(songProvider),
      // ),
      ChangeNotifierProvider(
          create: (context) => ThemeProvider(ThemeData.light()))
    ], child: const App()),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: themeProvider.themeData,
          home: const AddPlaylist(),
        );
      },
    );
  }
}
