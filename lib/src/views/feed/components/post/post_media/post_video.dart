import 'dart:io';

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
    initialiseControllers();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  Future<void> initialiseControllers() async {
    if (widget.url != null) {
      videoPlayerController = VideoPlayerController.network(widget.url!);
    } else {
      videoPlayerController = VideoPlayerController.file(widget.videoFile!);
    }
    chewieController = ChewieController(
        deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitUp],
        videoPlayerController: videoPlayerController,
        aspectRatio: 1.0,
        customControls: const MaterialControls(showPlayButton: true),
        autoPlay: true,
        looping: true,
        placeholder: Container(
          alignment: Alignment.center,
          child: const PostShimmer(),
        ),
        allowFullScreen: false,
        showControls: false,
        showOptions: false,
        autoInitialize: false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.width,
      width: widget.width,
      child: FittedBox(
        fit: BoxFit.cover,
        alignment: Alignment.center,
        child: Chewie(
          controller: chewieController,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
