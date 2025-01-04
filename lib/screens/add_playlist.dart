import 'package:flutter/material.dart';
import 'package:music/providers/theme_provider.dart';
import 'package:music/screens/theme_screen.dart';
import 'package:music/widgets/display_playlists.dart';
import 'package:music/widgets/main_drawer.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
// import 'package:music/widgets/query_playlists.dart';

class AddPlaylist extends StatefulWidget {
  const AddPlaylist({super.key});

  @override
  State<AddPlaylist> createState() => _AddPlaylistState();
}

class _AddPlaylistState extends State<AddPlaylist> {
  @override
  void initState() {
    super.initState();
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

  // final _playlistController = TextEditingController();
  // void _addPlaylist() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Create playlist'),
  //         content: TextField(
  //           controller: _playlistController,
  //           decoration: const InputDecoration(
  //               hintText: 'Enter the name of your playlist'),
  //           maxLength: 20,
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {},
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {},
  //             child: const Text('Create'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void setScreen(String identifier) async {
    Navigator.of(context).pop();
    var navigator = Navigator.of(context);
    if (identifier == 'playlists') {
      await navigator.push(
        MaterialPageRoute(
          builder: (ctx) => const AddPlaylist(),
        ),
      );
    }
    if (identifier == "themes") {
      await navigator
          .push(MaterialPageRoute(builder: (ctx) => const ThemeScreen()));
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
                    "assets/images/eight.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Music player'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: TextButton.icon(
                      onPressed: () {},
                      label: const Text('Import playlist'),
                      icon: const Icon(Icons.add),
                    ),
                  ),
                  PopupMenuItem(
                    child: TextButton.icon(
                      onPressed: () {},
                      label: const Text('Sleep timer'),
                      icon: const Icon(Icons.timer_outlined),
                    ),
                  ),
                  PopupMenuItem(
                    child: TextButton.icon(
                      onPressed: () {},
                      label: const Text('Equalizer'),
                      icon: const Icon(Icons.equalizer),
                    ),
                  ),
                ],
              )
            ],
          ),
          drawer: MainDrawer(
            onSelectScreen: setScreen,
          ),
          body: const DisplayPlaylists(),
        ),
      );
    });
  }
}
