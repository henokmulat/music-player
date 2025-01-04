// // import 'dart:async';
// // import 'dart:io';
// // import 'dart:math';
// // import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart' as core_patch;
// // import 'package:audioplayers/audioplayers.dart';
// import 'package:audio_waveforms/audio_waveforms.dart';
// // import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:music/providers/playlists_provider.dart';
// import 'package:music/model/playlist.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// // import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';

// class MusicPlayer extends StatefulWidget {
//   const MusicPlayer({
//     super.key,
//     // required this.onSelectedSong,
//     required this.initialSong,
//     required this.currentPlaylist,
//   });

//   // final Function(String song) onSelectedSong;
//   final SongModel initialSong;
//   final Playlist currentPlaylist;

//   @override
//   State<MusicPlayer> createState() => _MusicPlayerState();
// }

// class _MusicPlayerState extends State<MusicPlayer> {
//   String formatTime(Duration duration) {
//     String twoDigitSeconds =
//         duration.inSeconds.remainder(60).toString().padLeft(2, '0');
//     String formattedTime = '${duration.inMinutes}:$twoDigitSeconds';
//     return formattedTime;
//   }

//   // late Animation<double> animation;
//   // late AnimationController animController;
//   // ignore: prefer_final_fields
//   // double _sliderValue = 0.0;
//   // late AudioPlayer _audioPlayer;
//   late PlayerController _waveformController;
//   // bool isPaused = false;
//   // bool isPlaying = false;

//   // Duration _currentPosition = Duration.zero;
//   // Duration _duration = Duration.zero;
//   // late StreamSubscription _positionSubscription;
//   // late StreamSubscription _durationSubscription;
//   // String? localFilePath;

//   @override
//   void initState() {
//     super.initState();
//     // _audioPlayer = AudioPlayer();
//     Provider.of<PlaylistsProvider>(context, listen: false).currentPlaylist =
//         widget.currentPlaylist;
//     Provider.of<PlaylistsProvider>(context, listen: false).selectedSong =
//         widget.initialSong;
//     // Provider.of<PlaylistProvider>(context, listen: false).listenToDuration();
//     // _audioPlayer = AudioPlayer();
//     _waveformController = PlayerController();
//     // animController =
//     //     AnimationController(duration: const Duration(seconds: 2), vsync: this);
//     // final curvedAnimation =
//     //     CurvedAnimation(parent: animController, curve: Curves.easeInOutCubic);
//     // animation = Tween(
//     //   begin: 0.0,
//     //   end: 3.14,
//     // ).animate(curvedAnimation)
//     //   ..addListener(() {});
//     // animController.repeat(reverse: false);

//     // requestPermission().then((_) {
//     //   // If permission is granted, load the audio
//     //   loadAudio();
//     // });

//     // _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
//     //   setState(() {
//     //     _currentPosition = position;
//     //   });
//     // });

//     // _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
//     //   setState(() {
//     //     _duration = duration;
//     //   });
//     // });

//     // Initialize localFilePath from the initialSong
//     // localFilePath =
//     //     widget.initialSong; // Load the audio when the player initializes
//   }

//   // Future<void> requestPermission() async {
//   //   var status = await Permission.storage.status;
//   //   if (!status.isGranted) {
//   //     await Permission.storage.request();
//   //   }
//   // }

//   // Future<void> loadAudio() async {
//   //   if (localFilePath == null) {
//   //     print("Error: localFilePath is null.");
//   //     return;
//   //   }

//   //   try {
//   //     // Load the audio file from the device
//   //     await _audioPlayer.setSource(DeviceFileSource(localFilePath!));

//   //     // Start extracting the waveform
//   //     await _waveformController.preparePlayer(
//   //       path: localFilePath!,
//   //       shouldExtractWaveform: true,
//   //     );

//   //     if (mounted) {
//   //       setState(() {
//   //         print("Waveform extraction complete!");
//   // });
//   //     }
//   //   } catch (error) {
//   //     print("Error preparing player: $error");
//   //   }
//   // }

//   // void playAudio() async {
//   //   if (localFilePath == null) {
//   //     return;
//   //   } else {
//   //     File file = File(localFilePath!);
//   //     if (await file.exists()) {
//   //       // Proceed with playing the file
//   //       if (isPaused) {
//   //         await _audioPlayer.resume();
//   //       } else {
//   //         await _audioPlayer.play(DeviceFileSource(localFilePath!));
//   //       }

