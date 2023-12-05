import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_document_factory.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_link_view.dart';
import 'package:feed_sx/src/views/media_preview/media_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';
import 'package:media_kit_video/media_kit_video.dart';

class PostMediaFactory extends StatefulWidget {
  final Post post;
  final List<Attachment>? attachments;
  final Function(VideoController)? initialiseVideoController;

  const PostMediaFactory({
    super.key,
    this.attachments,
    this.initialiseVideoController,
    required this.post,
  });

  @override
  State<PostMediaFactory> createState() => _PostMediaFactoryState();
}

class _PostMediaFactoryState extends State<PostMediaFactory> {
  VideoController? videoController;
  @override
  void dispose() {
    videoController?.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (widget.attachments!.isEmpty) {
      return const SizedBox.shrink();
    } else if (widget.attachments!.first.attachmentType == 3) {
      return PostDocumentFactory(
          attachments: widget.attachments, width: double.infinity);
    } else if (widget.attachments!.first.attachmentType == 4) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: PostLinkView(
            screenSize: Size.infinite, attachment: widget.attachments![0]),
      );
    } else {
      return GestureDetector(
        onTap: () async {
          await videoController?.player.pause();
          await Navigator.pushNamed(
            context,
            MediaPreviewScreen.routeName,
            arguments: MediaPreviewArguments(
              postAttachments: widget.attachments!,
              post: widget.post,
            ),
          );
          await videoController?.player.play();
        },
        child: LMPostMedia(
          height: screenSize.width,
          width: screenSize.width,
          boxFit: BoxFit.contain,
          attachments: widget.attachments!,
          initialiseVideoController: (controller) {
            videoController = controller;
          },
        ),
      );
    }
  }
}
