import 'dart:async';
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
  bool _onTouch = true;

  Timer? _timer;

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
      showControls: false,
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
          } else if (snapshot.connectionState == ConnectionState.done) {
            return StatefulBuilder(builder: (context, setChildState) {
              return Stack(children: [
                GestureDetector(
                  onTap: () {
                    setChildState(() {
                      _onTouch = !_onTouch;
                    });
                  },
                  child: Container(
                    width: widget.width,
                    height: widget.width,
                    color: kWhiteColor,
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: chewieController
                          .videoPlayerController.value.aspectRatio,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Chewie(
                          controller: chewieController,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Visibility(
                    visible: _onTouch,
                    child: Container(
                      alignment: Alignment.center,
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(const CircleBorder(
                              side: BorderSide(color: Colors.white))),
                        ),
                        child: Icon(
                          videoPlayerController.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _timer?.cancel();

                          // pause while video is playing, play while video is pausing
                          setChildState(() {
                            videoPlayerController.value.isPlaying
                                ? videoPlayerController.pause()
                                : videoPlayerController.play();
                          });

                          // Auto dismiss overlay after 1 second
                          _timer =
                              Timer.periodic(Duration(milliseconds: 1000), (_) {
                            setChildState(() {
                              _onTouch = false;
                            });
                          });
                        },
                      ),
                    ),
                  ),
                )
              ]);
            });
          } else {
            return const SizedBox();
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
