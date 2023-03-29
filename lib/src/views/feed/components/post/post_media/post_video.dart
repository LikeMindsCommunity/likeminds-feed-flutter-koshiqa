import 'dart:io';

import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

import 'package:feed_sx/src/views/feed/components/post/post_media/post_image_shimmer.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class PostVideo extends StatefulWidget {
  final String? url;
  final File? videoFile;
  final double width;
  const PostVideo({super.key, this.url, required this.width, this.videoFile});

  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo>
    with AutomaticKeepAliveClientMixin {
  late final VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  initialiseControllers() async {
    if (widget.url != null) {
      videoPlayerController = VideoPlayerController.network(
        widget.url!,
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
        ),
      );
    } else {
      videoPlayerController = VideoPlayerController.file(
        widget.videoFile!,
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
        ),
      );
    }
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      customControls: const MaterialControls(
        showPlayButton: true,
      ),
      autoPlay: false,
      looping: false,
      showOptions: false,
      showControls: true,
      allowPlaybackSpeedChanging: false,
      allowMuting: false,
      allowFullScreen: false,
      autoInitialize: false,
      showControlsOnInitialize: false,
    );
    await videoPlayerController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialiseControllers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PostShimmer();
          }
          return Container(
            color: kWhiteColor,
            child: AspectRatio(
              aspectRatio:
                  chewieController.videoPlayerController.value.aspectRatio,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Chewie(
                  controller: chewieController,
                ),
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
