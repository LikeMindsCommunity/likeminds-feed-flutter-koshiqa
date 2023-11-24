import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_document_factory.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_link_view.dart';
import 'package:feed_sx/src/views/media_preview/media_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';
import 'package:media_kit_video/media_kit_video.dart';

class PostMediaFactory extends StatelessWidget {
  final Post post;
  final List<Attachment>? attachments;
  VideoController? videoController;

  PostMediaFactory({
    super.key,
    this.attachments,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (attachments!.isEmpty) {
      return const SizedBox.shrink();
    } else if (attachments!.first.attachmentType == 3) {
      return PostDocumentFactory(
          attachments: attachments, width: screenSize.width);
    } else if (attachments!.first.attachmentType == 4) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
            PostLinkView(screenSize: screenSize, attachment: attachments![0]),
      );
    } else {
      return GestureDetector(
        onTap: () async {
          await videoController?.player.pause();
          await Navigator.pushNamed(
            context,
            MediaPreviewScreen.routeName,
            arguments: MediaPreviewArguments(
              postAttachments: attachments!,
              post: post,
            ),
          );
          await videoController?.player.play();
        },
        child: LMPostMedia(
          attachments: attachments!,
          backgroundColor: kWhiteColor,
          initialiseVideoController: (controller) {
            videoController = controller;
          },
        ),
      );
    }
  }
}
