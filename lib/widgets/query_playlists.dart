// import 'package:flutter/material.dart';
// import 'package:music/screens/on_tap_playlis.dart';
// import 'package:music/model/playlist.dart';
// import 'package:music/widgets/player_lists.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'package:provider/provider.dart';
// import 'package:music/providers/playlist_provider.dart';

// class QueryPlaylists extends StatefulWidget {
//   const QueryPlaylists({super.key});

//   @override
//   State<QueryPlaylists> createState() => _QueryPlaylistsState();
// }

// class _QueryPlaylistsState extends State<QueryPlaylists> {
//   final OnAudioQuery _audioQuery = OnAudioQuery();
//   List<Playlist> _playlists = [];
//   final _playlistNameController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     _requestPermission();
//   }

//   Future<void> _requestPermission() async {
//     if (await Permission.storage.request().isGranted) {
//       _loadPlaylists();
//     } else {
//       print('Storage permission denied');
//     }
//   }

//   Future<void> _loadPlaylists() async {
//     List<PlaylistModel> playlists = await _audioQuery.queryPlaylists();
//     setState(() {
//       _playlists = playlists;
//     });
//   }

//   Future<void> _createPlaylist() async {
//     String playlistName = _playlistNameController.text.trim();
//     if (playlistName.isNotEmpty) {
//       await _audioQuery.createPlaylist(playlistName);
//       _loadPlaylists();
//       FocusScope.of(context).unfocus();
//       _playlistNameController.clear();
//     } else {}
//   }

//   void openMOdalBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SizedBox(
//           height: 200,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 _playlistNameController.text.trim(),
//                 style: const TextStyle(fontSize: 18),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     TextButton(
//                       onPressed: () {},
//                       style: TextButton.styleFrom(
//                         iconColor: Colors.white,
//                       ),
//                       child: const Column(
//                         children: [
//                           Icon(
//                             Icons.play_arrow_sharp,
//                             size: 28,
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Text(
//                             'Play',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {},
//                       style: TextButton.styleFrom(
//                         iconColor: Colors.white,
//                       ),
//                       child: const Column(
//                         children: [
//                           Icon(
//                             Icons.skip_next_outlined,
//                             size: 28,
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Text(
//                             'Play next',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {},
//                       style: TextButton.styleFrom(
//                         iconColor: Colors.white,
//                       ),
//                       child: const Column(
//                         children: [
//                           Icon(
//                             Icons.playlist_add,
//                             size: 28,
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Text(
//                             'Enqueues',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     TextButton(
//                       onPressed: () {},
//                       style: TextButton.styleFrom(
//                         iconColor: Colors.white,
//                       ),
//                       child: const Expanded(
//                         child: Column(
//                           // crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(
//                               Icons.house_outlined,
//                               size: 28,
//                             ),
//                             SizedBox(
//                               height: 6,
//                             ),
//                             Text(
//                               'Home',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {},
//                       style: TextButton.styleFrom(
//                         iconColor: Colors.white,
//                       ),
//                       child: const Expanded(
//                         child: Column(
//                           // crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(
//                               Icons.share_outlined,
//                               size: 28,
//                             ),
//                             SizedBox(
//                               height: 6,
//                             ),
//                             Text(
//                               'Share',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {},
//                       style: TextButton.styleFrom(
//                         iconColor: Colors.white,
//                       ),
//                       child: const Expanded(
//                         child: Column(
//                           children: [
//                             Icon(
//                               Icons.mobile_friendly,
//                               size: 28,
//                             ),
//                             SizedBox(
//                               height: 6,
//                             ),
//                             Text(
//                               'Remove',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(child: PlayerLists()),
//         const SizedBox(height: 10),
//         Padding(
//           padding: const EdgeInsets.all(8),
//           child: TextField(
//             controller: _playlistNameController,
//             decoration: const InputDecoration(
//               labelText: 'Playlist Name',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             if (_playlistNameController.text.trim() == '') {
//               return;
//             }
//             await _createPlaylist();
//           },
//           child: const Text('Create Playlist'),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: _playlists.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(_playlists[index].playlist),
//                 leading: const Icon(
//                   Icons.queue_music_outlined,
//                   size: 26,
//                 ),
//                 subtitle: const Text('22 Tracks'),
//                 trailing: IconButton(
//                     onPressed: openMOdalBottomSheet,
//                     icon: const Icon(Icons.more_vert)),
//                 onTap: () async{
//                   await Provider.of<PlaylistProvider>(context,listen:false).addPlaylist(_playlists[index])
//                   Navigator.of(context).push(

//                     MaterialPageRoute(
//                       builder: (ctx) => Ontapplaylist(
//                         currentPlaylist: Playlist(
//                           playlistName: _playlists[index].playlist,
//                           songs: [],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
