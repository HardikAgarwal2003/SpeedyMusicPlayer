import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:speedy_music_player/model/local_song_model.dart';

class VinylRecord extends StatefulWidget {
  final LocalSongModel song;
  final bool isPlaying;
  final double size;

  const VinylRecord({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.size,
  });

  @override
  State<VinylRecord> createState() => _VinylRecordState();
}

class _VinylRecordState extends State<VinylRecord>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    if (widget.isPlaying) {
      _spinController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant VinylRecord oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPlaying && !_spinController.isAnimating) {
      _spinController.repeat();
    } else if (!widget.isPlaying && _spinController.isAnimating) {
      _spinController.stop();
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _spinController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _spinController.value * 2 * math.pi,
            child: child,
          );
        },
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFF4A4A4A),
                      Color(0xFF1D1D1D),
                      Color(0xFF080808),
                    ],
                    stops: [0.0, 0.55, 1.0],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 18,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
              ),
              Container(
                width: widget.size * 0.80,
                height: widget.size * 0.80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white12, width: 1),
                ),
              ),
              Container(
                width: widget.size * 0.61,
                height: widget.size * 0.61,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white10, width: 1),
                ),
              ),
              QueryArtworkWidget(
                id: widget.song.id,
                type: ArtworkType.AUDIO,
                artworkWidth: widget.size * 0.42,
                artworkHeight: widget.size * 0.42,
                artworkFit: BoxFit.cover,
                artworkBorder: BorderRadius.circular(widget.size),
                nullArtworkWidget: Container(
                  width: widget.size * 0.42,
                  height: widget.size * 0.42,
                  decoration: const BoxDecoration(
                    color: Color(0xFF76E8BE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.music_note_rounded,
                    color: Colors.black87,
                    size: 42,
                  ),
                ),
              ),
              Container(
                width: 15,
                height: 15,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0E5EC),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}