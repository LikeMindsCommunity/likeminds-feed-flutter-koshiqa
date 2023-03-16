import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:feed_sx/src/views/feed/components/post/post_media/post_image_shimmer.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class PostVideo extends StatefulWidget {
  final String? url;
  final File? videoFile;
  const PostVideo({super.key, this.url, this.videoFile});

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
      placeholder: const PostShimmer(),
      autoPlay: true,
      looping: true,
      allowFullScreen: false,
      showControls: false,
      showOptions: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
        child: Chewie(
      controller: chewieController,
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
