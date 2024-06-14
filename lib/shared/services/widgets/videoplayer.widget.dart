import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void _handleVideoCompleted() {
    Navigator.pop(context);
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    try {
      await _videoPlayerController.initialize().then((v) {
        setState(() {});
        _videoPlayerController.setLooping(false);
        _videoPlayerController.addListener(() {
          if (_videoPlayerController.value.position ==
              _videoPlayerController.value.duration) {
            _handleVideoCompleted();
          }
        });
      });
      _videoPlayerController.play();

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing video player: $e');
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(
              _videoPlayerController,
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
