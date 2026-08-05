import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:speedy_music_player/widgets/local_song_model.dart';

class AudioController {
  static final AudioController instance = AudioController._instance();
  factory AudioController() => instance;

  AudioController._instance() {
    _setupAudioPlayer();
  }

  final AudioPlayer audioPlayer = AudioPlayer();
  final OnAudioQuery audioQuery = OnAudioQuery();
  final ValueNotifier<List<LocalSongModel>> songs =
      ValueNotifier<List<LocalSongModel>>([]);
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(-1);
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);

  LocalSongModel? get currentSong =>
      currentIndex.value != -1 && currentIndex.value < songs.value.length
      ? songs.value[currentIndex.value]
      : null;

  void _setupAudioPlayer() {
    // listen to player state changes
    audioPlayer.playerStateStream.listen((playerState) {
      isPlaying.value = playerState.playing;

      // Auto Play next song when current song ends
      if (playerState.processingState == ProcessingState.completed) {
        if (currentIndex.value < songs.value.length - 1) {
          playSong(currentIndex.value + 1);
        } else {
          currentIndex.value = -1;
          isPlaying.value = false;
        }
      }
    });

    // here we listen to position changes
    audioPlayer.positionStream.listen((_) {
      // this helps to update the progress bar in UI
      isPlaying.notifyListeners();
    });
  }

  // here we create function to load song
  Future<void> loadSongs() async {
    final fetchSongs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    songs.value = fetchSongs
        .map(
          (songs) => LocalSongModel(
            id: songs.id,
            title: songs.title,
            artist: songs.artist ?? "Unknown Artist",
            url: songs.uri ?? "",
            albumArt: songs.album ?? "",
            duration: songs.duration ?? 0,
          ),
        )
        .toList();
  }

  // function for play/pause of songs
  Future<void> playSong(int index) async {
    if (index < 0 || index >= songs.value.length) return;
    try {
      if (currentIndex.value == index && isPlaying.value) {
        // pause song function
        await pauseSong();
        return;
      }
      currentIndex.value = index;
      final song = songs.value[index];
      await audioPlayer.stop();
      await audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(song.url)),
        preload: true, // to load the next song
      );
      await audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      if (kDebugMode) {
        print("Error playing song $e");
      }
    }
  }

  // pause song function
  Future<void> pauseSong() async {
    await audioPlayer.pause();
    isPlaying.value = false;
  }

  // resume song function
  Future<void> resumeSong() async {
    await audioPlayer.play();
    isPlaying.value = true;
  }

  // toggle play/pause function
  void togglePlayPause() async {
    if (currentIndex.value == -1) return;
    try {
      if (isPlaying.value) {
        await pauseSong();
      } else {
        await resumeSong();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error toggling music : $e");
      }
    }
  }

  // next song function
  Future<void> nextSong() async {
    if (currentIndex.value < songs.value.length - 1) {
      await playSong(currentIndex.value + 1);
    }
  }

  // previous song function
  Future<void> previousSong() async {
    if (currentIndex.value > 0) {
      await playSong(currentIndex.value - 1);
    }
  }

  void dispose() {
    audioPlayer.dispose();
  }
}

// Overall Architecture of This Controller
//              User taps Play
//                    │
//                    ▼
//              AudioController
//                    │
//      ┌─────────────┼─────────────┐
//      ▼             ▼             ▼
// AudioPlayer     OnAudioQuery   ValueNotifier
// (plays music)   (reads songs)  (updates UI)
//      │             │               │
//      ▼             ▼               ▼
//  Speaker      Phone Storage    Flutter Widgets


// Basic Controller flow for the application

// App Starts
// │
// ▼
// AudioController() called
// │
// ▼
// Factory returns the single instance
// │
// ▼
// Private constructor (_instance)
// │
// ▼
// _setupAudioPlayer()
// │
// ▼
// Player listeners are registered
// │
// ▼
// loadSongs()
// │
// ▼
// Songs fetched from phone
// │
// ▼
// Converted to LocalSongModel
// │
// ▼
// Stored in ValueNotifier<List>
// │
// ▼
// UI automatically updates
// │
// ▼
// User taps a song
// │
// ▼
// playSong(index)
// │
// ▼
// AudioPlayer.setAudioSource()
// │
// ▼
// AudioPlayer.play()
// │
// ▼
// playerStateStream updates
// │
// ▼
// isPlaying changes
// │
// ▼
// UI updates (Play/Pause button, progress, etc.)