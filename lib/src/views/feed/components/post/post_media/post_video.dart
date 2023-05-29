import 'dart:async';
import 'dart:io';

import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

import 'package:feed_sx/src/views/feed/components/post/post_media/post_image_shimmer.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'package:visibility_detector/visibility_detector.dart';

class PostVideo extends StatefulWidget {
  final String? url;
  final File? videoFile;
  const PostVideo({super.key, this.url, this.videoFile});

  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  late final VideoPlayerController videoPlayerController;
  ValueNotifier<bool> rebuildOverlay = ValueNotifier(false);
  late ChewieController chewieController;
  bool _onTouch = true;
  bool initialiseOverlay = false;

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    videoPlayerController.dispose();
    rebuildOverlay.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> initialiseControllers() async {
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
    if (!videoPlayerController.value.isInitialized) {
      await videoPlayerController.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: initialiseControllers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const PostShimmer();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (!initialiseOverlay) {
            _timer = Timer.periodic(const Duration(milliseconds: 2500), (_) {
              initialiseOverlay = true;
              _onTouch = false;
              rebuildOverlay.value = !rebuildOverlay.value;
            });
          }
          return Stack(children: [
            GestureDetector(
              onTap: () {
                _onTouch = !_onTouch;
                rebuildOverlay.value = !rebuildOverlay.value;
              },
              child: VisibilityDetector(
                key: Key('post_video_${widget.url ?? widget.videoFile}'),
                onVisibilityChanged: (visibilityInfo) async {
                  var visiblePercentage = visibilityInfo.visibleFraction * 100;
                  if (visiblePercentage <= 50) {
                    videoPlayerController.pause();
                  }
                  if (visiblePercentage > 50) {
                    videoPlayerController.play();
                    rebuildOverlay.value = !rebuildOverlay.value;
                  }
                },
                child: Container(
                  width: screenSize.width,
                  height: screenSize.width,
                  color: kWhiteColor,
                  alignment: Alignment.center,
                  child: Chewie(
                    controller: chewieController,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder(
                  valueListenable: rebuildOverlay,
                  builder: (context, _, __) {
                    return Visibility(
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

                            videoPlayerController.value.isPlaying
                                ? videoPlayerController.pause()
                                : videoPlayerController.play();
                            rebuildOverlay.value = !rebuildOverlay.value;

                            // Auto dismiss overlay after 1 second
                            _timer = Timer.periodic(
                                const Duration(milliseconds: 2500), (_) {
                              _onTouch = false;
                              rebuildOverlay.value = !rebuildOverlay.value;
                            });
                          },
                        ),
                      ),
                    );
                  }),
            )
          ]);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
