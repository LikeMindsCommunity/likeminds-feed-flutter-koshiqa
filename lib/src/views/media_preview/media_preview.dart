import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:video_player/video_player.dart';

class MediaPreviewScreen extends StatefulWidget {
  static const routeName = '/media-preview';

  final List<Attachment>? attachments;
  final String? postId;
  final File? mediaFile;
  final String? mediaUrl;

  const MediaPreviewScreen({
    super.key,
    this.attachments,
    this.postId,
    this.mediaFile,
    this.mediaUrl,
  });

  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  late ChewieController _chewieController;

  // Function to initialise chewie controller and set the video player
  void _initializeVideoPlayer() {
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(
        widget.mediaUrl!,
      ),
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: false,
      showControls: true,
      showControlsOnInitialize: true,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _initializeVideoPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
