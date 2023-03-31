import 'package:feed_sx/src/views/feed/components/post/post_media/post_document_factory.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_link_view.dart';
import 'package:flutter/cupertino.dart';

import 'package:feed_sx/src/views/feed/components/post/post_media/post_media.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class PostMediaFactory extends StatelessWidget {
  final String postId;
  final List<Attachment>? attachments;

  const PostMediaFactory({
    super.key,
    this.attachments,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (attachments!.isEmpty) {
      return const SizedBox.shrink();
    } else if (attachments!.first.attachmentType == 3) {
      return postDocumentFactory(attachments, screenSize.width);
    } else if (attachments!.first.attachmentType == 4) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
            PostLinkView(screenSize: screenSize, attachment: attachments![0]),
      );
    } else {
      return PostMedia(
        attachments: attachments,
        postId: postId,
      );
    }
  }
}
