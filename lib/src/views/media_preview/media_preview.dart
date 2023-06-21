import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/gestures.dart';
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
  ChewieController? _chewieController;

  // Function to initialise chewie controller and set the video player
  Future<void> _initializeVideoPlayer() async {
    VideoPlayerController videoPlayerController = VideoPlayerController.network(
      widget.mediaUrl!,
    );
    await videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: videoPlayerController.value.aspectRatio,
      autoPlay: true,
      looping: true,
      showControls: true,
      showControlsOnInitialize: false,
      customControls: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(
            child: MaterialControls(),
          ),
          kHorizontalPaddingMedium,
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                exitFullScreenMode();
                locator<NavigationService>().goBack();
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                width: 30,
                height: 30,
                clipBehavior: Clip.none,
                child: const Icon(
                  Icons.fullscreen_exit,
                  color: kWhiteColor,
                ),
              ),
            ),
          ),
          kHorizontalPaddingMedium,
        ],
      ),
      placeholder: const Center(child: CircularProgressIndicator()),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
    videoPlayerController.play();
  }

  @override
  void initState() {
    super.initState();
    enterFullScreenMode();
  }

// Step 3
  @override
  dispose() {
    exitFullScreenMode();
    _chewieController?.dispose();
    super.dispose();
  }

  void enterFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  void exitFullScreenMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _initializeVideoPlayer(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: Chewie(
              controller: _chewieController!,
            ),
          ),
        );
      },
    );
  }
}
