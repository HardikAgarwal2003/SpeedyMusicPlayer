import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speedy_music_player/constants/app_colors.dart';
import 'package:speedy_music_player/controller/audio_controller.dart';
import 'package:speedy_music_player/utils/custom_text_style.dart';
import 'package:speedy_music_player/widgets/bottom_player.dart';
import 'package:speedy_music_player/widgets/my_button.dart';
import 'package:speedy_music_player/widgets/song_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Function for taking permission for Audio from the user.
  bool _hasPermission = false;
  bool _isLoading = true;
  final audioController = AudioController();

  // Wrong method, because tutorial using on_audio_query, but I am using on_audio_query_pluse.
  // Future<void> _checkPermissionAndRequest() async {
  //   final permission = await Permission.audio.status;
  //   if (permission.isGranted) {
  //     setState(() {
  //       _hasPermission = true;
  //     });
  //     await audioController.loadSongs();
  //   }else{
  //     final result = await Permission.audio.request();
  //     setState(() {
  //       _hasPermission = true;
  //     });
  //     if(result.isGranted){
  //       await audioController.loadSongs();
  //     }
  //   }
  // }

  Future<void> _checkPermissionAndRequest() async {
    final hasPermission = await audioController.audioQuery.checkAndRequest(retryRequest: true);
    if (hasPermission) {
      await audioController.loadSongs();
    }
    setState(() {
      _hasPermission = hasPermission;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkPermissionAndRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        // Title...
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: RichText(
            maxLines: 1,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Speedy",
                  style: myTextStyle36(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "Vinyl",
                  style: myTextStyle36(fontColor: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        toolbarHeight: 90,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyButton(child: Icon(Icons.person), onPress: () {}),
        ),
        actions: [
          MyButton(child: Icon(Icons.favorite_border_rounded), onPress: () {}),
          SizedBox(width: 16),
          MyButton(child: Icon(Icons.settings), onPress: () {}),
          SizedBox(width: 12),
        ],
      ),
      // Body...
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: audioController.songs,
          builder: (context, songs, child) {
            if (_isLoading) {
              return CircularProgressIndicator(color: AppColors.primary, strokeWidth: 8);
            }
            if (!_hasPermission) {
              return Text("Permission denied");
            }
            if (songs.isEmpty) {
              return Text("No songs found");
            }
            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return SongListItem(song: songs[index], index: index);
              },
            );
          },
        ),
      ),
      bottomSheet: BottomPlayer(),
    );
  }
}
