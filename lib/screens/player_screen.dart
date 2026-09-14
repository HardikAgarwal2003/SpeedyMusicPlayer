import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:speedy_music_player/constants/app_colors.dart';
import 'package:speedy_music_player/controller/audio_controller.dart';
import 'package:speedy_music_player/model/local_song_model.dart';
import 'package:speedy_music_player/utils/custom_text_style.dart';
import 'package:speedy_music_player/widgets/my_button.dart';
import 'package:speedy_music_player/widgets/vinyl_record.dart';
import 'package:speedy_music_player/widgets/tone_arm.dart';


class PlayerScreen extends StatefulWidget {
  final LocalSongModel song;
  final int index;

  const PlayerScreen({super.key, required this.song, required this.index});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioController = AudioController();
    bool isPlaying = false;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text("Now Playing", style: myTextStyle24(fontWeight: .bold)),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: MyButton(
            onPress: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        actions: [
          MyButton(child: Icon(Icons.more_vert_rounded), onPress: () {}),
          SizedBox(width: 12),
        ],
        backgroundColor: AppColors.secondary,
      ),
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: audioController.currentIndex,
                    builder: (context, currentIndex, child) {
                      final currentSong = audioController.currentSong ?? widget.song;
                      final recordSize = MediaQuery.of(context).size.width - 48;

                      return ValueListenableBuilder<bool>(
                        valueListenable: audioController.isPlaying,
                        builder: (context, isPlaying, child) {
                          return SizedBox(
                            width: recordSize,
                            height: recordSize,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Center(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 1000),
                                    switchInCurve: Curves.easeOutBack,
                                    switchOutCurve: Curves.easeIn,
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: ScaleTransition(
                                          scale: Tween<double>(
                                            begin: 0.78,
                                            end: 1.0,
                                          ).animate(animation),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: VinylRecord(
                                      key: ValueKey(currentSong.id),
                                      song: currentSong,
                                      isPlaying: isPlaying,
                                      size: recordSize,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -6,
                                  right: 8,
                                  child: ToneArm(isPlaying: isPlaying),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  ValueListenableBuilder<int>(
                    valueListenable: audioController.currentIndex,
                    builder: (context, index, child) {
                      final song = audioController.currentSong;

                      return Column(
                        children: [
                          SizedBox(
                            height: 30,
                            child: Marquee(
                              blankSpace: 30,
                              startPadding: 30,
                              velocity: 30,
                              style: myTextStyle18(fontColor: Colors.black45),
                              text: song?.title.toString().split("/").last ?? "",
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            song?.artist ?? "Unknown Artist",
                            style: myTextStyle15(),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Seekbar
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: StreamBuilder<Duration>(
                      stream: audioController.audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration = audioController.audioPlayer.duration ?? Duration.zero;
                        return ProgressBar(
                          progress: position,
                          total: duration,
                          progressBarColor: AppColors.primary,
                          baseBarColor: Colors.black12,
                          thumbColor: AppColors.primary,
                          onSeek: (duration) {
                            audioController.audioPlayer.seek(duration);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyButton(
                        onPress: audioController.previousSong,
                        child: Icon(Icons.skip_previous_rounded,size: 30,),
                      ),
                      StreamBuilder<PlayerState>(
                        stream: audioController.audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final playing = playerState?.playing == true;

                          return MyButton(
                            btnBackground: AppColors.primary,
                            onPress: audioController.togglePlayPause,
                            child: Icon(
                              playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              size: 45,
                            ),
                          );
                        },
                      ),
                      MyButton(
                        onPress: audioController.nextSong,
                        child: Icon(Icons.skip_next_rounded,size: 30,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