//   //       setState(() {
//   //         isPlaying = true;
//   //         isPaused = false;
//   //       });
//   //     } else {
//   //       print('File does not exist');
//   //     }
//   // }
//   // }

//   // void pauseAudio() async {
//   //   if (isPlaying) {
//   //     await _audioPlayer.pause();
//   //     setState(() {
//   //       isPlaying = false;
//   //       isPaused = true;
//   //     });
//   //   }
//   // }

//   // void stopAudio() async {
//   //   await _audioPlayer.stop();
//   //   setState(() {
//   //     isPlaying = false;
//   //     isPaused = false;
//   //   });
//   // }

//   // @override
//   // void dispose() {
//   //   _positionSubscription.cancel();
//   //   _durationSubscription.cancel();
//   //   _audioPlayer.dispose();
//   //   _waveformController.dispose();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('T R A C K 1 '),
//       ),
//       body: Consumer<PlaylistsProvider>(builder: (context, value, child) {
//         value.currentPlaylist = widget.currentPlaylist;
//         value.selectedSong = widget.initialSong;

//         return SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 130,
//                     child: ClipOval(
//                       child: Image.asset(
//                         'assets/images/artwork.jpg',
//                         width: 300,
//                         height: 300,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   // Positioned(
//                   //   bottom: 0,
//                   //   child: GestureDetector(
//                   //     onPanUpdate: (details) {
//                   //       _updateSliderValue(details.localPosition);
//                   //     },
//                   //     child: CustomPaint(
//                   //       // size: const Size(300, 300),
//                   //       painter: ProgressArc(_sliderValue),
//                   //       child: const SizedBox(
//                   //         width: 300,
//                   //         height: 150,
//                   //         // child: Slider(
//                   //         //     value: _sliderValue,
//                   //         //     min: 0.0,
//                   //         //     max: 100.0,
//                   //         //     onChanged: (value) {
//                   //         //       setState(() {
//                   //         //         _sliderValue = value;
//                   //         //       });
//                   //         //     }),
//                   //       ),
//                   //     ),
//                   //   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               IconButton(
//                 onPressed: () {
//                   print("intialSong:${widget.initialSong}");
//                 },
//                 icon: const Icon(
//                   Icons.favorite_outline,
//                 ),
//               ),
//               // Text(
//               //   value.isPlaying ? 'Now Playing' : 'Stopped',
//               //   style: const TextStyle(fontSize: 24),
//               // ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 height: 200,
//                 child: AudioFileWaveforms(
//                   enableSeekGesture: true,
//                   size: Size(MediaQuery.of(context).size.width, 200.0),
//                   playerController: _waveformController,
//                   playerWaveStyle: const PlayerWaveStyle(
//                     fixedWaveColor: Colors.white54,
//                     liveWaveColor: Colors.blueAccent,
//                     spacing: 6,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 150),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 // child: Expanded(
//                 child: Slider(
//                   min: 0.0,
//                   max: value.totalDuration.inSeconds.toDouble(),
//                   value: value.currentDuration.inSeconds.toDouble().clamp(
//                         0.0,
//                         value.totalDuration.inSeconds.toDouble(),
//                       ),
//                   activeColor: Colors.greenAccent,
//                   onChanged: (double newValue) {
//                     print("intialSong:${widget.initialSong}");
//                     value.seek(Duration(seconds: newValue.toInt()));
//                   },
//                   onChangeEnd: (double newValue) {
//                     value.seek(Duration(seconds: newValue.toInt()));
//                   },
//                 ),
//               ),
//               // ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 22),
//                 // child: Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Text(formatTime(value.currentDuration)),
//                     const Spacer(),
//                     Text(formatTime(value.totalDuration)),
//                   ],
//                 ),
//               ),
//               // ),
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     IconButton(
//                       onPressed: value.playPreviousSong,
//                       iconSize: 24,
//                       icon: const Icon(Icons.shuffle),
//                     ),
//                     IconButton(
//                       onPressed: value.playPreviousSong,
//                       iconSize: 40,
//                       icon: const Icon(Icons.skip_previous),
//                     ),
//                     IconButton(
//                       onPressed: value.pauseOrResume,
//                       iconSize: 40,
//                       icon: Icon(
//                           value.isPlaying ? Icons.pause : Icons.play_arrow),
//                     ),
//                     IconButton(
//                       onPressed: value.playNextSong,
//                       icon: const Icon(Icons.skip_next),
//                       iconSize: 40,
//                     ),
//                     IconButton(
//                       onPressed: value.playPreviousSong,
//                       iconSize: 24,
//                       icon: const Icon(Icons.repeat),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   // void _updateSliderValue(Offset localPosition) {
//   //   // Get the center of the custom paint area
//   //   final center = Offset(100, 100);
//   //   // Calculate the angle based on the touch position
//   //   final angle =
//   //       atan2(localPosition.dy - center.dy, localPosition.dx - center.dx);

//   //   // Convert angle to a range from 0 to 100 (0 = left, 100 = right)
//   //   double newValue = ((angle + pi / 2) / pi) * 100;
//   //   newValue = newValue.clamp(0.0, 100.0);

//   //   setState(() {
//   //     _sliderValue = newValue;
//   //   });
//   // }
// }

// // class ProgressArc extends CustomPainter {
// //   final double sliderValue;
// //   ProgressArc(this.sliderValue);
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final Rect arcRect = Rect.fromLTRB(0, 0, size.width, size.height * 2);
// //     const startAngle = 3.14;
// //     // ignore: unnecessary_null_comparison
// //     final sweepAngle = -3.14 * sliderValue / 100;
// //     // const userCenter = false;
// //     final paint = Paint()
// //       // ..strokeCap = StrokeCap.round
// //       ..color = Colors.blueAccent
// //       ..style = PaintingStyle.stroke
// //       ..strokeWidth = 8;

// //     canvas.drawArc(arcRect, startAngle, sweepAngle, false, paint);
// //   }

// //   @override
// //   bool shouldRepaint(covariant CustomPainter oldDelegate) {
// //     return true;
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music/providers/playlists_provider.dart';
import 'package:music/model/playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({
    super.key,
    required this.initialSong,
    required this.currentPlaylist,
  });

  final SongModel initialSong;
  final Playlist currentPlaylist;

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late PlayerController _waveformController;

  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = '${duration.inMinutes}:$twoDigitSeconds';
    return formattedTime;
  }

  @override
  void initState() {
    super.initState();
    _waveformController = PlayerController();
    final playlistsProvider =
        Provider.of<PlaylistsProvider>(context, listen: false);
    playlistsProvider.currentPlaylist = widget.currentPlaylist;
    playlistsProvider.selectedSong = widget.initialSong;
    Provider.of<PlaylistsProvider>(context, listen: false);
    playlistsProvider.loadSong(widget.initialSong);
  }

  @override
  void dispose() {
    _waveformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialSong.title,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: Consumer<PlaylistsProvider>(
        builder: (context, value, child) {
          return SafeArea(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 130,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/artwork.jpg',
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () {
                    print("intialSong: ${widget.initialSong}");
                  },
                  icon: const Icon(
                    Icons.favorite_outline,
                  ),
                ),
                // const SizedBox(height: 20),
                // SizedBox(
                // height: 200,
                // child:
                AudioFileWaveforms(
                  enableSeekGesture: false,
                  size: Size(MediaQuery.of(context).size.width, 200.0),
                  playerController: _waveformController,
                  playerWaveStyle: const PlayerWaveStyle(
                    fixedWaveColor: Colors.white54,
                    liveWaveColor: Colors.blueAccent,
                    spacing: 6,
                    showSeekLine: false,
                    seekLineThickness: 10.0,
                    showBottom: false,
                  ),
                  waveformType: WaveformType.fitWidth,
                ),
                // ),
                const SizedBox(height: 150),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: value.playPreviousSong,
                        iconSize: 24,
                        icon: const Icon(Icons.shuffle),
                      ),
                      IconButton(
                        onPressed: value.playPreviousSong,
                        iconSize: 40,
                        icon: const Icon(Icons.skip_previous),
                      ),
                      IconButton(
                        onPressed: value.pauseOrResume,
                        iconSize: 40,
                        icon: Icon(
                            value.isPlaying ? Icons.pause : Icons.play_arrow),
                      ),
                      IconButton(
                        onPressed: value.playNextSong,
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
