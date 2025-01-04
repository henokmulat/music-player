import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:music/providers/playlists_provider.dart';
import 'package:music/model/playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class DefaultPlayer extends StatefulWidget {
  const DefaultPlayer({
    super.key,
    required this.initialSong,
    required this.currentPlaylist,
  });

  final SongModel initialSong;
  final Playlist currentPlaylist;

  @override
  State<DefaultPlayer> createState() => _DefaultPlayerState();
}

class _DefaultPlayerState extends State<DefaultPlayer>
    with SingleTickerProviderStateMixin {
  final List<Color> colors = [
    Colors.red[900]!,
    Colors.green[900]!,
    Colors.blue[900]!,
    Colors.brown[900]!
  ];

  final List<int> duration = [900, 700, 600, 800, 500];

  // late PlayerController _waveformController;
  final _waveformController = PlayerController();
  // late AnimationController _rotationController;

  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = '${duration.inMinutes}:$twoDigitSeconds';
    return formattedTime;
  }

  @override
  void initState() {
    super.initState();
    // _rotationController = AnimationController(
    //     duration: const Duration(
    //       seconds: 10,
    //     ),
    //     vsync: this);
    // _rotationController.repeat();

    final playlistsProvider =
        Provider.of<PlaylistsProvider>(context, listen: false);
    playlistsProvider.currentPlaylist = widget.currentPlaylist;
    playlistsProvider.selectedSong = widget.initialSong;
    // Provider.of<PlaylistsProvider>(context, listen: false);
    // _waveformController.preparePlayer(
    //   path: widget.initialSong.data,
    //   // Provider.of<PlaylistsProvider>(context, listen: false)
    //   //     .currentDefaultSong
    //   //     .data,
    //   shouldExtractWaveform: true,
    // );
    playlistsProvider.fetchSongs();
    playlistsProvider.loadSong(widget.initialSong);
    // playlistsProvider.toggleShuffle();
  }

  // void toggleRotation(bool isPlaying) {
  //   if (mounted) {
  //     if (isPlaying) {
  //       _rotationController.repeat();
  //     } else {
  //       _rotationController.stop();
  //     }
  //   }
  // }

  @override
  void dispose() {
    _waveformController.dispose();
    // _rotationController.stop();
    // _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      // appBar: AppBar(
      //   title: Consumer<PlaylistsProvider>(
      //     builder: (context, provider, child) {
      //       return Text(
      //         provider.currentSongTitle,
      //         style: const TextStyle(fontSize: 16),
      //       );
      //     },
      //   ),
      // ),
      body: Consumer<PlaylistsProvider>(
        builder: (context, value, child) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 10,
                ),

                Stack(
                  children: [
                    SizedBox(
                      width: 400,
                      height: 400,
                      // radius: 130,
                      // child: ClipOval(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/defaultartwork.jpg',
                          // width: 400,
                          // height: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),

                // MusicVisualizer(
                //   barCount: 30,
                //   colors: colors,
                //   duration: duration,
                // ),
                // ],
                // ),
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () {
                    print("intialSong: ${widget.initialSong}");
                  },
                  icon: const Icon(
                    Icons.favorite_outline,
                  ),
                ),
                // const SizedBox(height: 150),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Slider(
                    min: 0.0,
                    max: value.totalDuration.inSeconds.toDouble(),
                    value: value.currentDuration.inSeconds.toDouble().clamp(
                          0.0,
                          value.totalDuration.inSeconds.toDouble(),
                        ),
                    onChanged: (double newValue) {
                      print("initialSong: ${widget.initialSong}");
                      value.seek(Duration(seconds: newValue.toInt()));
                    },
                    onChangeEnd: (double newValue) {
                      value.seek(Duration(seconds: newValue.toInt()));
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(formatTime(value.currentDuration)),
                      const Spacer(),
                      Text(formatTime(value.totalDuration)),
                    ],
                  ),
                ),

                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: Marquee(
                        text: value.currentSongTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        blankSpace: 20.0,
                        velocity: 50.0,
                        startPadding: 10.0,
                        pauseAfterRound: const Duration(seconds: 1),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          print('Shuffle is pressed');
                          value.toggleShuffle(); // Start or stop rotation
                        },
                        iconSize: 24,
                        icon: const Icon(Icons.shuffle),
                      ),
                      IconButton(
                        onPressed: () {
                          value
                              .playPreviousSongDefault(); // Start or stop rotation
                        },
                        iconSize: 40,
                        icon: const Icon(Icons.skip_previous),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(3, 3))
                            ]),
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () {
                            value.pauseOrResume(); // Start or stop rotation
                          },
                          iconSize: 40,
                          icon: Icon(
                            value.isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          value.playNextSongDefault(); // Start or stop rotation
                        },
                        icon: const Icon(Icons.skip_next),
                        iconSize: 40,
                      ),
                      IconButton(
                        onPressed: value.playPreviousSong,
                        iconSize: 24,
                        icon: const Icon(Icons.repeat),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
