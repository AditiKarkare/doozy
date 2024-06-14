import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioSentCardWidget extends StatefulWidget {
  final String audioLink;
  const AudioSentCardWidget({super.key, required this.audioLink});

  @override
  State<AudioSentCardWidget> createState() => _AudioSentCardWidgetState();
}

class _AudioSentCardWidgetState extends State<AudioSentCardWidget> {
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  double _playProgress = 0.0;
  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.openAudioSession();
      _audioPlayer.setSubscriptionDuration(const Duration(milliseconds: 100));
      _audioPlayer.onProgress?.listen((event) {
        setState(() {
          _playProgress =
              event.position.inMilliseconds / event.duration.inMilliseconds;
        });
      });
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  Future<void> _togglePlayback() async {
    Uint8List audioData = base64Decode(widget.audioLink);
    if (!_isPlaying) {
      try {
        setState(() {
          _isLoading = true;
        });
        await _audioPlayer.startPlayer(
          fromDataBuffer: audioData,
          codec: Codec.aacADTS,
          whenFinished: () {
            _isPlaying = false;
            setState(() {});
          },
        );

        setState(() {
          _isLoading = false;
          _isPlaying = true;
        });
      } catch (e) {
        print('Error playing audio: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      stopPlayer();
    }
  }

  stopPlayer() {
    _audioPlayer.pausePlayer();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _isLoading
              ? const CircularProgressIndicator()
              : _isPlaying
                  ? IconButton(
                      onPressed: () {
                        stopPlayer();
                      },
                      icon: const Icon(Icons.pause))
                  : IconButton(
                      onPressed: () => _togglePlayback(),
                      icon: const Icon(Icons.play_arrow)),
          SizedBox(width: 10.w),
          SizedBox(
            width: 150,
            child: LinearProgressIndicator(
              value: _playProgress,
              backgroundColor: Colors.grey[400],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
