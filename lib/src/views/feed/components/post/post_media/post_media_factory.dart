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
    if (attachments == null) {
      return const SizedBox.shrink();
    } else if (attachments!.first.attachmentType == 3) {
      return const SizedBox.shrink();
    } else {
      return PostMedia(
        attachments: attachments,
        postId: postId,
      );
    }
  }
}
