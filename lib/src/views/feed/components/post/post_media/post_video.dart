import 'dart:io';

import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  initialiseControllers() async {
    if (widget.url != null) {
      videoPlayerController = VideoPlayerController.network(widget.url!);
    } else {
      videoPlayerController = VideoPlayerController.file(widget.videoFile!);
    }
    chewieController = ChewieController(
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitUp],
      videoPlayerController: videoPlayerController,
      //aspectRatio: 1.0,
      customControls: const MaterialControls(showPlayButton: true),
      additionalOptions: (context) => <OptionItem>[],
      autoPlay: false,
      looping: false,
      placeholder: Container(
        alignment: Alignment.center,
        child: const PostShimmer(),
      ),
      cupertinoProgressColors: ChewieProgressColors(
        backgroundColor: kGrey2Color,
        playedColor: kGrey3Color,
        bufferedColor: Colors.transparent,
        handleColor: Colors.transparent,
      ),
      materialProgressColors: ChewieProgressColors(
        backgroundColor: kGrey2Color,
        playedColor: kGrey3Color,
        bufferedColor: Colors.transparent,
        handleColor: Colors.transparent,
      ),
      showOptions: false,
      showControls: true,
      allowPlaybackSpeedChanging: false,
      allowMuting: false,
      allowFullScreen: false,
      autoInitialize: false,
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
          return SizedBox(
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
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
