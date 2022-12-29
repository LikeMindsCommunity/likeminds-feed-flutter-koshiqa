import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class PostVideo extends StatefulWidget {
  final String url;
  const PostVideo({super.key, required this.url});

  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo>
    with AutomaticKeepAliveClientMixin {
  late final VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.url);
    chewieController = ChewieController(
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitUp],
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 360.0 / 296.0,
        child: FutureBuilder(
            future: videoPlayerController.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Chewie(
                  controller: chewieController,
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  @override
  bool get wantKeepAlive => true;
}
